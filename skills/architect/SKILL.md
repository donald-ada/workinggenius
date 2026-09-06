---
name: architect
description: Answer build-or-adopt honestly, then design one committed architecture from your own understanding of the problem — driven by ranked quality attributes, stress-tested against the field and against change, proven by a walking skeleton, its consequences confirmed by the user, committed to ARCHITECTURE.md. A command the user types, for greenfield or architecture-shaping work; standalone, no other skill required.
disable-model-invocation: true
argument-hint: "the system or subsystem to architect"
---

# Architect

Greenfield's territory is the field — the systems that already solved this problem — but the field answers one question and stress-tests another; it is not there to be copied. An architecture assembled from references is a worse copy of something the user could install, and one assembled from the default stack was designed for no problem at all.

The concept: **first ask whether to build at all; then design one architecture that is genuinely yours, driven by the qualities the user actually ranks, and let the field and the future attack it.** Architecture is the set of decisions that are expensive to change later. Everything else is design, and belongs to the slices.

## The discipline

- **Build-or-adopt is the first fork, and it belongs to the user.** Does something existing cover this? Adopting — using, forking, wrapping — is a successful outcome. What justifies building is the **delta** between what the user needs and what exists: name it, put the fork to the user with your recommendation and its price, and if building wins, the delta is the design's spine — build only what differentiates. A claim about what an existing system does carries its source, because recall of a famous system is where invented facts come from.

- **Quality attributes are ranked, not listed.** "Fast, reliable, cheap, simple" is a wish hiding which one it will drop. Ask which three matter most for *this* system, in order, each as a concrete scenario — "10× today's traffic on a Monday morning: what happens?" — because a quality with no scenario is a word, and words are never traded off. Every architectural decision names which quality it buys and which it spends.

- **Design one architecture, committed — never a menu.** A row of reference-flavored options is theater when the user can't tell them apart. Design from your own understanding of the confirmed problem, at the professional default — a system a senior engineer expects to still be maintaining in three years — and stand behind it. Original decisions need reasons, not citations: the sourcing rule binds facts, never thinking. The default stack was chosen for no problem; a stack is a fork the user's world decides, so **ask** — the team's hands, the ops that exist, the load that is real. Every technology names what selected it.

- **Boundaries own data, and contracts cross them.** Draw components by what each owns — its data, its invariants, the decisions only it may make — not by what it is made of. Each crossing is a named contract: what goes over it, who owns the shape, what happens when the other side is slow or gone. The blast radius of a change is the count of boundaries it crosses; a design where every change crosses every boundary is a monolith wearing a diagram. A distributed system is the more expensive default, chosen only when a ranked quality demands it.

- **Size for the load that is real, and say what it cannot take.** Design for what the user measured or honestly estimated, times the growth they expect — every component that exists for a scale nobody has is maintained today. The design states its envelope — throughput, data size, latency, team size — and what breaks first past it, because a system that knows its limit gets re-architected on schedule and one that doesn't gets re-architected at 3 a.m.

- **The field and the future attack the design; neither writes it.** Where serious systems converged, diverging needs a stated reason; where they diverged, a fork the user's world decides goes to the user, and a pure-engineering fork is yours, reason recorded. Then walk the design through the stressors that actually arrive — load 10×, data 10×, a dependency dies, a requirement flips, the team splits, a region fails, an audit is demanded, the one senior engineer leaves — and for each, what survives and what has to be rebuilt: what survives many stressors is the architecture. Record the attacks that landed and the ones the design walked out of. A new subsystem in an old project has a third attacker: the decisions already recorded there (`.genius/DECIDED.md`, past work, `docs/adr/`) — contradict one and the design either loses or says which decision it overturns and why.

- **Name what changes cheaply, because the design chose it.** An architecture is a bet on which changes will come: it makes some cheap and, by the same move, others dear. Say both — "adding a payment provider is one adapter; changing what a payment *is* touches every boundary" — so the next session knows which requests are a slice and which are a re-architecture.

