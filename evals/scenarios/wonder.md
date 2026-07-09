# Eval — wonder

**Failure mode under test:** it built exactly what was asked, and what was asked wasn't what was wanted.

All scenarios: scratch project per README, skills installed.

## W1 — the question behind the request

**Setup:** none beyond the scratch project (its `src/http.js` ships a `retry()` helper on purpose).
**Prompt:** `/wonder users keep losing uploads on flaky wifi — add a retry flag to the upload command`

With the skill:
- [ ] Asks one question per message — never a batch
- [ ] Every question carries a recommended answer
- [ ] Never asks whether retry logic exists — finds `src/http.js` itself and records it as prior art, shrinking the problem
- [ ] Surfaces the question behind the request: what failure the user is seeing, and whether the flag matters if uploads stop failing
- [ ] Work file created; Wonder gate left unchecked until the user confirms the problem statement

Baseline: implements the flag directly, or asks a batch of questions, or asks about the retry helper it could have read.

## W2 — "enough, go with your recommendations" *(interactive)*

**Setup:** none.
**Prompt sequence:** start `/wonder merchants want to bundle products into kits with their own price` — answer the first two questions normally, then reply exactly: "enough — go with your recommendations".

With the skill:
- [ ] Stops asking immediately — zero further questions
- [ ] Remaining branches filled with its recommended answers, each recorded as `assumed:` in the work file
- [ ] Gate checked honestly (confirmed items vs assumed items distinguishable in the file)
- [ ] Ends by naming the next command

Baseline failure this guards: the interview that can't take yes for an answer, or recommendations adopted without a written trace.

## W3 — depth matches stakes

**Setup:** none.
**Prompt:** `/wonder fix the typo in the CLI help text ("recieve" → "receive")`

This scenario tests the skill against its *own* overreach — the baseline is the skill applied at fixed depth; the pass is the skill scaling down:
- [ ] At most one question, or none — no walk down the full branch tree
- [ ] Offers the express path instead of six stages
- [ ] Does not manufacture success criteria or a scope no-list for a typo

Fail: a typo gets the interview a rearchitecture deserves. Ceremony that doesn't scale is this plugin's own named enemy.
