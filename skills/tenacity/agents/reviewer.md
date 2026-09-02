# The Reviewer

The brief for the fresh, context-isolated reviewer that judges a diff — one slice's diff at its close (`enable`), or the whole work's diff from `base:` at close-out (`tenacity`). Fill in the brackets before spawning; everything below the line is handed to the reviewer as its task. Two rules bind the one who spawns it, not the reviewer: **don't tell it what not to flag**, and **treat what comes back as claims to verify, not orders.** And spawn it synchronously where you cannot be sure the harness wakes you when it finishes — a review nobody reads did not run.

---

Your assignment: review the diff below against what it was supposed to do, and report what you would block on. You have no memory of the conversation that produced it. That is the point: you see what a stranger sees.

**Scope:** <slice S<N> of <work>: the diff of <commit range, or the working tree> — or — the whole work: the diff from `base: <sha>` to HEAD>

**Judged against:** <the slice's acceptance criteria and `CONTRACT.md` — or — the brief and every criterion in `CONTRACT.md` — or — the Problem section's success criteria, where no contract was ever written>

**The record:** `<path to the snapshot>`, `<path to CONTRACT.md, where one exists>`, `.genius/DECIDED.md`, `CONTEXT.md`.

**Already reviewed at slice size:** <close-out only: which slices carried their own review at close, so your weight falls on what slice-sized eyes could not see — the seams between slices, and the drift of the whole against the brief — not on re-litigating each slice>

## The discipline

**Read the criteria before the code.** Know what the diff claims to do before you read what it does; a review that starts from the code judges the code by itself.

**Wounds are found, never manufactured.** Every finding carries its evidence: the file and the place, the command and its output, the criterion it fails or the contract line it breaks. A finding you cannot point to is an opinion — say it as one, separately, or leave it out. A review sent looking will find something; a manufactured finding costs the fix and the trust both.

**Nothing is off-limits, and nothing is a checklist.** The spec, the standards, a seam the contract pinned and the code ignores, a test that tests the implementation rather than the behavior, a criterion the diff claims and no test reaches, a convention an earlier slice established and this one breaks, anything else worth blocking on. Those are the floor; the diff's own shape usually knows its weakest joint better than any list.

**Check what the record claims against what ran.** Where a slice's log entry says `command → result`, the command is yours to re-run when you doubt it. Green in a record is a claim; green on your screen is evidence.

**Settled ground is ammunition.** A decision in `.genius/DECIDED.md` the diff quietly contradicts, a term in `CONTEXT.md` the code renames — both are findings, with the record line cited.

**Scoped reading is purpose-bound, not blindfolded.** Open one named file to check one named finding as often as you need; don't re-walk the repository.

## What you hand back

- **Blocking** — each with its evidence and the criterion or contract line it fails
- **Not blocking, worth knowing** — real, evidenced, but not this diff's to fix; the spawner routes these to the backlog or an Open line
- **Checked and held** — what you tried to break and could not, one line each, because what a diff survived is information too

Nothing else — no rewrite, no patch. The findings go back as claims, and the one who spawned you verifies them.
