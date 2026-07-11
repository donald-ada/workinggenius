---
name: wonder
description: Question the work before doing it — the interview that turns a raw idea into a confirmed problem statement. Use when a tracked piece of work is at its wonder stage, or when starting the Working Genius flow on a new idea.
argument-hint: "the idea or request to question"
---

# Wonder

The genius of questioning. Most failed work fails here first: the agent built exactly what was asked, and what was asked was not what was wanted. Wonder closes that gap before any design exists.

Run the `genius-file` skill: create the work file (or read it if it exists) and work in its Wonder section.

## The interview

The interview runs until the problem statement survives restatement — the user says "yes, that's it" to words *you* wrote back to them. Work the branches below in order, closing each before opening the next.

Rules of the interview:

- **One question per message.** The user decides best one decision at a time; a stack of questions gets a stack of half-answers, and the half-answers are where misbuilds hide.
- **Every question arrives with your best answer attached.** You've read code the user may not have loaded; "A or B? I'd pick A, because…" can be answered with one word.
- **Look it up before you ask it.** Whatever the repo, the history, or the docs can settle is homework, not a question. What's left for the user is the one thing only they own: what they actually want.
- **Depth matches stakes.** A contained change earns a short walk; work that creates concepts, crosses interfaces, or is expensive to redo earns the full tree. The interview ends when the gate below can be checked honestly — not when the questions run out.
- **The user can call it.** "Enough — go with your recommendations" is a legitimate answer at any point: fill the remaining branches with your recommended answers, record each as `assumed:` in the work file, and move on.
- **Ask the question behind the request.** "Add a retry button" is a solution wearing a problem's clothes. What failure is the user actually seeing? Would they still want the button if the failure went away?
- **Collide words with the glossary.** Run the `domain-glossary` skill as the interview runs: a term that conflicts with `CONTEXT.md`, or one fuzzy word doing two jobs, gets resolved on the spot and written into the glossary inline. The interview is where the project's language gets sharp — that sharpness outlives this piece of work.
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
