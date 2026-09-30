# The audit's lenses

One home for what each lens looks for, what the skeptics test a finding against, and what the audit may never flag. The `/skill-audit` workflow names a lens; the `skill-auditor` agent reads its section here; the `audit-skeptic` reads *Verification* and *The keep list*. Adapted from the Claude API skill's `prompt-audit` guide (its anti-pattern groups, keep list, confidence rubric and report contract) and narrowed to this repository, whose own rules in `CLAUDE.md` bind harder than any general pattern.

**The prime directive, from prompt-audit:** a finding is a specific instruction that hurts on the models these skills run on, tied to a named pattern below with a reason. It is never "this could be shorter". A lens that finds nothing returns nothing; an empty report beats a manufactured one, because every false finding costs a fix and the next audit's credibility.

**The target model.** These skills run inside Claude Code on whatever model the user picked — the evals run the smoke case on haiku and the flow cases on sonnet, and sessions run on the current Opus and Fable families. Current Claude models follow instructions closely and literally, plan without being told, and are proactive by default; a line written for a model that needed shouting or a script now over-applies. Where a finding depends on the model, say which.

## Per-skill lenses

Run once per skill folder (its `SKILL.md`, its reference files, its `agents/*.md`).

### dated-prompting

prompt-audit's Groups 1 and 2, read against this skill:

