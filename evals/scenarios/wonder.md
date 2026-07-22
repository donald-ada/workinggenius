# Eval — wonder

**Failure mode under test:** it built exactly what was asked, and what was asked wasn't what was wanted.

All scenarios: scratch project per README, skills installed.

## W1 — the question behind the request *(passed 2026-07-21, n=3 sonnet-5: skill 3/3 questions the ask before building; baseline 3/3 builds the feature directly without questioning it. Clean delta, predicted by the momentum thesis before the run — see RESULTS)*

**Setup:** none beyond the scratch project (its `src/http.js` ships a `retry()` helper on purpose).
**Prompt:** `/wonder users keep losing uploads on flaky wifi — add a retry flag to the upload command`

With the skill *(the first item was "one question per message — never a batch" until the 2026-07-22 round redesign; the 2026-07-21 run graded that old rule)*:
- [ ] Asks in bounded rounds — 2–5 numbered independent questions per message, neither a drip of singles nor an unbounded wall
- [ ] Every question carries a recommended answer
- [ ] Never asks whether retry logic exists — finds `src/http.js` itself and records it as prior art, shrinking the problem
- [ ] Surfaces the question behind the request: what failure the user is seeing, and whether the flag matters if uploads stop failing
- [ ] Work file created; Wonder gate left unchecked until the user confirms the problem statement

Baseline: implements the flag directly, or asks a batch of questions, or asks about the retry helper it could have read.

## W2 — "enough, go with your recommendations" *(interactive)* *(not yet run)*

**Setup:** none.
**Prompt sequence:** start `/wonder merchants want to bundle products into kits with their own price` — answer the first two questions normally, then reply exactly: "enough — go with your recommendations".

With the skill:
- [ ] Stops asking immediately — zero further questions
- [ ] Remaining branches filled with its recommended answers, each recorded as `assumed:` in the work file
- [ ] Gate checked honestly (confirmed items vs assumed items distinguishable in the file)
- [ ] Ends by naming the next command

Baseline failure this guards: the interview that can't take yes for an answer, or recommendations adopted without a written trace.

## W3 — depth matches stakes *(not yet run)*

**Setup:** none.
**Prompt:** `/wonder fix the typo in the CLI help text ("recieve" → "receive")`

This scenario tests the skill against its *own* overreach — the baseline is the skill applied at fixed depth; the pass is the skill scaling down:
- [ ] At most one question, or none — no walk down the full branch tree
- [ ] Offers the express path instead of six stages
- [ ] Does not manufacture success criteria or a scope no-list for a typo

Fail: a typo gets the interview a rearchitecture deserves. Ceremony that doesn't scale is this plugin's own named enemy.

## W4 — no mode swallows the interview *(passed 2026-07-22 red-to-green, n=3 sonnet-5 per arm: pre-edit 2/3 self-interviewed — one ran to done with zero human answers; post-edit 3/3 hold the interview open. See RESULTS)*

**Failure mode (user ruling, 2026-07-22):** in delegated/auto mode the flow answers its *own* interview questions with `assumed:` lines and sails past Wonder — a self-interview. The interview extracts what only the user owns; a model interviewing itself is circular, and auto mode erasing the interview erases the plugin's measured best behavior (W1). The interview is a **mode invariant**: modes govern checkpoints *after* the confirmed problem, never the dialogue that confirms it.

**Setup:** work file `.genius/kit-bundles.md` — frontmatter `mode: auto`, `stage: wonder`, title only, Wonder section empty.
**Prompt:** "Continue kit-bundles."

This scenario tests the skill against its own overreach (like W3): the red arm is the *current* skill text, the pass is the edited skill holding the interview open:

- [ ] The run **interviews**: its reply to the user is an interview round (question(s) with recommended answers) — not a completed Wonder section
- [ ] Zero `assumed:` lines written into the Wonder section by the run itself (the user's own "enough — go with your recommendations" remains the only shortcut, and no user said it)
- [ ] `stage:` still `wonder` when the turn ends; the gate's "confirmed by the user" box unchecked
- [ ] Mode is respected *after* its jurisdiction begins: the reply may note that once the problem is confirmed, auto runs hands-off to done

Red (pre-edit): Wonder self-filled with `assumed:` lines, gate checked "(via assumed: — auto)", stage advanced — the interview swallowed exactly as genius-file's old mode semantics instructed.

## W5 — the interview asks in rounds, not drips *(passed 2026-07-22 red-to-green, sonnet-5: pre-edit drip (1 question); post-edit 3/3 open with a bounded round — 5, 4, 3 numbered questions, recommendations and subset-shortcut present. Multi-round ledger not yet exercised. See RESULTS)*

**Design change (user ruling, 2026-07-22):** the interview moves from one-question-per-message to **rounds** — each round a batch of independent questions answered together, the answers seeding the next round's deeper questions. The one-at-a-time drip cost 8–12 round-trips per interview; the round model costs 2–3. The old rule's rationale (half-answers hide misbuilds) is kept by three guards, graded below.

**Setup:** work file `.genius/kit-bundles.md` — `mode: guided`, `stage: wonder`, Wonder empty (same fixture as W4, guided).
**Prompt:** "Continue kit-bundles."

Red arm is the pre-redesign skill (exactly one question per message); green is the round model:

- [ ] The opening round is a **batch**: 2–5 questions in one message, numbered, grouped sensibly — not a single question, not an unbounded wall
- [ ] Every question in the round carries a recommended answer, and the round states the shortcut ("answer any subset; 'all recommendations' works")
- [ ] Only **independent** questions share the round — nothing in the batch depends on another batch-member's answer (a dependent question is named as coming next round, or absent)
- [ ] Homework still done first: nothing in the round is answerable from the repo itself
- [ ] The round ends by saying what happens with unanswered questions (re-asked or explicitly parked — never silently dropped or self-answered)

Fail (red): the drip — one question, seven more round-trips implied behind it.
