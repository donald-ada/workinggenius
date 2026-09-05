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

This is the one format. A file in some other shape is read for what it holds and brought to this shape when it is next written to — a session that knows the format needs no rule for recognising what isn't it. The measurements behind the rules, and the one repair a session meets rarely, are in [FORMAT-EDGES.md](FORMAT-EDGES.md): read it before disagreeing with a rule, never as the price of a slice close.

## The question

Compaction has a moment (every slice close, contract bump and stage close), an invariant (below), and an object: one question, asked of each snapshot line at each close.

> **Does this line still constrain work that isn't finished?**

- **No** → the log, verbatim, the section's link left behind. Never dropped on the assumption that the close already recorded it; it usually recorded less.
- **Yes, and it follows scope** → it stays: the confirmed problem, the decision, the current cut, an Open item still owed an answer.
- **Yes, but it arrived with a slice** → `CONTRACT.md`: a convention, a seam, a pinned value, what a later slice must not break.

The Slices list answers it, in the present — never a guess about who will read a line later; a rule evicted on a guess is a constraint lost silently. Two tie-breaks:

- **Until `stage: done` the work is unfinished.** Every slice marked done and the answer is still "yes": close-out re-verifies against what binds. Contract content drains when the work does, not when the last slice closes.
- **Both "follows scope" and "arrived with a slice" → `CONTRACT.md`**, the section keeping a one-line pointer. An interface pinned at Discernment is part of the decision *and* of what binds the build; it goes where the builder reads.

## The measure

**The snapshot's ceiling is 6000 characters** — characters, not lines (a line budget rewards not pressing return, and one physical line has been measured at 842 columns) and not bytes.

⚠ `wc -m` counts *bytes* wherever the locale is unset or `C`, which is most non-interactive shells: on a compliant 4939-character CJK snapshot it reported 9596. Count with `LC_ALL=C.UTF-8 wc -m`, or `python3 -c "import sys;print(len(open(sys.argv[1],encoding='utf-8').read()))" <file>`.

The number is a ceiling, never a target: **the mechanism is the question, and the count is how you check it was asked.** Under the ceiling without the question is not compacted, it is small — `/compact` puts the question to a snapshot that drifted. Over it is not a style problem: history is leaking into state, or the question went unasked. 100 physical lines stays a smoke alarm and decides nothing.