- **Pressure language** — caps `MUST/NEVER/ALWAYS`, stacked ⚠ markers, emphasis with no reason beside it, and the reverse: `try to / if possible / ideally` attached to what is actually required, which a literal model reads as permission to skip. The house style puts a reason in the same sentence as every rule, so emphasis *with* its reason is not the pattern; emphasis doing the work a reason should do is.
- **Emphasis with no measured failure behind it** — for each bolded rule, ⚠ marker, `never` or `always`, ask what goes wrong if it is written as a plain sentence: can the skill, its commit history or `FORMAT-EDGES.md` name a failure a run actually showed? Where one is named, the emphasis stays. Where none is, it is a finding (action: rewrite as a plain sentence, the reason kept), because a literal model applies every `never` to cases its writer did not have in mind, and a skill where every rule is bold has no bold rule.
- **Scaffolds** — "think step by step", required reasoning sections, numeric word caps, fixed narration cadences. Effort and thinking are configuration, not prose.
- **Over-specification** — step choreography for judgment work, runs of prohibitions describing a failure the model was not going to make (a prohibition can anchor toward the failure it names), single gold examples the model will copy, strategy coaching ("it's usually best to") beside rules. A `## How it runs` list is the house form for a stage and is not choreography by itself; it becomes the pattern when it scripts a judgment the concept already carries.
- **Fossils** — text that outlived its occasion: relative phrasing that diffs against a rule the reader never saw ("no longer", "now"), patch accretion (narrow conditionals, each from one incident, where a principle would do), instructions nothing checks and nobody would miss.
- **Brittle skill file** — history narratives in the body (dates, run records, commit hashes, version pins, "measured" stories: those belong in commit messages and `FORMAT-EDGES.md`, per `CLAUDE.md`, and a skill that carries them spends every trigger on archaeology); volatile specifics with no re-check; wrong degrees of freedom (an exact script for a judgment call, vague prose for a fragile command); the recency trap (one run's stumble made permanent).

### house-contract

This repository's own rules for how a skill is written (`CLAUDE.md`, *How skills are written* and *Architecture*), checked against this skill:

- The skill carries its purpose, its failure mode, the concept in one bold line, and one threshold that must be honestly true before the next stage; a stage skill also carries `## How it runs`.
- Every rule states its why in the same sentence. A rule whose reason is missing, or whose reason does not support it, is the finding.
- Action constraints stay firm (live interview, red before green, fresh verification, wounds found never manufactured, findings with evidence); taxonomies are floors, not scripts.
- Each rule has one home. A rule this skill restates instead of pointing at its owner (`FILE-FORMAT.md` for the compaction question, `record-prose` for sentences, `errata` for corrections, `BACKLOG-FORMAT.md` for seeds) is a finding when the copies differ or when the copy is long enough to drift.
- The layers: what binds is rewritten in place, what records is appended to; a skill telling a model to edit a log, or to append to a binding file, contradicts `errata`.
- Read as a fresh model would, literally: a sentence two readers could follow two different ways, an instruction that contradicts another in the same skill, a term used before or without its definition, a step the model cannot perform with the tools the skill grants.

## Plugin-wide lenses

Run once over the whole plugin; they see what one skill's reader cannot.

### routing

Every frontmatter `description` read side by side, because that is how the model meets them. Model-invoked skills whose descriptions would fire on the same request (a collision the model resolves by chance); a description that would fire on an ordinary request that never entered the flow (the `no-hijack` ruling); a description too vague to fire when it should; a user-typed command (`disable-model-invocation: true`) whose description still reads as a trigger, or a model-invoked skill that should only ever be typed; an `argument-hint` that disagrees with what the body does with `$ARGUMENTS`. Routing text may carry calibrated urgency — skills under-trigger — so emphasis here is judged by whether it routes correctly, not by volume.

### one-home

The scan's shared-wording pairs are the start, not the list. A rule stated in two skills whose copies now disagree; a pointer to a rule's home that points at the wrong file or at a section that moved; a rule with no home at all (stated only in passing inside an unrelated skill). Working redundancy that agrees is not a finding (keep list, 8) unless it is long enough that the next edit to either copy will drift it — say which.

### claude-code-mechanics

The parts only Claude Code reads. Frontmatter that parses but does not mean what the author meant (a field Claude Code does not read, a misspelt key, a `hooks` block under an agent — ignored with a warning, per `CLAUDE.md`); `allowed-tools` patterns that do not match the command the body injects or runs, so it prompts and aborts; `!` injections that can fail; `${CLAUDE_SKILL_DIR}` where only `${CLAUDE_PLUGIN_ROOT}` is substituted (skill-frontmatter hooks); preloads naming a skill that does not exist; `plugin.json` registration; the judge script's failure paths. And the other direction — a Claude Code feature that would enforce what a skill now asks for in prose (prompt-audit 1d: "enforce in code what can be enforced in code"), **only** where `CLAUDE.md` has not already ruled on it: hooks, parsers of work-file prose, express paths, autonomy modes and gate checklists are killed designs (`0cc21de`, `925accf`, `275ed4f`, `f8897e9`) and the judges are frozen experiments; a proposal that reopens one names the measured counter-example or is not made.

### handoffs

The flow as a chain of contracts. For each stage, what it writes (which file, which section, which shape) against what the next stage and `genius-file`'s `FILE-FORMAT.md` say is there to read; the subagents' task messages as each spawning skill describes them against what each agent brief says it receives and hands back (one home each); the cross-work files (`BACKLOG.md`, `DECIDED.md`, `HISTORY.md`) against every skill that writes them. A field one side writes and nobody reads, or reads and nobody writes, is the finding.

## Verification

Each surviving finding is put to three skeptics, each through one lens, each trying to refute it; a finding stands when at least two uphold it.

- **evidence** — Is the quoted text at the cited `file:line`, verbatim? Does the claimed failure actually follow from it for a model reading literally — or does context nearby already defuse it? Would the proposed fix break a pointer, an eval grader (`evals/**`), the instrument's parsing (`measure.py` reads headings and field names), or another skill's reference? Grep before answering.
- **keep-list** — Does anything in *The keep list* below protect this text? Does the finding confuse length with harm, or trigger text with behavior text?
- **provenance** — `git log -S'<phrase>' -- <file>` and the commit message that added the line: which failure did it answer, and does that failure still apply? Does a user ruling in `CLAUDE.md` or a killed design settle it? A line with a measured reason is not cruft because it is emphatic; a line nobody can justify is suspect.

## The keep list

prompt-audit's keep list, binding on every lens and every skeptic, plus this repository's own:

1. Context is never cruft — the reasons behind constraints, environment facts, the quality bar.
2. Length is not harm; never justify a finding by character count alone.
3. Fragile operations keep exact commands (the pinned quiet verify commands, the injected instrument calls, the `allowed-tools` patterns).
4. Contract detail stays — what a subagent receives and hands back, what a file's fields mean.
5. A prohibition against a failure measured in this repository stays (the commit that added it says so).
6. Routing text may carry calibrated urgency.
7. A format-pinning example on a genuinely format-sensitive output stays (the work-file shapes, the seed line, the post-mortem line).
8. Working redundancy is not cruft unless the copies disagree or will.
9. A deliberate closing recap is not padding.
10. Re-fitting can add text: a missing reason, an under-described agent brief, a trigger that never fires.
11. **This repository's rulings.** A user ruling recorded in `CLAUDE.md` (dated `user ruling, <date>`), a killed design (its commit), and the one-home map in `CLAUDE.md` are settled; a finding that contradicts one is refuted unless it carries measured evidence against the specific leg it breaks.

## Confidence and action

From prompt-audit's report contract. **High** — errors or misroutes observably, or contradicts the repository's own written rule. **Medium** — a documented pattern above with a reason grounded in current-model behavior. **Low** — idiom only, no reason beyond resemblance; reported as `flag`, never in the diff. Actions: `remove`, `rewrite` (with the replacement text), `move` (say where — usually the commit message or `FORMAT-EDGES.md` for history), `add` (the missing reason or contract, written out), `flag`. A documented-pattern match is not downgraded to `flag` because it seems minor; the user can decline a hunk, but cannot accept one never written.
