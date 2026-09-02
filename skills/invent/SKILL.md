---
name: invent
description: Genuinely explore structurally different approaches before committing — the alternatives exist to be beaten, not to be presented. Use when a tracked piece of work is at its invention stage.
---

# Invention

The genius of novel solutions. Its failure mode is anchoring: the first plausible design becomes the only design — and the session that reaches Invention has usually just spent Wonder's interview converging the user onto one shape of the problem, which makes it the mind least free to diverge from it.

The concept: **don't generate the paths yourself — spawn a fresh, independent inventor per path, and consume what they find.** A single continuous train of thought cannot produce two structurally different paths: the second is shaped by the first before it starts, "explored" with extra steps. Spawn one inventor subagent per path, in parallel, each handed only the confirmed problem — no sight of what the other inventors produce, no memory of the conversation that produced the problem statement, nothing to anchor on but the problem and the repo. That isolation is the discipline against your own anchoring now, not a willed effort to resist it.

**Seed genuine divergence; don't leave it to chance.** Give each inventor a different angle — a different shape of change, a different interface, a different home for the complexity, the three this skill's own failure mode names — so structural difference is designed in rather than hoped for. An angle is a seed, not a cage: an inventor that finds something better than its assigned angle follows it there. Where an `/architect` study is already on record, there's nothing left to explore at that altitude — seed the inventors with the sub-decisions the study left open instead of the generic three. Spawn as many as the uncertainty genuinely warrants — more than one, always, because a single explored path is anchoring with extra steps — never a fixed ritual count. Where there is no grain to read at all (greenfield, a new subsystem), stop before spawning anyone and offer `/architect`: exploring a vacuum produces fiction, and no inventor can ground a path in a repo that doesn't yet answer the question.

Each inventor is the plugin's `inventor` agent ([agents/inventor.md](../../agents/inventor.md); on a client without agent definitions, hand it that file's body as its brief). Its task message carries the confirmed problem — success criteria, scope, out of scope, parked and assumed lines — its angle, and the work's folder; nothing of the conversation. It comes back grounded in the codebase's own grain, honest about what its path makes easy and what it honestly costs, free to spike a throwaway prototype when paper can't settle a question and keep only the answer. What comes back is one path per inventor, written for the record, not for the user: nobody hands this table over as a menu — what the user eventually sees, after Discernment's attack, is one committed recommendation and what died on the way to it. Verify each returned path's claims against the repo yourself before trusting it — a subagent's report earns the same check any other one does.

## How it runs

1. Read the snapshot's Problem, `.genius/DECIDED.md`, `CONTEXT.md`, and any `/architect` study on record. No grain to read at all → stop and offer `/architect`.
2. Choose the angles: the three this skill names, or the sub-decisions the study left open. More than one, never a fixed count.
3. Spawn one `inventor` agent per angle, in parallel, each handed the confirmed problem, its angle and the work's folder — nothing of the conversation. Stay awake until every one returns; dispatch synchronously where you cannot be sure the harness wakes you.
4. Verify each returned path's claims against the repo yourself.
5. Record the paths in the snapshot as state waiting for the attack — shape, what it makes easy, what it costs, what it was checked against — and `next: /discern`.

Then `/discern`. Done when the snapshot carries real alternatives, each showing the ground it stands on — what it makes easy, what it honestly costs, what in the repo it was checked against — ready to be attacked, not to be chosen from. (They are state while they wait for the attack; Discernment's close is what compacts them to kill-reason lines and moves the full paths to the log.)