**The Slices roster is measured out.** It grows by slice count, and it cannot move out because it *is* the progress view: a closed slice line is neither a constraint nor scope, it is the work's shape. One line per slice, no budget. A roster that dominates the file says this is two pieces of work, and the fix is the cut, not the prose. (An expand → migrate → contract plan lists its batches as a range on one line; they are one slice's shape.) `CONTRACT.md` has no ceiling: growing by slice count is what it is for.

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
Active `assumed:` lines and edges left untested — only what is still owed an answer.
[drained](checkout-discounts.log.md#open-displaced-2026-07-08)

**Post-mortem:** <one line, at done — the weakest genius this run; a repeat names its adjustment>
```

The sections name what each stage owes the next session; the structure flexes to the work. Mid-flight, a stage's working material — Invention's paths, an interview's open questions — is state and sits here until the stage that consumes it compacts it into its conclusion. A stage that never ran has neither a section nor a log entry: absence is the record.

**Slices hold the current cut only.** A reshaped slice leaves no corpse; the reshape is a log entry. Three marks: `[ ]` not started, `[x]` closed, `[~]` in progress — first red test run, close not yet — carrying its start date and a link to a `slice-N-wip` entry (red, green, still owed; appended to as the build moves), because a session dies whenever it dies and `[ ]` over half-built code sends the next one to rebuild what exists or build on it blind. **Every slice is one line.** An open one carries its name, its `after:`, its issue and a link to its criteria in `CONTRACT.md` — never the criteria themselves: the builder reads the contract and the status view reads the roster, and two copies come apart at the first bump. A closed one carries its date and a link to *every* log entry that backs it — evidence, displaced text, review, patch, wip — a floor, not a cap (the invariant says why). What it built is in the diff; what it ran is in the log; what it left binding is in `CONTRACT.md`. **Order is build order, top to bottom**: a slice waits on every slice above it unless `after:` names what it waits on (`after: none` waits on nothing). The default is the safe reading; the explicit form is what lets a coordinator run two slices at once. Absence never means parallel. An edge is more than an order: the seam it crosses has a test in the contract, and the waiting slice's close holds that test green (the contract, below).

**Open grows by how many times the user was met**, so it is drained, never shortened, and the door opens at every slice close: a consumed `assumed:` goes to the log with what consumed it; an item that is work in its own right goes to the log verbatim, and `.genius/BACKLOG.md` takes a one-line seed pointing at that anchor — never straight to the backlog, because the invariant names two exits and a seed is lossy by design. A drained line leaves nothing to point from, so the section carries `[drained](<slug>.log.md#open-displaced-<date>)`, one per drain, never one overwritten by the next: the log is append-only, each drain is its own dated entry, and an overwritten link is text nobody can reach. Those links are what an emptied Open leaves behind.

**`next:` says the exact command and is rewritten by every close it survives.** `stage:` plus the roster does not imply it: every slice done and Open still holding items gives a cold reader three different first moves. **At `stage: done` the resting shape stays** — Problem, Decision, changelog, roster — whatever a literal reading of the question says: they are what the work *was*, and `HISTORY.md` and `/reconcile` point at them expecting to find them. What close-out still routes is what a stage left lying around, never a section the template names.

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

**A seam names its test, and that test is a criterion at both ends of every `after:` edge that crosses it.** The slice that provides the seam turns the test green; each slice that waits on it holds the same test green in its own tree before it can close — so an edge in the roster carries evidence and not an assumption, a parallel builder's branch is verified on its way back by exactly the tests on its edges, and close-out's reviewer can spend its weight on the joints no seam test reaches. Both ends, because a builder tests what it built and the one reader who needs what the seam promised is the slice on the other side; one test both must pass is the seam's promise as an instrument, the same instrument at each end by construction. A seam no test can reach — a visual, a config — names whose eyes decide, like any criterion. And the seam's shape moves only by a version bump: a provider that reshapes its seam and its own test in one commit has broken every slice waiting on it with no line saying so.

**A version bump replaces the plan layer whole**, the old version going to the log; the snapshot keeps the one-line changelog. **The established layer survives the bump untouched and is never drained** — not at a bump, not at done: its blocks are exactly what binds the slices not yet built, and the log records, it does not bind. At done the contract stays whole as the version the work was verified against; distillation touches the log alone. A block's title names who established it — provenance, never a trigger for removal: evicting on provenance throws away the newest rule in the file.

Readers: `/enable` and `/tenacity`, about to build or verify against it; `/discern`, when attacking a plan that already has one. `/reconcile`, `/errata` and `/compact` only when already pointed at a work. `/genius`, resuming, and `/wonder` never open it; the snapshot's pointer is enough.

## The log

Append-only; created at its first entry, not before. Each entry opens with a kebab-case key as its heading — the anchor the snapshot links — and a date on its first line:

```markdown
## wonder
2026-07-03 — the interview as it ran: the rounds, the answers, the wording the
problem statement went through before the user said "yes, that's it".

## discernment
2026-07-04 — the whole battlefield: every path, every attack, the ones that
landed and the ones the survivor walked out of.

## contract-v2
2026-07-09 — superseded by v3 on 2026-07-12. The version as it stood, whole,
with (appended when v3 landed) what overturned it.

## slice-1
2026-07-08 — per criterion, the command and its result, one line each:
`cargo test config::profiles` → 14 passed; `loglens --profile nosuch` → exit 2, names the profile.

## slice-2-wip
2026-07-12 — started. red: editor renders rule list. green: —. owed: save, validation.
2026-07-12 — green: renders. red: save round-trips. baseline: `npm test` had 2 failures before this slice (`export.test.ts`), holding at no new failures.

## reshape-s3
2026-07-12 — S3 split into S3/S5; the discovery that forced it, and the exchange
where the user confirmed the change.
```

Keys are unique by construction — stages run once, versions and slices are numbered; anything else takes a short descriptive key, date-suffixed on collision. **Letters, digits and hyphens only**: prose after the key is a different anchor, and every link to it is already broken (the repair is in the edges file). An entry is written by its stage as it runs, never assembled afterwards, and corrected by appending below it, never by editing it. Entries stay behavioral — interfaces, contracts, criteria; code paths and line numbers go stale before the next session reads them. The log is never compacted, summarized or tidied in flight; at done, Tenacity distills it once, announced by a first line beginning `distilled` (`/distill` catches up work that closed without it).

## The invariant

The snapshot is rewritten freely under one invariant: **nothing leaves it except into the log or into `CONTRACT.md`, already anchored, with a link left where its section points.** Hold that and rewriting loses nothing, and the snapshot stays the only path anyone needs — every entry reachable from the section it backs, nothing found by convention or guessing.

A collapse is routing, never a delete, and it is mechanical:

1. Before a closed slice's paragraph collapses to its line: **does it hold a constraint `CONTRACT.md` does not already have?** That moves there first.
2. Whatever the snapshot displaces is appended to the log verbatim, as a new entry keyed `<the anchor the line already links>-displaced-<date>` — `slice-1-displaced-2026-07-08`; for a section with no anchor of its own (Open, Problem), the section's name — and the displaced-from line carries that second link beside its first. The log is append-only, so displaced text lands at the end, not under the older anchor; without the second link the move breaks the promise it exists to keep.
3. Never read the log to decide how much of the paragraph is redundant. That judgement is made at the moment a close is trying to finish, and the paragraph is usually a summary that was never in the log (measured: early entries held 57–78% of their slices' distinctive tokens). Appending costs the log length, the law it already grows by; guessing costs a fact nobody can recover.

Compaction displaces at the moment of the action that displaces — the slice close, the bump — never as a filing sweep someone must remember.

## Links

- **Inside a work's folder, links are relative to that folder**: `CONTRACT.md`, `<slug>.log.md#anchor`, `proto-a.html` — never `.genius/<slug>/…`. A root-relative path breaks the moment the folder moves, and two bases in one file are worse than either, because a reader cannot tell which one a link used.
- **The files at `.genius/` link relative to `.genius/`**, one level above a work's folder: `<slug>/<slug>.md`, `<slug>/<slug>.log.md#anchor`.

## Also

- Short, never stripped: the `record-prose` skill holds the sentence discipline. The ceiling never buys itself a shortened kill-reason — only a line that moved to where it belongs.
- Work that ran `/architect` or `/designer` keeps the confirmed design as a snapshot section and its study as a log entry. The design's own artifact lives in the folder, named by the section that points at it; the committed language still lands in the project's `DESIGN.md`, and the committed architecture in its `ARCHITECTURE.md`.