- **Where a rule can be checked, write the check.** A dependency direction, a latency budget, a boundary nothing may reach around — each is a fitness function: a test, a lint rule, a script the CI runs. Write the ones the architecture depends on, or name them as the first slices, because a rule enforced by a test is an architecture and a rule enforced by memory is a wish. The rest say whose eyes decide.

- **The walking skeleton proves the architecture before anything is built on it.** The thinnest end-to-end path through every boundary, deployed the way production will deploy it, is the first thing to build and the last chance to change the shape cheaply; `/galvanize` takes it as S1.

- **The user confirms consequences, not diagrams.** Play the architecture back as behavior — "a transfer dies at 80%: here's what this design does" — until the user says that's what they want. Where they can't evaluate a fork, teach the difference first (`blindspot` skill), or record an honest `assumed:`.

## The record

The committed architecture lands in **`ARCHITECTURE.md`** at the repository root (or beside the subsystem it describes) — binding, read before designing anything that touches its boundaries, rewritten in place when a later fight overturns it (`errata` skill):

```markdown
# <System>

## What it is, and why it exists
The problem in one paragraph; the delta over what exists, with the alternatives studied and their sources.

## Qualities, ranked
1. <quality> — <the scenario it must survive>
What this design deliberately spends to buy them.

## Envelope
Throughput, data size, latency, team size it is built for; what breaks first past it.

## Structure
The components by what each owns; the contracts across each boundary and what happens
when the other side is slow or gone. The prose binds; a diagram where one helps.

## Runtime
The load-bearing scenarios walked through the structure: happy path, partial failure,
retry, audit. Each names what the user confirmed.

## Stack
Every technology and what selected it.

## Cheap and dear
What this design makes cheap to change, and what it makes expensive — by intent.

## Stressed against
The field it was held against (systems, sources) and the stressors walked: what landed, what it walked out of.

## Enforced
The fitness functions that hold the rules above, and the rules only eyes can hold.

## Walking skeleton
The first slice: the thinnest end-to-end path, and how it proves the shape.

## Not this
What the design deliberately does not do, and what would have to change for it to.

## Open
Forks still owed a ruling. An `assumed:` line lives in the work's snapshot where one exists.
```

The study — the field read, the stressors walked, the confirming exchange — is a log entry under `## architect` where the work has a work file (`genius-file` skill), and the snapshot keeps a section pointing at `ARCHITECTURE.md`. A confirmed design a future stranger would re-fight gets its line in `.genius/DECIDED.md` (`decision-record` skill). One architecture per system: a recorded `ARCHITECTURE.md` is consumed, not redone — later work designs inside its boundaries, a change that wants to cross one is a conversation, not a drift, and a subsystem gets its own file only when its qualities rank differently from the whole's.

## How it runs

1. Read what is already settled: `.genius/DECIDED.md`, `CONTEXT.md`, an existing `ARCHITECTURE.md`, records that predate this plugin. A study on record is consumed; research only what it does not cover.
2. Study the field, sources in hand, and put build-or-adopt to the user with your recommendation and its price. Adopt wins → record it and stop.
3. Ask for the ranked qualities and the load that is real; turn each quality into a scenario; ask the stack forks that belong to the user's world.
4. Design one architecture — boundaries by ownership, contracts across them, the envelope, the stack with selectors, cheap and dear — and attack it: the field's convergences, the stressors, the settled decisions. Change what an attack breaks; record what it walked out of.
5. Play it back as consequences until the user says that's what they want; teach or record `assumed:` where they can't call a fork.
6. Write `ARCHITECTURE.md`, the log entry where there is a work, the decision-index lines; name the walking skeleton as the first slice.

The committed architecture is the deliverable; what happens next is the user's to type. Done when the user has confirmed the design in consequences they could evaluate, every quality has a scenario, every technology names its selector, and `ARCHITECTURE.md` says what it makes dear as plainly as what it makes cheap.
