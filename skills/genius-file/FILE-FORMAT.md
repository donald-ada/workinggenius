# Work File Format

One piece of work = one folder at `.genius/<slug>/`. Slug: short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`). Inside it:

| File | Holds | Grows by | Read by |
|---|---|---|---|
| `<slug>.md` — the **snapshot** | the work's current truth | *scope* | everyone, whole, before acting |
| `<slug>.log.md` — the **log** | everything that happened on the way | *time* | nobody whole; one link at a time |
| `CONTRACT.md` — the **contract** | the brief, the test seams, the pinned values, each slice's criteria, the conventions the build introduced | *slice count* | `/enable`, `/discern`, `/tenacity` (＋ three parameterised readers, below) |
| anything else | this work's artifacts — a prototype, a screenshot, a report | — | whoever the snapshot's pointer names |

`.genius/` itself keeps only what spans works: `BACKLOG.md` with `BACKLOG.log.md` behind it ([BACKLOG-FORMAT.md](BACKLOG-FORMAT.md)), `DECIDED.md`, `HISTORY.md`. So `ls .genius/` lists pieces of work, one entry each.

**Three files, three growth laws.** The snapshot follows *scope*, so a cold session reads it whole however many times the requirements moved. The log follows *time*, which costs nothing, because nobody reads a log whole. The contract follows *slice count*: a convention one slice introduced binds the slices not yet built, so it can be neither deleted nor kept in a file whose size must follow scope. Conflate any two and the file grows with every discovery until nobody reads it closely.

This is the one format. A file in some other shape is read for what it holds and brought to this shape when next written to. The measurements behind the rules, and the one repair a session meets rarely, are in [FORMAT-EDGES.md](FORMAT-EDGES.md): read it before disagreeing with a rule, never as the price of a slice close.

## The question

Compaction has a moment (every slice close, contract bump and stage close), an invariant (below), and an object: one question, asked of each snapshot line at each close.

> **Does this line still constrain work that isn't finished?**

- **No** → the log, verbatim, the section's link left behind. Never dropped on the assumption that the close already recorded it; it usually recorded less.
- **Yes, and it follows scope** → it stays: the confirmed problem, the decision, the current cut, an Open item still owed an answer.
- **Yes, but it arrived with a slice** → `CONTRACT.md`: a convention, a seam, a pinned value, what a later slice must not break.

The Slices list answers it, in the present — never a guess about who will read a line later. Two tie-breaks: **until `stage: done` the work is unfinished**, because close-out re-verifies against what binds; and **both "follows scope" and "arrived with a slice" → `CONTRACT.md`**, the section keeping a one-line pointer, because an interface pinned at Discernment goes where the builder reads.

## The measure

**The snapshot's ceiling is 6000 characters** — characters, not lines and not bytes. ⚠ `wc -m` counts *bytes* wherever the locale is unset or `C`, which is most non-interactive shells. Count with `LC_ALL=C.UTF-8 wc -m`, or `python3 -c "import sys;print(len(open(sys.argv[1],encoding='utf-8').read()))" <file>`.

The format's instrument is [measure.py](measure.py) beside this file: `count <file>` is that one-liner, `snapshots` gives every snapshot whole and roster excluded against the ceiling, `links` reads both directions of the invariant (below), `anchors <slug>` lists a log's keys and what already links each, so a close can link without opening the log, `distill` lists the done works and whether their logs carry the distilled line, `status` is what `/genius` shows. `/genius`, `/compact`, `/reconcile` and `/distill` run it before they read; the one-liner stays written here for a session where injection is disabled by policy.

The number is a ceiling, never a target: **the mechanism is the question, and the count is how you check it was asked.** Under the ceiling without the question is not compacted, it is small; over it, history is leaking into state. **The Slices roster is measured out**: it grows by slice count and it *is* the progress view, one line per slice, no budget; a roster that dominates the file says this is two pieces of work, and the fix is the cut. `CONTRACT.md` has no ceiling: growing by slice count is what it is for.

## The snapshot

```markdown
---
work: checkout-discounts
stage: enablement   # wonder | invention | discernment | galvanizing | enablement | tenacity | done
created: 2026-07-03
contract: v3
next: /enable checkout-discounts, slice 2   # the exact command that moves this forward
base: <HEAD when Galvanizing wrote contract v1; where it never ran, HEAD before this
      work's changes began, pinned by Tenacity at close-out. Tenacity diffs from here>
---

# Checkout discounts

