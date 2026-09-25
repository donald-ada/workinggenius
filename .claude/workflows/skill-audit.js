export const meta = {
  name: 'skill-audit',
  description: 'Audit the plugin skills: scan, parallel lens auditors, three-skeptic verification, completeness critic, report and proposed diff',
  whenToUse: 'When the skills under skills/ need a prompt audit — after a model release, before a version bump that rewrites several skills, or when a skill misbehaves and the cause may be its prose. Args: skill names to narrow the scope, and quick | standard | deep.',
  phases: [
    { title: 'Scan', detail: 'inventory and signal counts, taken by the instrument' },
    { title: 'Audit', detail: 'per-skill and plugin-wide lenses, in parallel' },
    { title: 'Verify', detail: 'three skeptics per finding, each through one lens' },
    { title: 'Critic', detail: 'what the audit missed, verified the same way' },
    { title: 'Report', detail: 'report and proposed diff, checked in a scratch worktree' },
  ],
}

// ---- arguments ---------------------------------------------------------------
// Typed as `/skill-audit wonder enable deep` the args arrive as one string; passed
// from the Workflow tool they may be an object {skills, depth, date}. Both work.
const DEPTHS = ['quick', 'standard', 'deep']
function parseArgs(a) {
  const o = { skills: [], depth: 'standard', date: null }
  if (!a) return o
  if (typeof a === 'object' && !Array.isArray(a)) {
    return { skills: a.skills || [], depth: DEPTHS.includes(a.depth) ? a.depth : 'standard', date: a.date || null }
  }
  const words = Array.isArray(a) ? a : String(a).split(/[\s,]+/)
  for (const w of words.map(x => String(x).trim()).filter(Boolean)) {
    const bare = w.replace(/^--?/, '').replace(/^depth=/, '')
    if (DEPTHS.includes(bare)) o.depth = bare
    else if (/^\d{4}-\d\d-\d\d$/.test(bare)) o.date = bare
    else o.skills.push(bare.replace(/^skills\//, '').replace(/\/$/, ''))
  }
  return o
}
const opts = parseArgs(args)

// ---- schemas -----------------------------------------------------------------
const FINDING = {
  type: 'object',
  properties: {
    file: { type: 'string', description: 'repo-relative path' },
    line_start: { type: 'integer' },
    line_end: { type: 'integer' },
    quote: { type: 'string', description: 'the exact text, verbatim' },
    pattern: { type: 'string', description: 'the LENSES.md pattern it matches' },
    why: { type: 'string', description: 'why it hurts on the models these skills run on, one or two sentences' },
    confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
    action: { type: 'string', enum: ['remove', 'rewrite', 'move', 'add', 'flag'] },
    replacement: { type: 'string', description: 'for rewrite/add: the full replacement text; empty otherwise' },
    destination: { type: 'string', description: 'for move: where the text goes; empty otherwise' },
  },
  required: ['file', 'line_start', 'quote', 'pattern', 'why', 'confidence', 'action'],
}
const FINDINGS = {
  type: 'object',
  properties: { findings: { type: 'array', items: FINDING } },
  required: ['findings'],
}
const VERDICT = {
  type: 'object',
  properties: {
    verdict: { type: 'string', enum: ['upheld', 'refuted'] },
    evidence: { type: 'string', description: 'what decided it: the command and its output, the keep-list item, the commit' },
    corrected_replacement: { type: 'string', description: 'when upheld but the proposed fix is wrong: the fix it should be' },
  },
  required: ['verdict', 'evidence'],
}
const SCAN = {
  type: 'object',
  properties: {
    date: { type: 'string' },
    out: { type: 'string' },
    units: { type: 'array', items: { type: 'object', properties: { name: { type: 'string' }, files: { type: 'array', items: { type: 'string' } } }, required: ['name', 'files'] } },
    summary: { type: 'string', description: 'the summary table, verbatim' },
  },
  required: ['date', 'out', 'units', 'summary'],
}
const REPORT = {
  type: 'object',
  properties: {
    report: { type: 'string' },
    diff: { type: 'string' },
    checks: { type: 'string', description: 'the repository checks run on the patched tree, command → result' },
    headline: { type: 'string', description: 'the two or three highest-impact findings, in prose' },
  },
  required: ['report', 'diff', 'checks', 'headline'],
}

// ---- the lenses (their questions live in .claude/skill-audit/LENSES.md) --------
const PER_SKILL = opts.depth === 'quick' ? ['dated-prompting+house-contract'] : ['dated-prompting', 'house-contract']
const PLUGIN_WIDE = opts.depth === 'quick' ? ['routing'] : ['routing', 'one-home', 'claude-code-mechanics', 'handoffs']
const SKEPTICS = opts.depth === 'quick' ? ['evidence'] : ['evidence', 'keep-list', 'provenance']
const CRITIC_ROUNDS = { quick: 0, standard: 1, deep: 4 }[opts.depth]
const LEDGER = '.claude/skill-audit/DECLINED.md'

// A project agent is used by type when the session registered it; otherwise the same
// brief is read from its file, so a session started before the agent existed still runs.
async function briefed(type, prompt, o) {
  let r = null
  try { r = await agent(prompt, { ...o, agentType: type }) } catch (e) { r = null }
  if (r !== null && r !== undefined) return r
  return agent(`Your brief is .claude/agents/${type}.md: read it first and follow it as your system prompt.\n\n${prompt}`, o)
}

// ---- Scan ----------------------------------------------------------------------
phase('Scan')
const scan = await agent(
  `Take the skill audit's scan. From the repository root:
1. \`date +%F\` gives the run date${opts.date ? ` — use ${opts.date} instead` : ''}; the run folder is \`.claude/audit-runs/<date>\`.
2. \`python3 .claude/skill-audit/scan.py json <run folder>/scan.json\`, then \`python3 .claude/skill-audit/scan.py summary\`.
3. \`python3 .claude/skill-audit/scan.py units\` lists one unit per line: its name, then its files.
Return the date, the run folder, every unit with its files, and the summary verbatim. Change nothing else.`,
  { label: 'scan', phase: 'Scan', schema: SCAN, effort: 'low' })
if (!scan) throw new Error('the scan did not return; nothing to audit')

const known = new Set(scan.units.map(u => u.name))
const unknown = opts.skills.filter(s => !known.has(s))
if (unknown.length) log(`not skills, ignored: ${unknown.join(', ')}`)
if (opts.skills.length && unknown.length === opts.skills.length) throw new Error(`no skill named ${unknown.join(', ')}; the units are ${[...known].join(', ')}`)
const units = opts.skills.length ? scan.units.filter(u => opts.skills.includes(u.name)) : scan.units
log(`${opts.depth} audit of ${units.length} skill(s) into ${scan.out}`)

const tasks = [
  ...units.flatMap(u => PER_SKILL.map(lens => ({ lens, scope: u.name, files: u.files }))),
  ...PLUGIN_WIDE.map(lens => ({ lens, scope: 'the whole plugin', files: [], focus: opts.skills })),
]

function auditPrompt(t) {
  const lenses = t.lens.split('+')
  return `Lens: ${lenses.map(l => `\`${l}\``).join(' and ')} — ${lenses.length > 1 ? 'the sections' : 'the section'} of .claude/skill-audit/LENSES.md.
Scope: ${t.files.length ? `the skill \`${t.scope}\`: ${t.files.join(', ')}` : `the whole plugin — every skills/*/SKILL.md, reference file and agents/*.md${t.focus && t.focus.length ? `, with your findings limited to what touches ${t.focus.join(', ')}` : ''}`}.
Scan: ${scan.out}/scan.json (the summary is below).
Ledger: ${LEDGER}.

${scan.summary}`
}

// Two lenses can land on the same line; the first to arrive keeps it and the
// duplicate is logged, never silently merged. Plain code, not a judgment.
const seen = new Map()
function keyOf(f) { return `${f.file}:${f.line_start}` }
function isDuplicate(f) {
  for (const [k, g] of seen) {
    if (g.file === f.file && Math.abs(g.line_start - f.line_start) <= 2 && g.action === f.action) return k
  }
  return null
}
function admit(fs, source) {
  const fresh = []
  for (const f of fs) {
    const dup = isDuplicate(f)
    if (dup) { log(`${source}: ${keyOf(f)} duplicates ${dup}, kept once`); continue }
    const tagged = { ...f, lens: source }
    seen.set(keyOf(f), tagged)
    fresh.push(tagged)
  }
  return fresh
}

function verifyPrompt(f, lens) {
  return `Your lens: \`${lens}\` (.claude/skill-audit/LENSES.md, Verification). Ledger: ${LEDGER}.
Refute this finding if you can:

${JSON.stringify(f, null, 1)}`
}

