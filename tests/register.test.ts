import type { On, RenderSurface, SessionMessage } from 'claude-code'
import { describe, expect, mock, test, tier } from 'claude-code/testing'

import {
  compactNoteOf,
  conditionOf,
  hasRunningTask,
  isInBuild,
  isInFlight,
  originNoteOf,
  paneLinesOf,
  reasonOf,
  snapshotLineOf,
  snapshotSlugOf,
  statusLineOf,
} from '../hooks/verdict'

tier('user')

const CONDITIONS = [
  'Preamble the readers skip.',
  '',
  '## coordinator',
  'Decide one thing about the coordinator.',
  '',
  '## builder',
  'Decide one thing about the builder.',
].join('\n')

const STATUS_IN_BUILD = [
  'work dir: .genius/ (default, nothing pinned)',
  'in flight (1):',
  '- demo — stage: enablement · contract: v1 · next: /enable demo, slice 2 · snapshot 3000 chars',
  'done: 0 (no HISTORY.md)',
].join('\n')

const STATUS_IDLE = STATUS_IN_BUILD.replace('stage: enablement', 'stage: invention')

const STATUS_TWO = STATUS_IN_BUILD.replace('in flight (1):', 'in flight (2):').replace(
  'done: 0',
  '- other — stage: wonder · contract: none · next: /wonder · snapshot 900 chars, 900 roster excluded\ndone: 0',
)

const STATUS_NONE = 'work dir: .genius/ (default, nothing pinned)\nin flight: none\ndone: 2 (HISTORY.md: 2 lines)\nbacklog: 3 seeds, 0 past the 300-character line bound'

const SNAPSHOTS = [
  '- demo (enablement) — 6412 chars whole, 6100 roster excluded — over the ceiling ⚠ of 6000',
  '- other (wonder) — 900 chars whole, 900 roster excluded — under the ceiling of 6000',
].join('\n')

const STALL = 'Slice 1 closed. Next I will dispatch slice 2 to a builder.'
/** The one message a compaction leaves at least. */
const ONE_MESSAGE: SessionMessage = { role: 'user', text: 'Build slice 2.', toolUses: [] }
const BLOCK_REASON = 'Dispatching is doing: the step you announced is yours to take now.'

/** The world beneath the judge, answered from memory: the conditions file, the instrument, the model. */
function seat(
  on: On,
  world: { status?: string; verdict?: string; failing?: 'process' | 'model'; closedByPerson?: boolean; surfaces?: RenderSurface[] },
): {
  completions: string[]
  logged: string[]
  status: (string | undefined)[]
  opened: string[]
  closed: string[]
  stored: [string, unknown][]
  registered: string[]
  submitted: (readonly string[] | undefined)[]
  classicRan: number
} {
  const seen = {
    completions: [] as string[],
    logged: [] as string[],
    status: [] as (string | undefined)[],
    opened: [] as string[],
    closed: [] as string[],
    stored: [] as [string, unknown][],
    registered: [] as string[],
    submitted: [] as (readonly string[] | undefined)[],
    classicRan: 0,
  }
  on('env.get', () => ({ value: undefined }))
  on('fs.read', () => ({ value: CONDITIONS }))
  on('ui.log', ($, e) => {
    seen.logged.push(e.text)
    return { value: undefined }
  })
  on('process.run', ($, e) => {
    if (world.failing === 'process') throw new Error('no python here')
    const isSnapshots = e.argv.includes('snapshots')
    return { value: { exitCode: 0, stdout: isSnapshots ? SNAPSHOTS : (world.status ?? STATUS_IN_BUILD), stderr: '' } }
  })
  on('ui.status', ($, e) => {
    seen.status.push(e.text)
    return { value: undefined }
  })
  on('command.register', ($, e) => ({ value: { command: e.name } }))
  on('ui.open', ($, e) => {
    seen.opened.push(e.id)
    return { value: { isPlaced: true } }
  })
  on('ui.close', ($, e) => {
    seen.closed.push(e.id)
    return { value: undefined }
  })
  on('ui.invalidate', () => ({ value: undefined }))
  on('store.get', () => ({ value: world.closedByPerson === true ? true : undefined }))
  on('store.set', ($, e) => {
    seen.stored.push([e.key, e.value])
    return { value: undefined }
  })
  on('tool.register', ($, e) => {
    seen.registered.push(e.name)
    return { value: { tool: `mcp__workinggenius__${e.name}` } }
  })
  on('session.surfaces', () => ({ value: world.surfaces ?? ['terminal'] }))
  on('prompt.submit', ($, e) => {
    seen.submitted.push(e.context)
    return { text: e.text }
  })
  on('model.complete', ($, e) => {
    if (world.failing === 'model') throw new Error('api down')
    seen.completions.push(e.prompt)
    return {
      value: {
        isAnswered: true,
        text: world.verdict ?? '{"ok": true}',
        usage: { input_tokens: 1, output_tokens: 1, cache_read_input_tokens: 0, cache_creation_input_tokens: 0 },
      },
    }
  })
  // the settings hooks beneath: reached only when the module passes the stop on with next(e)
  on('classic.Stop', () => {
    seen.classicRan += 1
    return {}
  })
  on('classic.SubagentStop', () => {
    seen.classicRan += 1
    return {}
  })
  return seen
}

