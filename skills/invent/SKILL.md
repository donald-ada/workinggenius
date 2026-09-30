---
name: invent
description: Genuinely explore structurally different approaches before committing — the alternatives exist to be beaten, not to be presented. Runs as the first half of `/discern` when the work has no paths on record yet; used on its own when the user asks for invention alone on a tracked piece of work (`/invent`, or in words). A work whose `next:` names a stage is not that ask, because the flow never advances itself.
---

# Invention

The genius of novel solutions. Its failure mode is anchoring: the first plausible design becomes the only design — and the session that reaches Invention has just spent Wonder's interview converging the user onto one shape of the problem, which makes it the mind least free to diverge from it.

The concept: **don't generate the paths yourself — spawn a fresh, independent inventor per path, and consume what they find.** A single continuous train of thought cannot produce two structurally different paths: the second is shaped by the first before it starts. Spawn one inventor subagent per path, in parallel, each handed only the confirmed problem — no sight of the other inventors, no memory of the conversation, nothing to anchor on but the problem and the repo.

**Seed genuine divergence.** Give each inventor a different angle — a different shape of change, a different interface, a different home for the complexity — so structural difference is designed in rather than hoped for; an angle is a seed, not a cage. Where an `/architect` study is on record, seed the inventors with the sub-decisions the study left open instead. Spawn as many as the uncertainty warrants — more than one, always, because a single explored path is anchoring with extra steps — never a fixed ritual count. Where there is no grain to read at all (greenfield, a new subsystem), stop before spawning anyone and offer `/architect`: exploring a vacuum produces fiction.

Each inventor is the plugin's `inventor` agent ([agents/inventor.md](agents/inventor.md)). Its task message carries the confirmed problem — success criteria, scope, out of scope, parked and assumed lines — its angle, and the work's folder; nothing of the conversation. It comes back grounded in the codebase's own grain, honest about what its path makes easy and what it costs, free to spike a throwaway prototype where paper can't settle a question. What comes back is one path per inventor, written for the record: nobody hands this table over as a menu — what the user sees, after Discernment's attack, is one committed recommendation and what died on the way to it. Verify each returned path's claims against the repo yourself; a subagent's report earns the same check any other one does.

**Invention runs inside `/discern`, not as a command of its own**: nothing in it waits on the user — the paths are never shown as a menu — so a command typed between it and the attack buys a round-trip and no judgement, and the defence against anchoring is the fresh inventors, never a fresh command. Typed alone as `/invent`, it records the paths and stops there.

## How it runs

1. Read the snapshot's Problem, `.genius/DECIDED.md`, `CONTEXT.md`, and any `/architect` study on record. No grain to read at all → stop and offer `/architect`.
2. Choose the angles: kinds of structural difference like the ones this skill names, or the sub-decisions the study left open, as many as the uncertainty warrants, because the count follows how open the problem is and not a habit. More than one, because one path is anchoring.
3. Spawn one `inventor` agent per angle, in parallel, each handed the confirmed problem, its angle and the work's folder — nothing of the conversation. Stay awake until every one returns; dispatch synchronously where you cannot be sure the harness wakes you.
4. Verify each returned path's claims against the repo yourself.
5. Record the paths in the snapshot as state waiting for the attack — shape, what it makes easy, what it costs, what it was checked against — and the whole of what the inventors returned under `## invention` in its own branch, `log/invention.md` (`measure.py append <slug> invention invention`), never inside `/discern`'s branch, because the paths are what the attack is judged against. Run inside `/discern`, go straight on to its attack in the same command. Typed alone, write `next: /discern <slug>`, the exact command, because with two works at the same stage a bare stage name does not say which one moves.

Then the attack: `/discern`'s next step, in the same command where it called this one. Done when the snapshot carries real alternatives, each showing the ground it stands on, ready to be attacked, not to be chosen from. They are state while they wait; Discernment's close compacts them to kill-reason lines and moves the full paths to the log.
