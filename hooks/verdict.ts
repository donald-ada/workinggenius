import type { ModelCompleteResult } from 'claude-code'

/**
 * The reason a judging model gave for blocking, read off its reply: the one
 * JSON object in the text, and only a clear `{"ok": false, "reason": "…"}`
 * counts. Anything else — no JSON, `ok: true`, a reason missing, a reply the
 * engine could not get — is undefined, and the stop is allowed.
 */
export function reasonOf(reply: ModelCompleteResult | string): string | undefined {
  const text = typeof reply === 'string' ? reply : reply.isAnswered ? reply.text : ''
  const json = text.match(/\{[\s\S]*\}/)
  if (!json) return undefined
  try {
    const parsed = JSON.parse(json[0]) as { ok?: unknown; reason?: unknown }
    const isBlock = parsed.ok === false && typeof parsed.reason === 'string' && parsed.reason.length > 0
    return isBlock ? (parsed.reason as string) : undefined
  } catch {
    return undefined
  }
}

/**
 * One `## <key>` section of judge-conditions.md: the text from its heading to
 * the next `##` heading or the end, trimmed. The file is the conditions' one
 * home, read by stop-judge.py the same way.
 */
export function conditionOf(body: string, key: string): string | undefined {
  const lines = body.split('\n')
  const start = lines.findIndex(line => line === `## ${key}`)
  if (start < 0) return undefined
  let end = lines.findIndex((line, i) => i > start && line.startsWith('## '))
  if (end < 0) end = lines.length
  const text = lines.slice(start + 1, end).join('\n').trim()
  return text.length > 0 ? text : undefined
}

/**
 * Whether the instrument's `status` output lists a work at enablement or
 * tenacity: the one frontmatter field the judge reads, read through
 * measure.py so the counting keeps its one home.
 */
export function isInBuild(status: string): boolean {
  return /stage: (enablement|tenacity)\b/.test(status)
}

/**
 * The stop's own signal that a subagent or workflow is still running: a
 * pause, not a stall, and the same check the classic hook makes.
 */
export function hasRunningTask(tasks: readonly { type: string }[] | undefined): boolean {
  return (tasks ?? []).some(task => task.type === 'subagent' || task.type === 'workflow')
}