describe('verdict', () => {
  test('only a clear ok:false with a reason blocks', async () => {
    expect(reasonOf('{"ok": false, "reason": "do it now"}')).toBe('do it now')
    expect(reasonOf('Sure. {"ok": false, "reason": "wrapped in prose"}')).toBe('wrapped in prose')
    expect(reasonOf('{"ok": true}')).toBeUndefined()
    expect(reasonOf('{"ok": false}')).toBeUndefined()
    expect(reasonOf('not json at all')).toBeUndefined()
    expect(reasonOf('{"ok": false, "reason": ')).toBeUndefined()
    expect(reasonOf({ isAnswered: false, reason: 'empty-reply' } as never)).toBeUndefined()
  })

  test('a condition is one ## section, trimmed, and a missing key is undefined', async () => {
    expect(conditionOf(CONDITIONS, 'coordinator')).toBe('Decide one thing about the coordinator.')
    expect(conditionOf(CONDITIONS, 'builder')).toBe('Decide one thing about the builder.')
    expect(conditionOf(CONDITIONS, 'reviewer')).toBeUndefined()
  })

  test('the instrument decides whether a work is in build; a running task is a pause', async () => {
    expect(isInBuild(STATUS_IN_BUILD)).toBe(true)
    expect(isInBuild(STATUS_IDLE)).toBe(false)
    expect(isInBuild('work dir: .genius/ — not present; nothing in flight')).toBe(false)
    expect(hasRunningTask([{ type: 'subagent' }])).toBe(true)
    expect(hasRunningTask([{ type: 'shell' }])).toBe(false)
    expect(hasRunningTask(undefined)).toBe(false)
  })

  test('work in flight is read off the status line, and the compaction note carries the status verbatim', async () => {
    expect(isInFlight(STATUS_IN_BUILD)).toBe(true)
    expect(isInFlight(STATUS_IDLE)).toBe(true)
    expect(isInFlight('work dir: .genius/ (default, nothing pinned)\nin flight: none\ndone: 2')).toBe(false)
    expect(isInFlight('work dir: .genius/ — not present; nothing in flight, no history, no backlog')).toBe(false)
    const note = compactNoteOf(STATUS_IN_BUILD)
    expect(note).toContain('re-read that snapshot whole')
    expect(note).toContain('next: /enable demo, slice 2')
  })

  test('the status line shows one work as its slug, stage and next, several as a count, none as nothing', async () => {
    expect(statusLineOf(STATUS_IN_BUILD)).toBe('Working Genius · demo · enablement · next: /enable demo, slice 2')
    expect(statusLineOf(STATUS_TWO)).toBe('Working Genius · 2 in flight · /genius')
    expect(statusLineOf(STATUS_NONE)).toBeUndefined()
  })

  test('the map\'s lines come from the status: a block per work, then the counts; nothing in flight says how to start', async () => {
    const lines = paneLinesOf(STATUS_IN_BUILD).map(l => `${l.kind}: ${l.text}`)
    expect(lines[0]).toBe('title: Working Genius')
    expect(lines).toContain('work: demo · enablement')
    expect(lines).toContain('next: next: /enable demo, slice 2')
    expect(lines.some(l => l.startsWith('detail: snapshot 3000 chars'))).toBe(true)
    expect(lines).toContain('dim: done: 0 (no HISTORY.md)')
    expect(paneLinesOf(STATUS_NONE).map(l => l.kind)).toEqual(['title', 'dim', 'dim', 'dim'])
    expect(paneLinesOf(undefined).length).toBe(2)
  })

  test('a snapshot is the file named for its folder, and its count is the instrument\'s line', async () => {
    expect(snapshotSlugOf('/w/.genius/demo/demo.md')).toBe('demo')
    expect(snapshotSlugOf('C:\\w\\.genius\\demo\\demo.md')).toBe('demo')
    expect(snapshotSlugOf('/w/.genius/demo/demo.log.md')).toBeUndefined()
    expect(snapshotSlugOf('/w/.genius/demo/CONTRACT.md')).toBeUndefined()
    expect(snapshotSlugOf('/w/README.md')).toBeUndefined()
    expect(snapshotLineOf(SNAPSHOTS, 'demo')).toBe('Working Genius instrument, after this write: demo (enablement) — 6412 chars whole, 6100 roster excluded — over the ceiling ⚠ of 6000')
    expect(snapshotLineOf(SNAPSHOTS, 'nope')).toBeUndefined()
  })
})

