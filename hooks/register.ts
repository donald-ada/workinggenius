import type { EngineInterface, Register } from 'claude-code'

import {
  compactNoteOf,
  conditionOf,
  hasRunningTask,
  isInBuild,
  isInFlight,
  reasonOf,
  snapshotLineOf,
  snapshotSlugOf,
  statusLineOf,
} from './verdict'

/** The plugin's directory: this module is hooks/register.ts, so one level up. */
// import.meta.url is the module's own file at run time (measured on 2.1.280); the declarations do not type it.
const ROOT = new URL('..', (import.meta as { url?: string }).url ?? '').pathname.replace(/\/$/, '')
const MEASURE = `${ROOT}/skills/genius-file/measure.py`
const CONDITIONS = `${ROOT}/skills/genius-file/judge-conditions.md`
const MODEL = 'haiku'
const MESSAGE_TAIL = 6000
const ARMING = /(^|:)(enable|tenacity)$/
/** The discipline skills the three agents preload: a `skill.prompt` of one is the measurement CLAUDE.md names as missing. */
const PRELOADS = /^workinggenius:(genius-file|record-prose|decision-record)$/

/**
 * Whether /enable or /tenacity was invoked in this session. The module is
 * installed with the plugin and loads in every session; the judge is armed by
 * invocation and never by installation, so a session that typed neither has
 * no judge, exactly as the classic hooks in those skills' frontmatter behave.
 */
let armed = false
/**
 * Whether the flow was entered in this session — a workinggenius skill
 * expanded, or work was in flight when the session started — which is what
 * the status line waits for: a session that never entered it gets no line
 * and runs no instrument at its turns.
 */
let entered = false
let logPath: string | undefined
/** Log writes queue behind one another: three preloads expand at once, and a read-modify-write of the file would keep one line of three. */
let writing: Promise<void> = Promise.resolve()

/**
 * One line per decision: to the file WG_STOP_JUDGE_LOG names, the same file
 * stop-judge.py writes, so a measurement reads both judges in one place;
 * otherwise to the debug log. Never to the transcript.
 */
async function log($: EngineInterface, line: string): Promise<void> {
  const write = async (): Promise<void> => {
    try {
      logPath ??= (await $.env.get('WG_STOP_JUDGE_LOG')) ?? ''
      if (logPath === '') {
        $.ui.log(`workinggenius judge: ${line}`, { to: 'debug' })
        return
      }
      let prior = ''
      try {
        prior = await $.fs.read(logPath)
      } catch {
        prior = ''
      }
      await $.fs.write(logPath, `${prior}[hook] ${line}\n`)
    } catch {
      // a log that cannot be written is not a reason to change a decision
    }
  }
  writing = writing.then(write)
  return writing
}

/** The instrument's status, or undefined where it could not run: the one thing the module reads about the work. */
async function statusOf($: EngineInterface): Promise<string | undefined> {
  const r = await $.process.run(['python3', MEASURE, 'status'], { timeoutMs: 10_000 })
  return r.exitCode === 0 ? r.stdout : undefined
}

/** The status line under the prompt, from the instrument's status: set, replaced, or cleared when nothing is in flight. */
async function refreshStatusLine($: EngineInterface): Promise<void> {
  const status = await statusOf($)
  $.ui.status(status === undefined ? undefined : statusLineOf(status))
}

/**
 * After a write that landed on a snapshot, the instrument's count of it as
 * context beneath the tool's result: the number at the moment of the action
 * (the format's ceiling is checked there), read from `measure.py snapshots`.
 */
async function withSnapshotCount($: EngineInterface, filePath: string, context: readonly string[] | undefined): Promise<readonly string[] | undefined> {
  const slug = snapshotSlugOf(filePath)
  if (slug === undefined) return context
  const r = await $.process.run(['python3', MEASURE, 'snapshots'], { timeoutMs: 10_000 })
  const line = r.exitCode === 0 ? snapshotLineOf(r.stdout, slug) : undefined
  if (line === undefined) return context
  entered = true
  return [...(context ?? []), line]
}

/** The instrument, not a parser: does `measure.py status` list a work at enablement or tenacity. */
async function isWorkInBuild($: EngineInterface): Promise<boolean> {
  const status = await statusOf($)
  return status !== undefined && isInBuild(status)
}

