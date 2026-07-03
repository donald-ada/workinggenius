---
name: wonder
description: Question the work before doing it — a relentless interview that turns a raw idea into a confirmed problem statement.
disable-model-invocation: true
argument-hint: "the idea or request to question"
---

# Wonder

The genius of questioning. Most failed work fails here first: the agent built exactly what was asked, and what was asked was not what was wanted. Wonder closes that gap before any design exists.

Run the `genius-file` skill: create the work file (or read it if it exists) and work in its Wonder section.

## The interview

Interview the user relentlessly about the idea until you reach shared understanding. Walk down each branch of the question tree, resolving one branch before opening the next.

Rules of the interview:

- **One question at a time.** A batch of questions is bewildering; a sequence is a conversation.
- **Recommend an answer with every question.** You have context the user may not have loaded; a question with a recommendation is twice as easy to answer.
- **If the codebase can answer it, don't ask.** Explore first; spend the user's attention only on questions the code cannot settle.
- **Ask the question behind the request.** "Add a retry button" is a solution wearing a problem's clothes. What failure is the user actually seeing? Would they still want the button if the failure went away?
- **Collide words with the glossary.** Run the `domain-glossary` skill as the interview runs: a term that conflicts with `CONTEXT.md`, or one fuzzy word doing two jobs, gets resolved on the spot and written into the glossary inline. The interview is where the project's language gets sharp — that sharpness outlives this piece of work.

Branches to walk (skip any the conversation has already settled):

1. **The problem** — what hurts, for whom, how often? What happens if we do nothing?
2. **Worth doing?** — Wonder has standing to challenge the premise. If the work looks like it shouldn't happen, say so with reasons. "Don't build this" is a successful outcome, not a failed one.
3. **Success** — what observable change proves it worked? Numbers, behaviors, absences of complaints — not implementation.
4. **Scope edges** — what nearby things are explicitly *not* part of this? The no-list prevents gold-plating later.
5. **Constraints** — deadlines, compatibility, things that must not break, decisions already made that this must respect.

## Gate — Wonder

Write results into the work file as they land, then check the gate:

- [ ] Problem statement confirmed by the user in their own words ("yes, that's it")
- [ ] Success criteria are observable
- [ ] Out-of-scope list written
- [ ] No open question blocks design (park non-blocking ones, with why parking is safe)
- [ ] Every term resolved during the interview is recorded in `CONTEXT.md`

If the verdict was "don't build this": record why, set `stage: done`, and stop — that's Wonder earning its keep.

Otherwise set `stage: invention` and tell the user: next is `/invent`. For genuinely small work, offer the express path instead (see the `genius-file` skill).
