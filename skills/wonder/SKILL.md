---
name: wonder
description: Question the work before doing it — the interview that turns a raw idea into a confirmed problem statement. Use when a tracked piece of work is at its wonder stage, or when starting the Working Genius flow on a new idea.
argument-hint: "the idea or request to question"
---

# Wonder

The genius of questioning. Most failed work fails here first: the agent built exactly what was asked, and what was asked was not what was wanted. Wonder closes that gap before any design exists.

Run the `genius-file` skill: create the work file (or read it if it exists) and work in its Wonder section.

## The interview

The interview runs until the problem statement survives restatement — the user says "yes, that's it" to words *you* wrote back to them. It proceeds in **rounds**: each round a small batch of questions the user answers together, their answers seeding the next, deeper round. Walk the branches below through the rounds — earlier branches anchor later ones, and a round may span branches when its questions are independent.

Rules of the interview:

- **The interview is live dialogue in every mode — the mode invariant.** `delegated` and `auto` govern checkpoints *after* the confirmed problem; they never auto-answer the interview. Whatever the work file's `mode:`, arriving here means stopping and interviewing the user — never filling the branches with your own `assumed:` answers and moving on, which is a self-interview: circular, confirming nothing. The only shortcut is the **user's own** "enough — go with your recommendations" (see below). User unreachable? The work waits at Wonder.
- **Open with the story, not the questions.** Real reviews start with the walkthrough; play it back: before Round 1, tell the user the story you'd build as you currently understand it — a short step-wise narrative of what the finished thing will do, grounded in what the repo actually has — and offer it for correction ("which step is wrong?"). Correcting a story is far cheaper for the user than answering from zero, and the wrong step *is* the round's best question: anchor Round 1's questions to the story's uncertain points, naming the step each probes.
- **Ask in rounds, not drips.** One message per round, carrying 2–5 numbered questions grouped by theme and ordered by importance. The drip (one question, eight round-trips) taxes the user's attention; the wall (ten questions) taxes their patience — the bounded round is the deliberate middle.
- **For full-sized work, consider a perspective panel before Round 1.** Fresh subagents — QA, operations, security, end-user advocate — each handed the work file *path* (never a summary), each returning the questions its role exists to ask, with recommended answers. Measured (`evals/RESULTS.md` 2026-07-22): role-isolated scouts surface whole categories a single context told to wear the same hats misses — at ~a third redundancy, ~4× cost, and blind to premise. So the panel feeds and the interviewer curates: dedup hard, keep your own premise/scope questions first (the most gating question in the measured run came from the interviewer, not the panel), and skip the panel when express-sized work or an already-clear round wouldn't repay four subagents. Dispatch foreground (enable's rule: coordinating means staying awake).
- **Only independent questions share a round.** A question whose wording depends on another's answer waits for the next round — name it ("depending on #2, I'll have a follow-up on refunds"). When everything left is dependent, the round shrinks to one question: the drip is the degenerate case, not the default.
- **Keep a question ledger across rounds.** A question the user skipped is re-asked next round or explicitly parked *with them* — never silently dropped, and never self-answered (the mode invariant owns that line). Half-answers are where misbuilds hide; the ledger is what keeps a batch from leaking them.
- **Every question arrives with your best answer attached.** You've read code the user may not have loaded; "A or B? I'd pick A, because…" can be answered with one word. And every round states its shortcut: answer any subset — "all your recommendations" settles the whole round at once.
- **Look it up before you ask it.** Whatever the repo, the history, or the docs can settle is homework, not a question. What's left for the user is the one thing only they own: what they actually want.
- **Depth matches stakes.** A contained change earns one small round; work that creates concepts, crosses interfaces, or is expensive to redo earns the full tree over several rounds. The interview ends when the gate below can be checked honestly — not when the questions run out.
- **The user can call it.** "Enough — go with your recommendations" is a legitimate answer at any point: fill the remaining branches with your recommended answers, record each as `assumed:` in the work file, and move on.
- **Ask the question behind the request.** "Add a retry button" is a solution wearing a problem's clothes. What failure is the user actually seeing? Would they still want the button if the failure went away?
- **Collide words with the glossary.** Run the `domain-glossary` skill as the interview runs — it owns the collision discipline; terms resolve on the spot, never batched. The interview is where the project's language gets sharp — that sharpness outlives this piece of work.
- **Unfamiliar territory gets a pass before questions.** When the user names the area as unknown to them, or answers keep coming back "I don't know", run the `blindspot` skill's territory pass — an interview only asks questions someone thought of; the pass finds the ones nobody did. Its questions then join this interview.

Branches to walk (skip any the conversation has already settled):

1. **The problem** — what hurts, for whom, how often? What happens if we do nothing?
2. **What already exists** — in a mature codebase the ask is often half-built. Record the prior art with evidence, and shrink the problem to the genuine gap. "Build much less than asked" is Wonder's best outcome in a large project.
3. **Worth doing?** — Wonder has standing to challenge the premise. If the work looks like it shouldn't happen, say so with reasons. "Don't build this" is a successful outcome, not a failed one.
4. **Success** — what observable change proves it worked? Numbers, behaviors, absences of complaints — not implementation.
5. **Scope edges** — what nearby things are explicitly *not* part of this? The no-list prevents gold-plating later.
6. **Constraints** — deadlines, compatibility, things that must not break, decisions already made that this must respect.

## Gate — Wonder

Write results into the work file as they land, then check the gate:

- [ ] Problem statement confirmed by the user in their own words ("yes, that's it")
- [ ] Success criteria are observable
- [ ] Out-of-scope list written
- [ ] No open question blocks design (park non-blocking ones, with why parking is safe)
- [ ] Terms resolved during the interview recorded in the glossary

If the verdict was "don't build this": record why, set `stage: done`, and stop — that's Wonder earning its keep.

Otherwise set `stage: invention` and tell the user: next is `/invent`. For genuinely small work, offer the express path instead (see the `genius-file` skill).