/**
 * One completion over the session's own client: the condition as the system
 * prompt, the turn's last message alone — never the transcript — as the one
 * user message. The reason to block, or undefined.
 */
async function judge($: EngineInterface, key: string, message: string): Promise<string | undefined> {
  const conditions = await $.fs.read(CONDITIONS)
  const condition = conditionOf(conditions, key)
  if (condition === undefined) {
    await log($, `allow: no condition '${key}' in judge-conditions.md`)
    return undefined
  }
  const reply = await $.model.complete({
    model: MODEL,
    system: condition,
    prompt: `<message>\n${message.slice(-MESSAGE_TAIL)}\n</message>`,
    maxTokens: 200,
  })
  return reasonOf(reply)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    try {
      const status = await statusOf($)
      if (status !== undefined && isInFlight(status)) {
        entered = true
        $.ui.status(statusLineOf(status))
      }
    } catch {
      // no instrument here (no python, a surface without process.run): no line, nothing else changes
    }
    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    const r = await next(e)
    if (entered) {
      try {
        await refreshStatusLine($)
      } catch {
        // as above
      }
    }
    return r
  })

  on('tool.call', { tool: 'Write' }, async ($, e, next) => {
    const r = await next(e)
    if (e.tool !== 'Write' || r.deny !== undefined || r.isError) return r
    try {
      return { ...r, context: await withSnapshotCount($, e.file_path, r.context) }
    } catch {
      return r
    }
  })

  on('tool.call', { tool: 'Edit' }, async ($, e, next) => {
    const r = await next(e)
    if (e.tool !== 'Edit' || r.deny !== undefined || r.isError) return r
    try {
      return { ...r, context: await withSnapshotCount($, e.file_path, r.context) }
    } catch {
      return r
    }
  })

  on('skill.prompt', async ($, e, next) => {
    if (e.skill.startsWith('workinggenius:')) entered = true
    if (ARMING.test(e.skill)) {
      if (!armed) await log($, `armed by ${e.skill}`)
      armed = true
    } else if (PRELOADS.test(e.skill)) {
      await log($, `skill.prompt ${e.skill}`)
    }
    return next(e)
  })

  on('session.compact', async ($, e, next) => {
    try {
      const status = await statusOf($)
      if (status === undefined || !isInFlight(status)) return next(e)
      const note = compactNoteOf(status)
      const instructions = e.instructions === undefined ? note : `${e.instructions}\n\n${note}`
      await log($, `session.compact ${e.trigger}: the work-file note rides the instructions`)
      return next({ ...e, instructions })
    } catch (err) {
      await log($, `session.compact ${e.trigger}: passed through (${String(err)})`)
      return next(e)
    }
  })

  on('classic.Stop', async ($, e, next) => {
    if (!armed) return next(e)
    try {
      const message = (e.last_assistant_message ?? '').trim()
      if (e.stop_hook_active) {
        await log($, 'Stop allow: stop_hook_active')
        return {}
      }
      if (message === '') return {}
      if (hasRunningTask(e.background_tasks)) {
        await log($, 'Stop allow: background task running')
        return {}
      }
      if (!(await isWorkInBuild($))) {
        await log($, 'Stop allow: no work at enablement or tenacity')
        return {}
      }
      const reason = await judge($, 'coordinator', message)
      if (reason !== undefined) {
        await log($, `Stop block: ${reason}`)
        return { block: reason }
      }
      await log($, 'Stop allow: ok')
      return {}
    } catch (err) {
      // the judge's own failure: allow, and let the classic hook beneath have its say
      await log($, `Stop allow: judge failed (${String(err)})`)
      return next(e)
    }
  })

  on('classic.SubagentStop', async ($, e, next) => {
    if (!armed || !e.agent_type.includes('builder')) return next(e)
    try {
      const message = (e.last_assistant_message ?? '').trim()
      if (e.stop_hook_active) {
        await log($, 'SubagentStop allow: stop_hook_active')
        return {}
      }
      if (message === '') return {}
      const reason = await judge($, 'builder', message)
      if (reason !== undefined) {
        await log($, `SubagentStop block: ${reason}`)
        return { block: reason }
      }
      await log($, 'SubagentStop allow: ok')
      return {}
    } catch (err) {
      await log($, `SubagentStop allow: judge failed (${String(err)})`)
      return next(e)
    }
  })
}
