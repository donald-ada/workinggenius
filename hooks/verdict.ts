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

/**
 * Whether the instrument's `status` output lists any work in flight: the
 * compaction note rides only where there is a snapshot to re-read.
 */
export function isInFlight(status: string): boolean {
  const m = status.match(/^in flight \((\d+)\):/m)
  return m !== null && Number(m[1]) > 0
}

/**
 * The note appended to a compaction's instructions where work is in flight:
 * what the summary must keep, and the instrument's own status verbatim so
 * the slugs and `next:` commands survive as written. No parsing, no decision.
 */
export function compactNoteOf(status: string): string {
  return [
    'This session is working on a piece of work tracked in Working Genius work files. Keep in the summary:',
    'the work\'s slug, its stage, its exact `next:` command, and the paths of its snapshot',
    '(`<work dir>/<slug>/<slug>.md`) and of the `CONTRACT.md` beside it. The first act after this',
    'compaction is to re-read that snapshot whole: the file outranks this summary. The instrument\'s',
    'status as compaction began:',
    '',
    status.trim(),
  ].join('\n')
}

/** One work in flight as the instrument's `status` lists it: the line's own format, never a work file's. */
export type InFlight = { slug: string; stage: string; next: string }

/**
 * The works in flight, read off the instrument's `status` lines
 * (`- <slug> — stage: <stage> · contract: <v> · next: <command> · snapshot …`).
 */
export function inFlightOf(status: string): InFlight[] {
  const works: InFlight[] = []
  for (const line of status.split('\n')) {
    const m = line.match(/^- (\S+) — stage: (\S+) · contract: \S+ · next: (.*?) · snapshot /)
    if (m) works.push({ slug: m[1] as string, stage: m[2] as string, next: m[3] as string })
  }
  return works
}

/**
 * The plugin's status line under the prompt: one work's slug, stage and
 * `next:` as the snapshot states it; several works as a count pointing at
 * `/genius`; none as no line. It shows, never suggests: the command is the
 * file's own line, the same one `/genius` prints.
 */
export function statusLineOf(status: string): string | undefined {
  const works = inFlightOf(status)
  const one = works[0]
  if (one === undefined) return undefined
  if (works.length === 1) return `Working Genius · ${one.slug} · ${one.stage} · next: ${one.next}`
  return `Working Genius · ${works.length} in flight · /genius`
}

/**
 * The slug a written path names as a snapshot — the format puts it at
 * `<work dir>/<slug>/<slug>.md`, the file named for its folder — else
 * undefined. A path of that shape outside the work dir costs one
 * `measure.py snapshots` run that lists no such slug.
 */
export function snapshotSlugOf(path: string): string | undefined {
  const m = path.replace(/\\/g, '/').match(/(?:^|\/)([^/]+)\/([^/]+)\.md$/)
  return m !== null && m[1] === m[2] ? m[1] : undefined
}

/**
 * The instrument's `snapshots` line for a slug, framed as the context that
 * follows a write of that snapshot: the count, at the moment of the action,
 * and never a decision.
 */
export function snapshotLineOf(snapshots: string, slug: string): string | undefined {
  const line = snapshots.split('\n').find(l => l.startsWith(`- ${slug} (`))
  return line === undefined ? undefined : `Working Genius instrument, after this write: ${line.slice(2)}`
}

/** One line of the map pane, by the weight it is drawn with. */
export type PaneLine = { kind: 'title' | 'work' | 'next' | 'detail' | 'dim'; text: string }

/**
 * The map's lines, from the instrument's status: one block per work in
 * flight (slug and stage, the `next:` command, the snapshot's count against
 * the ceiling and the slices), then the done and backlog counts. Display
 * only: it re-frames the instrument's output and decides nothing.
 */
export function paneLinesOf(status: string | undefined): PaneLine[] {
  const lines: PaneLine[] = [{ kind: 'title', text: 'Working Genius' }]
  if (status === undefined) {
    lines.push({ kind: 'dim', text: 'The instrument has not answered yet.' })
    return lines
  }
  const detailOf = new Map<string, string>()
  for (const line of status.split('\n')) {
    const m = line.match(/^- (\S+) — stage: \S+ · contract: \S+ · next: .*? · (snapshot .*)$/)
    if (m) detailOf.set(m[1] as string, m[2] as string)
  }
  const works = inFlightOf(status)
  if (works.length === 0) lines.push({ kind: 'dim', text: 'Nothing in flight. /genius <idea> starts a piece of work.' })
  for (const work of works) {
    lines.push({ kind: 'work', text: `${work.slug} · ${work.stage}` })
    lines.push({ kind: 'next', text: `next: ${work.next}` })
    const detail = detailOf.get(work.slug)
    if (detail !== undefined) lines.push({ kind: 'detail', text: detail })
  }
  for (const line of status.split('\n')) {
    if (/^(done:|backlog:)/.test(line)) lines.push({ kind: 'dim', text: line })
  }
  return lines
}

