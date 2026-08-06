---
name: blindspot
description: Find the unknowns before they find the work — a read-only territory pass that surfaces the questions nobody knew to ask, judgment taught before a choice is extracted, and a quiz that catches the user's map up with what actually changed. Use when work enters territory the user calls unfamiliar, when the user is confirming a choice they can't evaluate, or when the user asks what they're missing or wants to be quizzed before accepting built work.
argument-hint: "the task or area to scan for unknowns"
---

# Blindspot

The map — your prompt, the work file, the glossary — is not the territory: the codebase, its history, its real constraints. The gap between them is the unknowns, and an unknown left unfound doesn't stay unfound: the diff review finds it, or production does.

The concept: **go look, at the three moments the gap is widest.**

- **Before unfamiliar work** — walk the territory, read-only, as a fresh frontier-tier subagent (hunting unknown unknowns is judgment, not reading — measured twice; and the fresh context means the main session consumes the report instead of re-walking the files). The code, its tests, its history: where it bit last time is the best predictor of where it bites next. Report whatever matters — questions nobody thought to ask, what "good" looks like here, potholes, a sharper ask, and anything that fits no bucket at all; no taxonomy limits what counts as a finding. Every finding carries its evidence, and potholes are found, never manufactured. Check your own recommendations against your own findings before offering them.
- **At a choice the user can't evaluate** — "whichever you think" is a judgment gap, not agreement. Teach just enough of the actual difference to hold an opinion, then re-present the choice; if they still can't call it, an honest `assumed:` beats a hollow confirmation.
- **Before acceptance** — nothing verifies the user's *map* of what got built. Summarize what changed at the behavior level, then quiz the consequences they'll live with. A wrong answer is a finding about the explanation, not the user: repair the map, ask again — so they accept knowing what they accepted.

This skill feeds the stages; it never replaces one. Its findings route to where they live: questions to the interview, terms to the glossary, potholes to Discernment's attack.
