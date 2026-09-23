import type { On } from 'claude-code'
import { describe, expect, test, tier } from 'claude-code/testing'

import { conditionOf, hasRunningTask, isInBuild, reasonOf } from '../hooks/verdict'

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

const STALL = 'Slice 1 closed. Next I will dispatch slice 2 to a builder.'
const BLOCK_REASON = 'Dispatching is doing: the step you announced is yours to take now.'

/** The world beneath the judge, answered from memory: the conditions file, the instrument, the model. */
function seat(
  on: On,
  world: { status?: string; verdict?: string; failing?: 'process' | 'model' },
): { completions: string[]; logged: string[]; classicRan: number } {
  const seen = { completions: [] as string[], logged: [] as string[], classicRan: 0 }
  on('env.get', () => ({ value: undefined }))
  on('fs.read', () => ({ value: CONDITIONS }))
  on('ui.log', ($, e) => {
    seen.logged.push(e.text)
    return { value: undefined }
  })
  on('process.run', () => {
    if (world.failing === 'process') throw new Error('no python here')
    return { value: { exitCode: 0, stdout: world.status ?? STATUS_IN_BUILD, stderr: '' } }
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
})