// Verification: skeptics per finding, blind to each other; a majority upholds.
// A flag or a low-confidence finding is reported, never put in the diff, so it
// is not worth three skeptics.
async function verify(f) {
  if (f.action === 'flag' || f.confidence === 'low') return { ...f, status: 'flag', votes: [] }
  const votes = (await parallel(SKEPTICS.map(lens => () =>
    briefed('audit-skeptic', verifyPrompt(f, lens), { label: `${lens}:${f.file.replace(/^skills\//, '')}:${f.line_start}`, phase: 'Verify', schema: VERDICT })
      .then(v => v && { lens, ...v })))).filter(Boolean)
  const upheld = votes.filter(v => v.verdict === 'upheld')
  const need = Math.floor(SKEPTICS.length / 2) + 1
  const corrected = upheld.map(v => v.corrected_replacement).find(Boolean)
  return { ...f, status: upheld.length >= need ? 'confirmed' : 'refuted', votes, ...(corrected ? { replacement: corrected, corrected: true } : {}) }
}

// ---- Audit → Verify, pipelined: a lens's findings verify while other lenses still read.
phase('Audit')
const lost = []
const round1 = await pipeline(
  tasks,
  t => briefed('skill-auditor', auditPrompt(t), { label: `${t.lens}:${t.scope}`, phase: 'Audit', schema: FINDINGS }),
  (r, t) => {
    if (!r) { lost.push(`${t.lens}:${t.scope}`); return [] }
    return admit(r.findings || [], t.lens)
  },
  fs => parallel(fs.map(f => () => verify(f))),
)
if (lost.length) log(`lens runs that returned nothing, so not covered: ${lost.join(', ')}`)
let results = round1.filter(Boolean).flat()

