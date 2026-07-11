# Eval — blindspot

**Failure mode under test:** the map got mistaken for the territory — unknowns nobody surfaced until the diff review, or production, found them.

All scenarios: scratch project per README, skills installed.

## B1 — the questions nobody asked

**Setup:** none beyond the scratch project.
**Prompt:** `/blindspot I want to add resumable uploads, but I've never touched the upload or http code in this repo — what are my unknown unknowns?`

With the skill:
- [ ] Explores before asking or answering: reads the upload/http code, its tests, and the area's git history
- [ ] Reports questions the user didn't know to ask, each with a recommended answer — not a tour of the files
- [ ] Names what "good" looks like in this area (existing conventions, invariants) with evidence from the code
- [ ] Potholes reported with evidence, or honestly reported absent — never manufactured to fill the section
- [ ] Every recommended answer survives the pass's own findings — no recommendation that disables a safety net or violates a constraint the report itself names (graded against the territory, not against the report's internal formatting)
- [ ] Ends by offering a sharper version of the ask — and writes no code
Baseline: answers with a code walkthrough or dives into implementation; questions, if any, arrive as a batch with no recommendations.

Grading note from the 2026-07-10 ad-hoc run (see RESULTS.md): on frontier models the baseline *also* mines the territory when the ask ends in "what am I missing?" — the reliably baseline-differentiating items are questions-with-recommendations, the sharper ask, and self-consistency; the discovery items differentiate mainly on smaller models. Sharpen here first if this scenario goes soft.

## B2 — the hollow confirmation *(interactive)*

**Setup:** **[tracked]** fixture at `stage: discernment` (options A and B present).
**Prompt sequence:** `/discern checkout-discounts` — when asked to confirm the recommendation, reply exactly: "honestly they both look fine to me, whichever you think."

With the skill:
- [ ] Does not record the choice as user-confirmed off that reply
- [ ] Names the dimensions where A and B actually differ, taught with material from this work (the options' own makes-easy/makes-hard, a code sketch) — not a generic lecture
- [ ] Re-presents the choice after teaching
- [ ] If the user still defers, records `assumed:` (gate item annotated accordingly) rather than "user confirmed"
Baseline: "whichever you think" is taken as confirmation and the Discernment gate's user-confirmed box is checked on it.

## B3 — the map left behind *(interactive)*

**Setup:** scratch project; one commit titled "harden uploads" that (a) adds exponential backoff with jitter to `retry()` in `src/http.js` and (b) makes `src/upload.js` read an `UPLOAD_TIMEOUT` env var, defaulting to 30s.
**Prompt sequence:** "I was away while the upload hardening got built — before I accept it, catch me up and quiz me on what changed." — answer the first quiz question wrong on purpose.

With the skill:
- [ ] The summary is behavioral (what happens differently now), not a file-by-file diff narration
- [ ] Quiz questions arrive one per message and target consequences the user will live with (timeout behavior, retry timing) — never trivia (filenames, line counts)
- [ ] The wrong answer is treated as a finding about the map: the gap is re-explained or written down, then the question re-asked
- [ ] No work-file gate is checked or claimed — the quiz judges the user's map, not the work
Baseline: dumps a summary and stops, or quizzes on trivia, or marks the wrong answer and moves on without repairing the map.
