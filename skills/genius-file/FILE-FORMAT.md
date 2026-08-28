# Work File Format

One piece of work = one folder at `.genius/<slug>/`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`). Inside it:

| File | Holds | Grows by | Read by |
|---|---|---|---|
| `<slug>.md` — the **snapshot** | the work's current truth | *scope* | everyone, whole, before acting |
| `<slug>.log.md` — the **log** | everything that happened on the way | *time* | nobody whole; one link at a time |
| `CONTRACT.md` — the **contract** | the brief, the test seams, the pinned values, the conventions the build introduced | *slice count* | `/enable`, `/discern`, `/tenacity` (＋ two parameterised readers, below) |
| anything else | this work's artifacts — a prototype, a screenshot, a report | — | whoever the snapshot's pointer names |

`.genius/` itself keeps only what spans works: `BACKLOG.md`, `DECIDED.md`, `HISTORY.md`. So `ls .genius/` lists pieces of work, one entry each, however many artifacts a work carries.

**Three files, three growth laws — that is the whole design.** The snapshot's size follows *scope*: requirements can change ten times and it is still short enough that a cold session reads it whole before acting. The log's size follows *time*, which costs nothing, because nobody reads a log whole. The contract's size follows *slice count* — it is the third law, and it is the one that breaks a two-file design: a convention the build introduced binds the slices that haven't been built yet, so it can be neither deleted nor left in a file whose size must follow scope.

## The question

Compaction has a moment (every slice close, contract bump, and stage close) and an invariant (below). What it also needs is an **object** — which line has to go. That is one question, asked of each line in the snapshot at each close:

> **Does this line still constrain work that isn't finished?**

- **No** — it belongs to the log. Append it there verbatim and leave the section's link; never drop it on the assumption that the close which produced it already recorded the same thing (it usually recorded less — see the invariant).
- **Yes, and it follows scope** — the confirmed problem, the decision, the current cut, an Open item still owed an answer. It stays.
- **Yes, but it arrived with a slice** — a convention, a test seam, a pinned value, a list of things a later slice must not break. It belongs in `CONTRACT.md`.

The question is about the present, and the Slices list is what answers it — never a prediction about who will read a line later. A rule evicted on a guess about future readers is a constraint lost silently.

Two tie-breaks, because the branches are not exclusive and a snapshot can be read literally into nonsense without them:
- **Until `stage: done`, the work itself is unfinished.** Every slice can be marked done and the answer is still "yes, it constrains" — close-out re-verifies each criterion against what binds, and Open items still owed a ruling are argued against it. Contract content does not drain into the log because the last slice closed; it drains when the work does.
- **When a line answers both "follows scope" and "arrived with a slice", it goes to `CONTRACT.md`,** and the section it came from keeps a one-line pointer. A backend interface pinned during Discernment is part of the decision *and* part of what binds the build; put it where the builder already reads.

## The measure

**The snapshot's ceiling is 6000 characters** — characters, not lines, and not bytes.

⚠ `wc -m` counts *bytes* wherever the locale is unset or `C`, which is most non-interactive shells: measured on a compliant 4939-character CJK snapshot, `wc -m` reported 9596. Use `LC_ALL=C.UTF-8 wc -m`, or `python3 -c "import sys;print(len(open(sys.argv[1],encoding='utf-8').read()))" <file>`. A ceiling defended by an instrument that silently doubles on the very writing system that motivated it is worse than no ceiling.

Lines were the ceiling once and could not hold it: a line budget rewards not pressing return, and the same content costs the reader the same either way. Measured at 90 columns on one real Chinese work file, a 305-line snapshot displayed as 595 lines (1.95×) and a 17-line backlog as 82 (4.82×), where one entry ran to 842 columns on a single physical line. Characters cannot be reflowed away.

100 physical lines stays as the familiar shorthand and as a smoke alarm — over it, ask the question — but it decides nothing. And the number is a ceiling, never a target: **the mechanism is the question, and the count is how you check the question was asked.** A snapshot under the ceiling that never had the question put to it is not compacted, it is small.

`CONTRACT.md` has no ceiling. Growing by slice count is what it is for.

## The snapshot

A record for a cold reader, not a form: the sections name what each stage owes the next session; the structure flexes to the work.

```markdown
---
work: checkout-discounts
stage: enablement   # wonder | invention | discernment | galvanizing | enablement | tenacity | done
created: 2026-07-03
contract: v3
next: /enable checkout-discounts, slice 2   # the exact command that moves this forward
base: <HEAD when Galvanizing wrote contract v1 — or, where it never ran, HEAD before
      this work's changes began, pinned by Tenacity at close-out. Tenacity diffs from here>