## Problem
The problem behind the request, in the user's own words — current wording only;
the interview that confirmed it lives in the log. Success observable, scope edged.
[Confirmed](checkout-discounts.log.md#wonder)

## Decision
Chosen: <the approach>, because <the load-bearing why, two or three lines>.
One kill-reason line per rejected path.
[The whole fight](checkout-discounts.log.md#discernment)

## Contract v3
- The brief, seams, pinned values and slice criteria: [CONTRACT.md](CONTRACT.md)
- v1→v2: rules API landed as a batch endpoint; editor slice re-cut. [v1](checkout-discounts.log.md#contract-v1)
- v2→v3: batch endpoint measured 340ms; budget 200ms→400ms. [v2](checkout-discounts.log.md#contract-v2)

## Slices
**Parent issue:** #41   <!-- only where the repo tracks issues; then `— issue: #N` per line -->
- [x] **S1 — cart totals through the API** (2026-07-08) [evidence](checkout-discounts.log.md#slice-1) · [displaced](checkout-discounts.log.md#slice-1-displaced-2026-07-08)
- [~] **S2 — the discount rule editor** — started 2026-07-12 · [criteria](CONTRACT.md#s2) · [wip](checkout-discounts.log.md#slice-2-wip)
- [ ] **S3 — rounding** — after: S1 · [criteria](CONTRACT.md#s3)
- [ ] **S4 — the audit export** · [criteria](CONTRACT.md#s4)

## Open
Active `assumed:` lines, `owed:` lines — a criterion closed on nobody's eyes yet,
`owed: S2 <criterion> → the user's eyes` — and edges left untested: only what is still owed an answer.
[drained](checkout-discounts.log.md#open-displaced-2026-07-08)

**Post-mortem:** <one line, at done — the weakest genius this run; a repeat names its adjustment>
```

The sections name what each stage owes the next session; the structure flexes to the work. Mid-flight, a stage's working material — Invention's paths, an interview's open questions — is state and sits here until the stage that consumes it compacts it into its conclusion. A stage that never ran has neither a section nor a log entry: absence is the record.

**Slices hold the current cut only.** A reshaped slice leaves no corpse; the reshape is a log entry. Three marks: `[ ]` not started, `[x]` closed, `[~]` in progress — first red test run, close not yet — with its start date and a link to a `slice-N-wip` entry (red, green, still owed; appended to as the build moves), because a session dies whenever it dies and `[ ]` over half-built code sends the next one to rebuild what exists or build on it blind. **Every slice is one line.** An open one carries its name, its `after:`, its issue and a link to its criteria in `CONTRACT.md` — never the criteria themselves, because two copies come apart at the first bump. A closed one carries its date and a link to *every* log entry that backs it. **Order is build order, top to bottom**: a slice waits on every slice above it unless `after:` names what it waits on (`after: none` waits on nothing); the explicit form is what lets a coordinator run two slices at once, and absence never means parallel. An edge is more than an order: the seam it crosses has a test in the contract, and the waiting slice's close holds that test green (below).

**Open grows by how many times the user was met**, so it is drained, never shortened, and the door opens at every slice close: a consumed `assumed:` goes to the log with what consumed it; an `owed:` line goes to the log with what the user saw when they looked, and never before, because a criterion whose instrument is their eyes has no other evidence to close on; an item that is work in its own right goes to the log verbatim, and `.genius/BACKLOG.md` takes a one-line seed pointing at that anchor — never straight to the backlog, because a seed is lossy by design. A drained line leaves nothing to point from, so the section carries `[drained](<slug>.log.md#open-displaced-<date>)`, one per drain, never overwritten by the next: an overwritten link is text nobody can reach.

**`next:` says the exact command and is rewritten by every close it survives** — `stage:` plus the roster does not imply it. **At `stage: done` the resting shape stays** — Problem, Decision, changelog, roster — whatever a literal reading of the question says: they are what the work *was*, and `HISTORY.md` and `/reconcile` expect to find them.

## The contract

Written by Galvanizing as contract v1 and not before — a work that never ran Galvanizing has none. Two layers, because they change by different rules:

```markdown
## The plan (v3)
The brief, the pinned values, the agreed test seams — each naming the test
that proves it: `S1 → S2, S3 — totals come out of the batch endpoint in cents:
npm test -- api/totals` — the full current version, whole, never a patch over
v2 — and one block per slice in the current cut, headed by the slice's key
alone so the snapshot's line can link it:

### S2
**The discount rule editor** — after: S1.
- Each acceptance criterion with the instrument that shows it:
  `npm test -- editor` → the rule list renders from the batch endpoint
- The seam test of every edge into this slice, held green in this slice's tree:
  `npm test -- api/totals` → passes against S1 as it landed, no mock of it
- A criterion no instrument reaches names whose eyes decide instead

## What the build established
One block per convention a slice introduced, each naming where it came from.
### The option table — S2 established, S6 reads it. [source](<slug>.log.md#slice-2)
```

**A seam names its test, and that test is a criterion at both ends of every `after:` edge that crosses it.** The providing slice turns it green; each waiting slice holds the same test green in its own tree before it can close — so an edge carries evidence and not an assumption, a parallel builder's branch is verified on its way back by the tests on its edges, and close-out's reviewer spends its weight on the joints no seam test reaches. A seam no test can reach names whose eyes decide, like any criterion. The seam's shape moves only by a version bump: a provider that reshapes its seam and its own test in one commit has broken every slice waiting on it with no line saying so.

**A version bump replaces the plan layer whole**, the old version going to the log; the snapshot keeps the one-line changelog. **The established layer survives the bump untouched and is never drained** — not at a bump, not at done: its blocks are exactly what binds the slices not yet built, and the log records, it does not bind. A block's title names who established it — provenance, never a trigger for removal.

Readers: `/enable` and `/tenacity`, about to build or verify against it; `/discern`, when attacking a plan that already has one; `/reconcile`, `/errata` and `/compact` only when already pointed at a work. `/genius` and `/wonder` never open it.

## The log

Append-only; created at its first entry, not before. Each entry opens with a kebab-case key as its heading — the anchor the snapshot links — and a date on its first line:

```markdown
## wonder
2026-07-03 — the interview as it ran: the rounds, the answers, the wording the
problem statement went through before the user said "yes, that's it".

## contract-v2
2026-07-09 — superseded by v3 on 2026-07-12. The version whole, with what overturned it.

## slice-1
2026-07-08 — per criterion, the command and its result, one line each:
`cargo test config::profiles` → 14 passed; `loglens --profile nosuch` → exit 2, names the profile.

## slice-2-wip
2026-07-12 — started. red: editor renders rule list. green: —. owed: save, validation.
2026-07-12 — green: renders. red: save round-trips. baseline: `npm test` had 2 failures before this slice (`export.test.ts`), holding at no new failures.
```

Keys are unique by construction — stages run once, versions and slices are numbered; anything else takes a short descriptive key, date-suffixed on collision. **Letters, digits and hyphens only**: prose after the key is a different anchor, and every link to it is already broken (the repair is in the edges file). An entry is written by its stage as it runs, never assembled afterwards, and corrected by appending below it, never by editing it. Entries stay behavioral — interfaces, contracts, criteria; code paths and line numbers go stale before the next session reads them. The log is never compacted or tidied in flight; at done, Tenacity distills it once, announced by a first line beginning `distilled` (`/distill` catches up work that closed without it). It is never opened to find an anchor either: `measure.py anchors <slug>` lists every key and what links it, because a log opened whole stays in the session's context to the end of the work.

## The invariant

The snapshot is rewritten freely under one invariant: **nothing leaves it except into the log or into `CONTRACT.md`, already anchored, with a link left where its section points.** Hold that and rewriting loses nothing, and the snapshot stays the only path anyone needs.

A collapse is routing, never a delete, and it is mechanical:

1. Before a closed slice's paragraph collapses to its line: **does it hold a constraint `CONTRACT.md` does not already have?** That moves there first.
2. Whatever the snapshot displaces is appended to the log verbatim, as a new entry keyed `<the anchor the line already links>-displaced-<date>` (for a section with no anchor of its own, the section's name), and the displaced-from line carries that second link beside its first — without it the move breaks the promise it exists to keep.
3. Never read the log to decide how much of the paragraph is redundant: the paragraph is usually a summary that was never in the log. Appending costs the log length; guessing costs a fact nobody can recover.

Compaction displaces at the moment of the action that displaces — the slice close, the bump — never as a filing sweep someone must remember.

## Links

- **Inside a work's folder, links are relative to that folder**: `CONTRACT.md`, `<slug>.log.md#anchor`, `proto-a.html` — never `.genius/<slug>/…`. A root-relative path breaks the moment the folder moves, and two bases in one file are worse than either.
- **The files at `.genius/` link relative to `.genius/`**: `<slug>/<slug>.md`, `<slug>/<slug>.log.md#anchor`.

## Also

- Short, never stripped: the `record-prose` skill holds the sentence discipline. The ceiling never buys itself a shortened kill-reason — only a line that moved to where it belongs.
- Work that ran `/architect` or `/designer` keeps the confirmed design as a snapshot section and its study as a log entry; the committed language lands in the project's `DESIGN.md`, the architecture in `ARCHITECTURE.md`.
