---
name: attack
description: Put a plan, a design or a set of approaches the user hands over under blind attack, one attacker per path, and report what broke each and what each survived. User-invoked only, and outside the flow, so nothing is tracked and no work file is written.
disable-model-invocation: true
argument-hint: "the plan or approaches to attack, or where they are written"
---

# Attack

Discernment's attack, without the flow around it. Its failure mode is the one `/discern` exists for: a plausible-but-wrong plan going ahead because nobody tried to kill it, here on a plan that was never tracked and never will be.

The concept: **the paths the user names go to blind attackers, and the user gets back the wounds with their evidence, not a verdict dressed as one.** What an attack is, why each path gets its own fresh attacker, and why what comes back is a claim until checked against the repo are `/discern`'s, in [../discern/SKILL.md](../discern/SKILL.md), and this command takes them from there whole; what differs is only what surrounds the attack.

## How it runs

1. Read what the user handed over and name each path in it, one line each. Where it holds one plan, that plan is the one path, because a lone plan is attacked as hard as a favourite. Where what the attack must land against is unclear (what the plan is for, how they will judge it worked), ask that in one round with a recommendation each, because an attacker handed no success criteria attacks the wrong thing.
2. Spawn one `attacker` agent per path ([../discern/agents/attacker.md](../discern/agents/attacker.md)), in parallel, each handed the user's goal in their own words as its confirmed problem, its one path, and where the record lives (`.genius/DECIDED.md`, `CONTEXT.md` and `docs/adr/`, where the repo keeps them); never another path. Stay awake until every one returns.
3. Verify each landed attack against the repo yourself before reporting it, because a wound reported on a false claim sends the user away from a sound plan.
4. Report per path: the attacks that landed, each with its evidence; what it survived, one line each; any recorded decision the code no longer matches. Then your reading of which wounds are fatal and which are costs, with your recommendation, because a list of wounds with no weighing hands the user the battlefield.

Nothing is written: no work file, no log, no backlog line, because the user asked for an attack and not for tracking, and the flow never takes over a request that didn't enter it. Where they want the result kept, the plan is tracked by `/genius` and attacked again by `/discern`, which records its kills.

Done when every path has its attacker's report checked against the repo, and the user has the wounds, the survivals and a recommendation.