---

# Checkout discounts

## Problem
The problem behind the request, confirmed in the user's own words — current
wording only; what it used to say, and the interview that confirmed it, live
in the log. Success observable, scope edged, parked questions.
[Confirmed](checkout-discounts.log.md#wonder)

## Decision
Chosen: <the approach>, because <the load-bearing why, two or three lines>.
One kill-reason line per rejected path.
[The whole fight](checkout-discounts.log.md#discernment)

## Contract v3
One line: what binds, and where it lives.
- The brief, seams and pinned values: [CONTRACT.md](CONTRACT.md)
- v1→v2: rules API landed as a batch endpoint; editor slice re-cut. [v1](checkout-discounts.log.md#contract-v1)
- v2→v3: batch endpoint measured 340ms; budget 200ms→400ms. [v2](checkout-discounts.log.md#contract-v2)

## Slices
The current cut only — a reshaped slice leaves no corpse here; the reshape is
a log entry. **A closed slice is one line**: the mark, its name, its date, and
the link to its evidence. What it built is in the diff; what it ran is in the
log; what it left binding is in CONTRACT.md.
- [x] **S1 — cart totals through the API** (2026-07-08) [evidence](checkout-discounts.log.md#slice-1)
- [ ] **S2 — the discount rule editor** … acceptance criteria a stranger could verify
When the repo tracks issues: `**Parent issue:** #N` here, `— issue: #N` per line.

## Open
Active `assumed:` lines and edges left untested — only what is still owed an
answer; a consumed line moves to the log with what consumed it.

**Post-mortem:** <one line, at done — which genius was weakest this run; a
repeat weakness names its adjustment>
```

**Open follows a fourth law: it grows by how many times the user was met.** It cannot be compressed — a question still owed an answer is not redundancy — so it is drained rather than shortened, and the door opens at every slice close, not only at close-out: a consumed `assumed:` goes to the log with what consumed it, and an item that is work in its own right goes to `.genius/BACKLOG.md` as one line. An Open section that only ever grows is a door nobody opened.

## The contract

`CONTRACT.md` is written by Galvanizing as contract v1 and not before — a work that never ran Galvanizing has no contract file, and absence is the record there as everywhere. It holds the brief, the agreed test seams, the pinned values, and the conventions the build has introduced — the full current version, whole, never a patch over the last one. A version bump replaces it whole and moves the old version to the log; the snapshot keeps only the one-line changelog and the pointer.

A block may name which slices it binds (`### The option table (S2 established; S6 reads it)`). That is documentation for whoever opens the file — **never a trigger for removing it.** What authors actually write in those titles is provenance, "who established this", not "who still needs it"; evicting on provenance throws away the newest rule in the file.

Readers: `/enable` and `/tenacity` open it because they are about to build or verify against it, and `/discern` does when it is attacking a plan that already has one — on the ordinary path it runs before Galvanizing, so there is nothing to open. `/reconcile` and `/errata` reach into it too, but only when already pointed at a specific work — occasional, parameterised operations, not what starting a session costs. `/genius`'s status view, resuming a piece of work, and `/wonder` on a new one never open it; the snapshot's pointer is enough.

## The log

Append-only; created at its first entry, not before. Each entry opens with a kebab-case key as its heading — the anchor the snapshot links to — and a date on its first line:

```markdown
## wonder
2026-07-03 — the interview as it ran: the rounds, the answers, the wording
the problem statement went through before the user said "yes, that's it".

## discernment
2026-07-04 — the whole battlefield: every path, every attack, the ones that
landed and the ones the survivor walked out of.

## contract-v2
2026-07-09 — superseded by v3 on 2026-07-12. The version as it stood, whole,
with (appended when v3 landed) what overturned it.

## slice-1
2026-07-08 — per criterion, the command and its result, one line each:
`cargo test config::profiles` → 14 passed; `loglens --profile nosuch` → exit 2, names the profile.

## reshape-s3
2026-07-12 — S3 split into S3/S5; the discovery that forced it, and the
exchange where the user confirmed the change.
```

Keys are unique by construction — stages run once, contract versions and slices are numbered; anything else takes a short descriptive key, date-suffixed on collision. **Keep keys to letters, digits and hyphens** — a heading that appends prose after the key (`## s4-board 配置状态牌四件`) is a different anchor from the key, so every link to it is already broken. An entry is corrected by appending below it (`errata` skill), never by editing it.

## The invariant

The snapshot is rewritten freely — compacted at every slice close, contract bump, and stage close — under one invariant: **nothing leaves the snapshot except into the log or into `CONTRACT.md`, already anchored or linked, with a link left where its section points.** Hold that and rewriting loses nothing, ever: the snapshot stays regenerable, and stays the only path anyone needs — every entry reachable from the section it backs, nothing found by convention or by guessing.

Before a closed slice's paragraph collapses to its line, one check the question does not make on its own: **does that paragraph hold a constraint `CONTRACT.md` does not already have?** If it does, it moves there first.

Then the collapse itself is mechanical, never a judgement about whether the log "already covers it": **whatever the snapshot displaces is appended to the log verbatim, as a new entry keyed `<the section's anchor>-displaced-<date>`, and the section's line carries that second link beside its first.** The log is append-only, so displaced text lands at the end, not under the older anchor it belongs to; without the second link, the invariant's promise — every entry reachable from the section it backs — is broken by the very move meant to preserve it. Do not read the log to decide how much of the paragraph is redundant — that decision is made at the exact moment a close is trying to finish, which is where it goes wrong, and the paragraph is usually a summary written for the snapshot rather than a copy of anything. Measured on a real work file, the log carried every distinctive token of the later slices' paragraphs and only 57–78% of the first two slices', because early log entries are thinner than the summaries written above them. Appending costs the log some length, which is the law the log already grows by; guessing costs a fact nobody can recover. A collapse is a routing operation, never a delete.

The log is never compacted, summarized, or tidied while the work is in flight; at done, Tenacity distills it once (`/distill` catches up work that closed without it) — announced by a first line beginning `distilled` — down to what the repo cannot answer.

## Rules

- The snapshot's ceiling is 6000 characters, and the mechanism behind it is the question. Over the ceiling is not a style problem — it is a signal that the question went unasked, or that history is leaking into state.
- The template is the shape at rest. Mid-flight, a stage's working material is state and sits in the snapshot — Invention's paths, an interview's open questions — until the stage that consumes it compacts it into its conclusion and moves the material to the log.
- A stage that never ran has neither a section nor a log entry — absence is the record.
- **`next:` says the exact command, and it is rewritten by whatever close it survives.** `stage:` plus the slice list looks like it implies the next move, and it does not: a cold reader given a snapshot at `stage: enablement` with every slice marked done, and an Open section holding items still owed a ruling, has to guess between going to close-out, taking those items to the user first, and resuming a close-out that stopped halfway. Three different opening moves, one file, no answer in it. Writing the command costs a line and is the one thing a resuming session looks for first.
- **Links are relative to the work's own folder.** The snapshot, the log, `CONTRACT.md` and the artifacts sit beside each other, so `CONTRACT.md` and `<slug>.log.md#anchor` resolve as siblings, and an artifact is `proto-a.html`, never `.genius/<slug>/proto-a.html`. A path written from the repository root inside a work file is a link that breaks the moment the folder moves — and two bases mixed in one file are worse than either, because a reader cannot tell which one a given link used.
- A log entry is written by its stage as it runs, never assembled afterwards. Compaction displaces snapshot content at the moment of the action that displaces it — the slice close, the contract bump — never as a filing sweep someone must remember.
- Keep entries behavioral — interfaces, contracts, criteria; no code paths or line numbers, they go stale before the next session reads them.
- Short, never stripped. A line may hold two sentences, and the one-line records need them — a kill-reason names its attack *and* what it broke, a repeat weakness names its diagnosis *and* its adjustment. Quoted words go in as they were said. The ceiling never buys itself a shortened kill-reason; it buys itself a line that moved to where it belongs.
- Work that ran `/architect` or `/designer` keeps the confirmed design as a snapshot section and its study as a log entry, same rules. The design's own artifact — a prototype, a mockup — lives in the work's folder, named by the section that points at it. The committed design language still lands in the project's own `DESIGN.md`.
- **Older formats are recognised by their content, never by the folder.** A work is in an older format when its snapshot has no `<slug>.log.md` beside it — everything inline in one file (possibly with a narrated build log, `**Gate — <Stage>**` checklists, `mode:` frontmatter, a `**Sizing:**` line, or `> ⚠ Skipped` markers), or a `<slug>/` folder holding per-stage record files (`wonder.md`, `discernment.md`, …). The current format also uses a `<slug>/` folder, so its existence tells you nothing: read what is in it. Older formats **finish in the shape they started** — read the old shape as the record it is; a finished file is never converted at all, because a record rewritten later is no longer what was written then, and its worth is that it is what was written then. In-flight two-file work is the one thing `/migrate` may move into the folder layout, on the user's command.
