---
name: architect
description: Design an architecture that is genuinely yours — study the real systems that already solved this problem, let their divergences interrogate the user, and decide every load-bearing choice instead of defaulting it. Use when work is greenfield or architecture-shaping — a new system, a new subsystem, a foundational choice — where the repo has no grain to read and the territory that matters is the ecosystem.
argument-hint: "the system or subsystem to architect"
---

# Architect

Greenfield flips the blindspot rule: the repo has no history to mine, so the territory that teaches lives outside — the systems that already solved this problem, each embodying years of decisions you would otherwise re-make from scratch, badly. An architecture invented in a vacuum defaults to the simplest thing that satisfies the ask, and re-learns the field's lessons in production.

The concept: **study the field, interrogate the user with it, then design something that is ours.**

- **Study real systems, with evidence.** Find the references that earned their authority: the decade-old workhorse, the new system the field is excited about, maybe the contrarian bet — 2–4 is plenty. From each, extract the load-bearing decisions and what they trade, not the feature list. Every claim about a reference carries its source (the repo, the docs, the design writeup) — a characteristic you can't source is a guess wearing a citation. A fresh frontier-tier subagent with web access does the studying; the session consumes the report.
- **The references generate the interrogation.** Where two real systems chose differently, real builders disagreed — that fork is a question only the user can settle, asked the interview's way: live dialogue, recommendation attached, price stated ("Syncthing carries sync state on every node — resilience, at the cost of state everywhere; LocalSend keeps nothing — simplicity, and no story when a transfer dies halfway. Which failure hurts more here?"). Where the field agrees, don't ask — inherit the consensus and record it as such.
- **Design ours, not theirs.** Synthesize from the user's answers and the confirmed problem — never by copying the most impressive reference. Every load-bearing decision in the result traces to a user's answer, a field consensus, or a stated bet; a borrowed decision is named with its origin so Discernment can attack the borrowing ("that pattern earns its keep at Syncthing's scale — does it at ours?"). Professional default is the floor: the result should read like a system a senior engineer expects to still be maintaining in three years — the user can buy down from that, never has to buy up to it.

Write the study and the decisions into the work file: the references and their trade-offs become Invention's ground, the divergence answers become Discernment's attack material, and any fork that moves cost goes through the interview's pricing discipline. Like blindspot, this skill feeds the stages and never replaces one — no stage advances here.

Callable directly (`/architect <system>`), or invoked when Invention enters ground the repo can't teach — a new system, a new subsystem, a foundational choice with no grain to follow.
