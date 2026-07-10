---
name: blindspot
description: Find the unknowns before they find the work — a read-only territory pass that surfaces the questions nobody knew to ask, judgment taught before a choice is extracted, and a quiz that catches the user's map up with what actually changed. Use when work enters territory the user calls unfamiliar, when the user is confirming a choice they can't evaluate, or when the user asks what they're missing or wants to be quizzed before accepting built work.
argument-hint: "the task or area to scan for unknowns"
---

# Blindspot

The work file, the prompt, the glossary — all map. The codebase, its history, its real constraints — territory. The gap between them is the unknowns, and an unknown left unfound doesn't stay unfound: the diff review finds it, or production does.

Sort any unknown into one of four kinds; the flow already mines three:

| Kind | What it is | Who finds it |
|---|---|---|
| Known knowns | Already written down | The work file carries them |
| Known unknowns | Questions you know are open | Wonder settles or parks them |
| Unknown knowns | Obvious to the user, never said | The interview extracts them |
| Unknown unknowns | On nobody's question list | **Only the territory can surface them — this skill** |

An interview can't reach the fourth kind: it only asks questions someone thought to ask. This skill owns three moves for the moments the map is furthest from the territory. Each feeds a stage; none replaces one.

## Move 1 — the territory pass (before the work)

When work enters an area the user names as unfamiliar, when interview answers keep coming back "I don't know", or when a whole discipline nobody on the work has judgment in walks in (a new subsystem, a new domain entirely) — walk the territory before anyone writes the brief.

Read only — the code, its tests, its docs, and its history (log and blame of the area; reverted commits and bug-fix clusters are where it bit last time). Then report four things, nothing else:

1. **Questions you didn't know to ask** — decision points the territory forces that the ask never mentions. Each arrives as a question with your recommended answer, same discipline as the interview.
2. **What "good" looks like here** — the conventions, invariants, and quality bars this area already enforces; what a reviewer of this area would reject without discussion.
3. **Potholes** — where this area has bitten before, with the evidence: the reverted commit, the FIXME cluster, the test named after a bug. No history of bites? Say so — potholes are found, never manufactured.
4. **A sharper ask** — the user's request rewritten with the found unknowns settled or explicitly parked. Offer it back: "this is what I'd put in the brief."

Route the findings where they live: questions join the interview (`/wonder`), a term that wobbled goes to the `domain-glossary` skill, potholes become attack material for `/discern`, the sharper ask goes into the work file. The pass writes no code and checks no gate — it exists so the stages that do have real material.

## Move 2 — teach before judging (at a choice)

Watch for it whenever the user is confirming a choice — options from Invention, Discernment's recommendation, prototype directions. "Whichever you think", "they all look fine", an outright "I can't tell": that isn't agreement, it's a judgment gap. A confirmation from someone who can't evaluate the choice is an unknown wearing an approval, and it comes back later as "this isn't what I wanted."

Name the dimensions along which the options actually differ. Teach just enough to hold an opinion — with material from *this* territory: a side-by-side, a before/after, the two lines that differ — not a lecture on the field. Then re-present the choice.

If the user can judge now, their confirmation means something — record it. If they still can't, that is a delegated decision: record your pick as `assumed:` (the `genius-file` skill owns the idiom) instead of dressing it up as user-confirmed. An honest `assumed:` beats a hollow "sure, option A" — the returning reader knows to look at one; the other lies to them.

## Move 3 — quiz the map (before acceptance)

Tenacity verifies the territory: tests run fresh, diff reviewed. Nothing verifies the user's *map* of it. Built work the user hasn't absorbed is next month's unknown knowns — decisions they now own and couldn't state.

When built work is about to be accepted — Tenacity's close-out offers this, and delegated or auto work all but demands it, the user having watched none of the build — summarize what actually changed at the behavior level (from the diff and the work file: what happens differently now, what they will have to live with), then quiz. A few questions, one per message, each aimed at a consequence — "an upload fails twice; what happens on the third try?" — never trivia like filenames or line counts.

A wrong answer is a finding about the map, not about the user: the explanation was thin or the change genuinely surprising. Repair the map — re-explain, or write the missing line into the work file or docs — then ask again. The quiz checks no gate; the work's evidence is Tenacity's job. Its finish line is the user answering clean — so they accept knowing what they accepted.

## What this skill is not

- **Not the interview.** Wonder extracts what the user knows and never said; this skill surfaces what nobody knew. A territory-pass finding that needs a user decision becomes an interview question — Wonder's, not this skill's.
- **Not review.** Tenacity's reviewer judges the work against the brief; the quiz judges the user's map against the work. Either can fail while the other passes.
- **Not divergence.** Invention owns generating options; Move 2 only teaches how to choose among options that already exist.
- **Not a stage.** It has no gate and never sets `stage:`. It feeds the gates the stages own.