// ---- Critic: loop until it comes back dry (deep), or one pass (standard).
phase('Critic')
let dry = 0
for (let round = 1; round <= CRITIC_ROUNDS && dry < (opts.depth === 'deep' ? 2 : 1); round++) {
  const ledger = results.map(f => `- [${f.status}] ${f.file}:${f.line_start} (${f.lens}) ${f.pattern}`).join('\n')
  const more = await briefed('skill-auditor',
    `Lens: completeness critic. Read .claude/skill-audit/LENSES.md whole. The audit below has run over ${units.map(u => u.name).join(', ')}; its findings so far, each already verified or refuted, are listed. Ask what it missed: a lens question nobody put to a skill, a signal line in ${scan.out}/scan.json nobody read, a contradiction between two skills that each lens saw only half of, a refuted finding whose refutation was wrong about a different line. Return only findings not already listed; an empty list is a result.
Ledger: ${LEDGER}.

${ledger || '(no findings yet)'}`,
    { label: `critic round ${round}`, phase: 'Critic', schema: FINDINGS })
  const fresh = admit((more && more.findings) || [], 'critic')
  log(`critic round ${round}: ${fresh.length} new`)
  if (!fresh.length) { dry++; continue }
  dry = 0
  results = results.concat(await parallel(fresh.map(f => () => verify(f))))
}

const confirmed = results.filter(f => f.status === 'confirmed')
const refuted = results.filter(f => f.status === 'refuted')
const flags = results.filter(f => f.status === 'flag')
log(`${confirmed.length} confirmed, ${refuted.length} refuted, ${flags.length} flagged`)

// ---- Report: the report and the diff, the diff checked on a scratch tree.
phase('Report')
const report = await agent(
  `Write the skill audit's two deliverables into ${scan.out}/ from the verified findings below. Change nothing in the working tree.

1. **${scan.out}/report.md** — at the top: the date, the scope (${units.map(u => u.name).join(', ')}), the depth (${opts.depth}), the target models (as .claude/skill-audit/LENSES.md states them), counts per lens and per status, and the two or three highest-impact confirmed findings in prose. Then every confirmed finding, highest confidence first: location \`file:line\`, the quoted text, pattern, why, confidence, action and replacement, and the skeptics' votes one line each. Then the flags. Then the refuted findings one line each with the evidence that refuted them, because a refutation is what keeps the next run from raising them again.
2. **${scan.out}/proposed.diff** — one hunk per confirmed finding with action remove, rewrite, move or add, at high or medium confidence. Build it on a scratch worktree so the working tree is never touched: \`git worktree add --detach ${scan.out}/tree HEAD\`, make each edit there (a \`move\` whose destination is a commit message is listed in the report, not the diff), then \`git -C ${scan.out}/tree diff > ${scan.out}/proposed.diff\`. Two findings on one passage are reconciled into one edit. Where an edit changes skills/ and the change would merge, the release rule in CLAUDE.md applies: say in the report that plugin.json's version must move, and do not bump it in the diff.
3. In the scratch tree, run the checks CLAUDE.md names under Commands (the relative-link check, the frontmatter/instrument check), and \`grep -rn\` evals/ for every string a hunk removes. Record each as \`command → result\`. A hunk that breaks a check is fixed or dropped, and the report says which.
4. \`git worktree remove --force ${scan.out}/tree\`.

Return the two paths, the checks, and the headline.

Verified findings:
${JSON.stringify({ confirmed, flags, refuted: refuted.map(f => ({ file: f.file, line: f.line_start, lens: f.lens, pattern: f.pattern, quote: f.quote, votes: f.votes })) }, null, 1)}`,
  { label: 'report', phase: 'Report', schema: REPORT, effort: 'high' })

return {
  out: scan.out,
  depth: opts.depth,
  scope: units.map(u => u.name),
  counts: { confirmed: confirmed.length, refuted: refuted.length, flagged: flags.length, lens_runs: tasks.length, lens_runs_lost: lost },
  report,
}