describe('register', () => {
  test('unarmed, a stop passes straight through to the settings hooks: no instrument, no model', async ($, on) => {
    const seen = seat(on, {})
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    expect(seen.classicRan).toBe(1)
    expect(seen.completions).toEqual([])
  })

  test('/enable arms it without changing the skill text; then a stall is blocked with the model\'s reason', async ($, on) => {
    const seen = seat(on, { verdict: `{"ok": false, "reason": "${BLOCK_REASON}"}` })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    const { text } = await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build one slice.' })
    expect(text).toBe('Build one slice.')

    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBe(BLOCK_REASON)
    expect(seen.completions.length).toBe(1)
    expect(seen.completions[0]).toContain(STALL)
    expect(seen.classicRan).toBe(0)
  })

  test('armed, an allowed stop is answered by the module alone: the settings hook beneath does not judge again', async ($, on) => {
    const seen = seat(on, { verdict: '{"ok": true}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:tenacity', text: 'Verify.' })
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: 'Slice 2 closed; evidence in the log. Which slice next?' })
    expect(r.block).toBeUndefined()
    expect(seen.completions.length).toBe(1)
    expect(seen.classicRan).toBe(0)
  })

  test('armed, the three free checks allow without asking the model', async ($, on) => {
    const seen = seat(on, { verdict: '{"ok": false, "reason": "never asked"}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build.' })

    let r = await $.classic.Stop({ stop_hook_active: true, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL, background_tasks: [{ id: 'a', type: 'subagent', status: 'running', description: 'a builder' }] })
    expect(r.block).toBeUndefined()
    expect(seen.completions).toEqual([])
  })

  test('armed, no work at enablement or tenacity means nothing to judge', async ($, on) => {
    const seen = seat(on, { status: STATUS_IDLE, verdict: '{"ok": false, "reason": "never asked"}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build.' })
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    expect(seen.completions).toEqual([])
  })

  test('the instrument failing (no python) allows the stop and hands it to the settings hooks beneath', async ($, on) => {
    const seen = seat(on, { failing: 'process', verdict: '{"ok": false, "reason": "would block"}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build.' })
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    expect(seen.classicRan).toBe(1)
  })

  test('the model failing allows the stop and hands it to the settings hooks beneath', async ($, on) => {
    const seen = seat(on, { failing: 'model', verdict: '{"ok": false, "reason": "would block"}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build.' })
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    expect(seen.classicRan).toBe(1)
  })

  test('a builder\'s claim without evidence is blocked; another agent type passes through', async ($, on) => {
    const seen = seat(on, { verdict: '{"ok": false, "reason": "Hand back evidence, not a claim."}' })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:enable', text: 'Build.' })

    const claim = { stop_hook_active: false, agent_id: 'b1', agent_transcript_path: '', last_assistant_message: 'Slice 3 is done and all tests pass.' }
    let r = await $.classic.SubagentStop({ ...claim, agent_type: 'workinggenius:builder' })
    expect(r.block).toBe('Hand back evidence, not a claim.')
    expect(seen.completions.length).toBe(1)

    r = await $.classic.SubagentStop({ ...claim, agent_type: 'workinggenius:reviewer' })
    expect(r.block).toBeUndefined()
    expect(seen.completions.length).toBe(1)
    expect(seen.classicRan).toBe(1)
  })

  test('each test starts with a fresh module: the arming of the tests above has not leaked here', async ($, on) => {
    const seen = seat(on, { verdict: '{"ok": false, "reason": "would block"}' })
    const r = await $.classic.Stop({ stop_hook_active: false, last_assistant_message: STALL })
    expect(r.block).toBeUndefined()
    expect(seen.classicRan).toBe(1)
    expect(seen.completions).toEqual([])
  })

  test('a compaction with work in flight carries the note on its instructions, after what the person typed', async ($, on) => {
    seat(on, {})
    let handed: string | undefined
    on('session.compact', ($, e) => {
      handed = e.instructions
      return { messages: e.messages }
    })
    await $.session.compact({ trigger: 'manual', instructions: 'keep the numbers', messages: [ONE_MESSAGE] })
    expect(handed?.startsWith('keep the numbers')).toBe(true)
    expect(handed).toContain('next: /enable demo, slice 2')
  })

  test('a compaction with nothing in flight, or no instrument, passes through as it came', async ($, on) => {
    seat(on, { status: 'work dir: .genius/ — not present; nothing in flight, no history, no backlog' })
    let handed: string | undefined = 'unset'
    on('session.compact', ($, e) => {
      handed = e.instructions
      return { messages: e.messages }
    })
    await $.session.compact({ trigger: 'auto', messages: [ONE_MESSAGE] })
    expect(handed).toBeUndefined()
  })

  test('work in flight at the start pins the status line, and each finished turn refreshes it', async ($, on) => {
    const seen = seat(on, {})
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    on('turn.complete', () => ({ text: 'done' }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    expect(seen.status).toEqual(['Working Genius · demo · enablement · next: /enable demo, slice 2'])
    await $.turn.complete({ reason: 'answer', turnId: 't1', durationMs: 1, answer: 'done' } as never)
    expect(seen.status.length).toBe(2)
  })

  test('nothing in flight at the start: no status line, and a turn runs no instrument until the flow is entered', async ($, on) => {
    const seen = seat(on, { status: STATUS_NONE })
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    on('turn.complete', () => ({ text: 'done' }))
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    await $.turn.complete({ reason: 'answer', turnId: 't1', durationMs: 1, answer: 'done' } as never)
    expect(seen.status).toEqual([])
    await $.skill.prompt({ skill: 'workinggenius:genius', text: 'the map' })
    await $.turn.complete({ reason: 'answer', turnId: 't2', durationMs: 1, answer: 'done' } as never)
    expect(seen.status).toEqual([undefined])
  })

  test('a write that lands on a snapshot carries the instrument\'s count as context; other writes do not', async ($, on) => {
    seat(on, {})
    on('tool.call', () => ({ result: { type: 'text', file: { filePath: 'x', content: '' } } as never }))
    const r = await $.tool.call({ tool: 'Write', file_path: '/w/.genius/demo/demo.md', content: '# Demo' })
    expect(r.context?.[0]).toContain('6100 roster excluded — over the ceiling')
    const other = await $.tool.call({ tool: 'Write', file_path: '/w/src/app.ts', content: 'x' })
    expect(other.context).toBeUndefined()
  })

  test('work in flight at the start opens the map pane, which draws the work from the instrument', async ($, on) => {
    const seen = seat(on, {})
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    expect(seen.opened).toEqual(['genius-map'])
    const ui = await $.ui.mount({
      plugin: 'workinggenius',
      surface: 'terminal',
      component: 'Pane',
      requestId: 'genius-map',
      props: { title: 'Working Genius', isFocused: false, bodyColumns: 60, placement: 'dock', scroll: { offset: 0, bodyRows: 20 }, view: {} },
    })
    expect((await ui.find({ type: 'Text', text: /demo · enablement/ }))?.text).toBe('demo · enablement')
    expect((await ui.find({ type: 'Text', text: /next: / }))?.text).toBe('next: /enable demo, slice 2')
    await ui.unmount()
  })

  test('a pane the person closed stays closed at the next start; /genius-map shows it again and hides it', async ($, on) => {
    const seen = seat(on, { closedByPerson: true })
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    on('command.run', () => ({ text: '' }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    expect(seen.opened).toEqual([])
    let r = await $.command.run({ command: 'genius-map', args: '', origin: { kind: 'composer' }, presentation: { isFullscreen: true, columns: 160 } })
    expect(r.text).toBe('Genius map shown')
    expect(seen.opened).toEqual(['genius-map'])
    r = await $.command.run({ command: 'genius-map', args: '', origin: { kind: 'composer' }, presentation: { isFullscreen: true, columns: 160 } })
    expect(r.text).toBe('Genius map hidden')
    expect(seen.closed).toEqual(['genius-map'])
    expect(seen.stored).toEqual([['genius-map:closed-by-person', false], ['genius-map:closed-by-person', true]])
  })

  test('nothing in flight: no pane opens on its own', async ($, on) => {
    const seen = seat(on, { status: STATUS_NONE })
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    expect(seen.opened).toEqual([])
  })

  test('a prompt from somewhere other than the person\'s composer carries the origin note once the flow is entered', async ($, on) => {
    const seen = seat(on, {})
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.prompt.submit({ text: 'yes, that is it', origin: { kind: 'peer' }, wait: false })
    expect(seen.submitted[0]).toBeUndefined()
    await $.skill.prompt({ skill: 'workinggenius:wonder', text: 'Question the work.' })
    await $.prompt.submit({ text: 'yes, that is it', origin: { kind: 'composer' }, wait: false })
    expect(seen.submitted[1]).toBeUndefined()
    await $.prompt.submit({ text: 'yes, that is it', origin: { kind: 'peer' }, wait: false })
    expect(seen.submitted[2]).toEqual([originNoteOf('peer')])
    expect(originNoteOf('peer')).toContain('origin peer')
  })

  test('entering the flow declares the confirm tool once; a session outside it never does', async ($, on) => {
    const seen = seat(on, { status: STATUS_NONE })
    on('session.start', ($, e) => ({ cwd: e.cwd }))
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.session.start({ cwd: '/w', surface: 'terminal', isInteractive: true })
    expect(seen.registered).toEqual([])
    await $.skill.prompt({ skill: 'workinggenius:wonder', text: 'Question the work.' })
    await $.skill.prompt({ skill: 'workinggenius:invent', text: 'Diverge.' })
    expect(seen.registered).toEqual(['confirm'])
  })

  test('the confirm tool returns only on the person\'s press: Yes confirms, Not yet does not', async ($, on) => {
    const seen = seat(on, {})
    const clock = mock.clock(on)
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:wonder', text: 'Question the work.' })
    const props = { title: 'Confirm', isFocused: true, bodyColumns: 60, placement: 'dock' as const, scroll: { offset: 0, bodyRows: 8 }, view: {} }

    const asked = $.tool.call({ tool: 'mcp__workinggenius__confirm', statement: 'Per-user rate limiting, 100 requests a minute, 429 beyond it.' })
    await clock.settle()
    expect(seen.opened).toContain('wg-confirm')
    let ui = await $.ui.mount({ plugin: 'workinggenius', surface: 'terminal', component: 'Pane', requestId: 'wg-confirm', props })
    expect((await ui.find({ type: 'Text', text: /100 requests/ }))?.text).toContain('100 requests a minute')
    await ui.press({ key: 'yes' })
    await ui.unmount()
    const confirmed = await asked
    expect(confirmed.text).toContain("Confirmed by the person's press")
    expect(confirmed.text).toContain('100 requests a minute')

    const askedAgain = $.tool.call({ tool: 'mcp__workinggenius__confirm', statement: 'The batch endpoint.' })
    await clock.settle()
    ui = await $.ui.mount({ plugin: 'workinggenius', surface: 'terminal', component: 'Pane', requestId: 'wg-confirm', props })
    await ui.press({ key: 'no' })
    await ui.unmount()
    expect((await askedAgain).text).toContain('Not yet')
  })

  test('with nobody pressing, the confirmation ends after ten minutes unconfirmed; with no surface it says so at once', async ($, on) => {
    seat(on, {})
    const clock = mock.clock(on)
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:wonder', text: 'Question the work.' })
    const asked = $.tool.call({ tool: 'mcp__workinggenius__confirm', statement: 'Anything.' })
    await clock.settle()
    await clock.advance(10 * 60 * 1000)
    expect((await asked).text).toContain('No press within ten minutes')
  })

  test('headless, the confirm tool answers at once that nobody can press here', async ($, on) => {
    seat(on, { surfaces: [] })
    on('skill.prompt', ($, e) => ({ text: e.text }))
    await $.skill.prompt({ skill: 'workinggenius:wonder', text: 'Question the work.' })
    const r = await $.tool.call({ tool: 'mcp__workinggenius__confirm', statement: 'Anything.' })
    expect(r.text).toContain('No surface to press on')
  })
})

