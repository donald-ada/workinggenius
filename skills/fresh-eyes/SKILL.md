---
name: fresh-eyes
description: Have a diff reviewed by a reviewer with no memory of how it was written, judged against what the user says it should do, and report what it would block on with evidence. User-invoked only, and outside the flow, so nothing is tracked and no work file is written.
disable-model-invocation: true
argument-hint: "optional: the diff or range, and what it should do"
---

# Fresh Eyes

The close-out review, without the flow around it. Its failure mode is the review by the mind that wrote the code, which reads what it meant instead of what it wrote.

The concept: **the diff goes to a reviewer that never saw it being written, judged against what it was for, and its findings come back as claims to check.** What the reviewer is told, why it is never told what not to flag, and why its findings are verified before anything is fixed are `/tenacity`'s, in [../tenacity/SKILL.md](../tenacity/SKILL.md). What differs is only what surrounds the review.

## How it runs

1. Name the scope: the range the user gave, or else the working tree's changes against `HEAD`, and where there are none, the current branch against the branch it forked from. Say which you took.
2. Name what it is judged against: what the user says the diff should do, in their words. Where they said nothing, ask in one line with your reading of the diff's intent as the recommendation, because a reviewer judging a diff against nothing judges it against its own taste.
3. Spawn the `reviewer` agent ([../tenacity/agents/reviewer.md](../tenacity/agents/reviewer.md)), its task message naming the scope, what it is judged against, and where the record lives (`.genius/DECIDED.md`, `CONTEXT.md`, `ARCHITECTURE.md` and `DESIGN.md`, where the repo keeps them). Stay awake until it returns.
4. Verify each finding against the code before reporting it, because a review sent looking will find something.
5. Report: the blocking findings, each with its evidence; what is real but not this diff's; what it tried and could not break. Fix nothing unasked, because the user asked for eyes, not edits.

Nothing is written under `.genius/`, because the user asked for a review and not for tracking. A diff that belongs to tracked work is reviewed by `/enable` at its slice close and by `/tenacity` at close-out, with the contract it was built against.

Done when every finding the user sees has been checked against the code, and each carries its evidence.
