---
name: invent
description: Generate structurally different solution options for a wondered problem — diverge now, judge later. Use when a tracked piece of work is at its invention stage.
---

# Invention

The genius of novel solutions. Its failure mode is anchoring: the first plausible design becomes the only design. Invention exists to put real alternatives on the table before anyone falls in love.

Run the `genius-file` skill: read the work file. Wonder's gate must be checked (or skipped, recorded) before this stage begins.

## Rules of divergence

- **No judging during Invention.** Evaluation is Discernment's job. If you catch yourself arguing for a favorite, stop — record it as one option among several and keep diverging.
- **Options must be structurally different** — a different shape of change, a different interface, a different place for the complexity to live. Two variations of one idea are one option written twice.
- **2–4 options.** One is anchoring; five is noise.

## Process

1. **Load the constraints.** The Wonder section is the brief: problem, success criteria, scope edges, constraints. Every option must satisfy them — divergence is in the *how*, never the *what*.
2. **Explore the codebase** around the affected area: existing patterns, existing seams, prior art. Options that ignore the codebase's grain are fiction.
3. **Draft the options.** For each, record in the work file:
   - **Shape** — what changes, at what interface, in one or two sentences
   - **Makes easy** — what this option is best at
   - **Makes hard** — its honest cost (every real option has one; an option with no stated cost is un-thought, not perfect)
4. **For a big design, diverge in parallel.** Spawn one subagent per option, each with the same brief but a different design constraint ("minimize the interface", "optimize the common caller", "isolate behind a port"). Radically different starting constraints produce radically different options. Hand each subagent the work file *path* (the Wonder section is the brief) — don't paste your own summary, which would anchor them all on one reading.
5. **When paper can't settle it, prototype.** If an option's viability turns on something you can only learn by running code (does this state model survive real cases? what does this UI feel like?), build a throwaway prototype: state the question first, build the smallest thing that answers it, capture the answer in the work file, then delete or absorb the code. The answer is the deliverable; the prototype never is.

## Gate — Invention

- [ ] At least two structurally different options recorded
- [ ] Each option states what it makes easy and what it makes hard
- [ ] Any prototype's question and answer are captured; its code deleted or absorbed

Set `stage: discernment` and tell the user: next is `/discern`.
