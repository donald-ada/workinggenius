# Work File Format

One piece of work = two files: the **snapshot** at `.genius/<slug>.md` and the **log** at `.genius/<slug>.log.md`. Slug is short kebab-case, named for the outcome (`checkout-discounts`, not `fix-stuff`).

Two files, two growth laws — that is the whole design. The snapshot is the work's current truth, and its size follows *scope*: requirements can change ten times and it is still a screen, because a cold session reads it whole before acting. The log is everything that happened on the way, and its size follows *time*, which costs nothing, because nobody reads a log whole — they follow one link into it when they ask "why".

## The snapshot

A record for a cold reader, not a form: the sections name what each stage owes the next session; the structure flexes to the work.

```markdown
---
work: checkout-discounts
stage: enablement   # wonder | invention | discernment | galvanizing | enablement | tenacity | done
created: 2026-07-03
contract: v3
base: <HEAD when Galvanizing wrote contract v1 — Tenacity diffs from here>
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
The brief, the agreed test seams, pinned values, and the conventions the
build has introduced — the full current version, whole, never a patch over v2.
- v1→v2: rules API landed as a batch endpoint; editor slice re-cut. [v1](checkout-discounts.log.md#contract-v1)
- v2→v3: batch endpoint measured 340ms; budget 200ms→400ms. [v2](checkout-discounts.log.md#contract-v2)

## Slices
The current cut only — a reshaped slice leaves no corpse here; the reshape is
a log entry. Each closed line links its evidence:
- [x] **S1 — cart totals through the API** … [evidence](checkout-discounts.log.md#slice-1)
- [ ] **S2 — the discount rule editor** … acceptance criteria a stranger could verify
When the repo tracks issues: `**Parent issue:** #N` here, `— issue: #N` per line.

## Open
Active `assumed:` lines and edges left untested — only what is still owed an
answer; a consumed line moves to the log with what consumed it.

**Post-mortem:** <one line, at done — which genius was weakest this run; a
repeat weakness names its adjustment>
```

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
2026-07-08 — per criterion, what ran and what it showed.

## reshape-s3
2026-07-12 — S3 split into S3/S5; the discovery that forced it, and the
exchange where the user confirmed the change.
```

Keys are unique by construction — stages run once, contract versions and slices are numbered; anything else takes a short descriptive key, date-suffixed on collision. Keep keys to letters, digits and hyphens, so the anchors resolve everywhere. An entry is corrected by appending below it (`errata` skill), never by editing it.

## The invariant

The snapshot is rewritten freely — compacted at every slice close, contract bump, and stage close — under one invariant: **nothing leaves the snapshot except into the log, already anchored, with a link left where its section points.** Hold that and rewriting loses nothing, ever: the snapshot stays regenerable from the log, and stays the only path anyone needs — every entry reachable from the section it backs, nothing found by convention or by guessing. The log is the file that is never compacted, summarized, or tidied.

## Rules

- One screen is the snapshot's target; two is its ceiling (~100 lines). Over the ceiling is not a style problem — it is a compaction signal, or history leaking into state.
- The template is the shape at rest. Mid-flight, a stage's working material is state and sits in the snapshot — Invention's paths, an interview's open questions — until the stage that consumes it compacts it into its conclusion and moves the material to the log.
- A stage that never ran has neither a section nor a log entry — absence is the record.
- A log entry is written by its stage as it runs, never assembled afterwards. Compaction displaces snapshot content at the moment of the action that displaces it — the slice close, the contract bump — never as a filing sweep someone must remember.
- Keep entries behavioral — interfaces, contracts, criteria; no code paths or line numbers, they go stale before the next session reads them.
- Short, never stripped. A line may hold two sentences, and the one-line records need them — a kill-reason names its attack *and* what it broke, a repeat weakness names its diagnosis *and* its adjustment. Quoted words go in as they were said.
- Work that ran `/architect` or `/designer` keeps the confirmed design as a snapshot section and its study as a log entry, same rules. The committed design language still lands in the project's own `DESIGN.md`.
- Files from earlier formats — everything inline in one file (possibly with a narrated build log, `**Gate — <Stage>**` checklists, `mode:` frontmatter, a `**Sizing:**` line, or `> ⚠ Skipped` markers), or a work file with a `<slug>/` records folder — **finish in the shape they started.** Read the old shape as the record it is; never convert mid-flight, and never convert a finished file at all: a record rewritten later is no longer what was written then, and its worth is that it is what was written then.
