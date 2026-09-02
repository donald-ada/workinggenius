---
name: architect
description: Answer build-or-adopt honestly, then design one committed architecture from your own understanding of the problem — driven by ranked quality attributes, stress-tested against the field and against change, proven by a walking skeleton, its consequences confirmed by the user, committed to ARCHITECTURE.md. A command the user types, for greenfield or architecture-shaping work; standalone, no other skill required.
disable-model-invocation: true
argument-hint: "the system or subsystem to architect"
---

# Architect

Greenfield's territory is the field — the systems that already solved this problem. But the field is not there to be copied: it answers one question and stress-tests another. An architecture assembled from references is a worse copy of something the user could just install, and an architecture assembled from the default stack was designed for no problem at all.

The concept: **first ask whether to build at all; then design one architecture that is genuinely yours, driven by the qualities the user actually ranks, and let the field and the future attack it.** Architecture is the set of decisions that are expensive to change later. Everything else is design, and belongs to the slices.

## The discipline

- **Build-or-adopt is the first fork, and it belongs to the user.** Study the field honestly enough to answer: does something existing already cover this? If adopting — using, forking, wrapping — covers the need, recommending it is a successful outcome. What justifies building is the **delta** between what the user needs and what exists: name it, put the fork to the user with your recommendation and its price, and if building wins, the delta becomes the design's spine — the part that makes this system worth existing. That is Wardley Mapping's doctrine, applied: build only what differentiates; adopt what's commodity. A claim about what an existing system does carries its source — a README, a design doc, a benchmark — because recall of a famous system is where invented facts come from.

- **Quality attributes are ranked, not listed.** "Fast, reliable, cheap, simple" is a wish, and a design that promises all four is hiding which one it will drop. Ask the user which three matter most for *this* system, in order, and take each as a concrete scenario — "10× today's traffic on a Monday morning: what happens?", "the payments provider is down for an hour: what happens?" — because a quality with no scenario is a word, and words are never traded off against each other. Every architectural decision then names which quality it buys and which it spends. A decision that spends nothing was not an architectural decision.

- **Design one architecture, committed — never a menu.** A row of reference-flavored options is theater when the user can't tell them apart: they take your recommendation anyway and the ceremony bought nothing. Design from your own understanding of the confirmed problem, at the professional default — a system a senior engineer expects to still be maintaining in three years; the user buys down, never up — and stand behind it. Original decisions need **reasons, not citations**: the sourcing rule binds facts, never thinking. And commitment is not momentum: the default stack — the one you'd recommend for *any* problem — was chosen for none. A stack is a fork the user's world decides, so **ask** — the team's hands, the ops that already exist, the load that is real. Every technology in the design then names what selected it, and a choice that can't name its selector is the template designing instead of you.

- **Boundaries own data, and contracts cross them.** Draw the components by what each one owns — its data, its invariants, the decisions only it may make — not by what it is made of. Each boundary crossing is a named contract: what goes over it, who owns the shape, what happens when the other side is slow or gone. The blast radius of a change is the count of boundaries it crosses; a design where every change crosses every boundary is a monolith wearing a diagram. A distributed system is the more expensive default, and it is chosen only when a ranked quality demands it — a team boundary, an independent failure domain, a scaling curve that is actually different — and the design names which.

- **Size for the load that is real, and say what it cannot take.** Design for what the user measured, or honestly estimated, times the growth they expect — not for the load a famous system faced. Over-architecture is a cost with a name: every component that exists for a scale nobody has is maintained, deployed and debugged today. So the design states its envelope — the throughput, data size, latency and team size it is built for — and what breaks first past it, because a system that knows its limit gets re-architected on schedule, and one that doesn't gets re-architected at 3 a.m.

- **The field and the future attack the design; neither writes it.** Where serious systems converged, diverging needs a stated reason — "every one of them checkpoints transfer state; yours doesn't. Deliberate, or blind?" Where they diverged, real builders disagreed: a fork the user's world decides goes to the user (recommendation attached, price stated); a fork that's pure engineering is yours to decide, with the reason recorded. Then the future: walk the design through the stressors that actually arrive — load 10×, data 10×, a dependency dies or changes its terms, a requirement flips, the team splits, a region fails, a regulator asks for an audit trail, the one senior engineer leaves — and for each, what survives and what has to be rebuilt. The stance is Residuality Theory's: what survives many stressors is the residue, and the residue is the architecture. Record the attacks that landed and the ones the design walked out of, as `/discern` does, because what a design survived tells the builder how much load it was proved to take. A new subsystem in an old project has a third attacker: the decisions already recorded there (`.genius/DECIDED.md`, past work, `docs/adr/` and wherever else the repo keeps them) — contradict one and the design either loses or says which decision it overturns and why.

- **Name what changes cheaply, because the design chose it.** An architecture is a bet on which changes will come: it makes some cheap and, by the same move, makes others dear. Say both plainly — "adding a payment provider is one adapter; changing what a payment *is* touches every boundary" — so the next session knows which requests are a slice and which are a re-architecture. A design that claims everything is easy has not chosen anything.

- **Where a rule can be checked, write the check.** A dependency direction, a latency budget, a boundary nothing may reach around — each is a fitness function waiting to exist: a test, a lint rule, a script the CI runs. Write those the architecture depends on, or name them as the first slices, because a rule enforced by a test is an architecture and a rule enforced by memory is a wish. The rest — the ones no instrument reaches — say whose eyes decide, so they read as judgment rather than as checkable.

- **The walking skeleton proves the architecture before anything is built on it.** The thinnest end-to-end path through every boundary — one request in, one real answer out, deployed the way production will deploy it — is the first thing to build and the last chance to change the shape cheaply. Name it in the record as the first slice; `/galvanize` takes it as S1. An architecture confirmed on paper and disproved by its first integration is the expensive default this skill exists to prevent.

- **The user confirms consequences, not diagrams.** Play the architecture back as behavior — "a transfer dies at 80%: here's what this design does", "you hire two people: here's where they work without stepping on each other" — until the user says that's what they want. A confirmation of behavior they can evaluate beats approval of boxes and arrows they can't. Where they can't evaluate a fork, teach the actual difference first (`blindspot` skill), or record an honest `assumed:`.

## The record

The committed architecture lands in **`ARCHITECTURE.md`** at the repository root (or beside the subsystem it describes, where the project keeps such things) — a binding document, read before designing anything that touches its boundaries and rewritten in place when a later fight overturns it (`errata` skill). Its shape, the sections a stranger needs:

```markdown
# <System>

## What it is, and why it exists
The problem in one paragraph; the delta over what already exists — the reason
this is built rather than adopted, with the alternatives studied and their sources.

## Qualities, ranked
1. <quality> — <the scenario it must survive>
2. …
What this design deliberately spends to buy them.

## Envelope
Throughput, data size, latency, team size it is built for; what breaks first past it.

## Structure
The components by what each owns; the contracts that cross each boundary and
what happens when the other side is slow or gone. A diagram where one helps;
the prose is what binds.

## Runtime
The load-bearing scenarios walked through the structure: the happy path, the
partial failure, the retry, the audit. Each names what the user confirmed.

## Stack
Every technology and what selected it.

## Cheap and dear
What this design makes cheap to change, and what it makes expensive — by intent.

## Stressed against
The field it was held against (systems, sources) and the stressors it was walked
through: what landed and changed the design, what it walked out of.

## Enforced
The fitness functions — tests, lints, checks — that hold the rules above, and
the rules only eyes can hold.

## Walking skeleton
The first slice: the thinnest end-to-end path, and how it proves the shape.

## Not this
What the design deliberately does not do, and what would have to change for it to.

## Open
Forks still owed a ruling. An `assumed:` line lives in the work's snapshot Open
where a work file exists (it is drained there; a second home never is) and here
only for a standalone study with no work file.
```

The study itself — the field read, the stressors walked, the exchange where the user confirmed — is a log entry under `## architect` where the work has a work file (`genius-file` skill), and the snapshot keeps a section pointing at `ARCHITECTURE.md`. A confirmed design a future stranger would re-fight — a boundary no-, a deliberate deviation from the obvious stack — gets its line in `.genius/DECIDED.md` (`decision-record` skill), pointing at the fight; the rest stays with the architecture file. One architecture per system: a recorded `ARCHITECTURE.md` is consumed, not redone — later work designs inside its boundaries, a change that wants to cross one is a conversation, not a drift, and a subsystem gets its own file only when its qualities rank differently from the whole's.

## How it runs

1. Read what is already settled: `.genius/DECIDED.md`, `CONTEXT.md`, an existing `ARCHITECTURE.md`, the records that predate this plugin. A study already on record is consumed; research only what it does not cover.
2. Study the field, sources in hand, and put build-or-adopt to the user with your recommendation and its price. Adopt wins → record it and stop.
3. Ask for the ranked qualities and the load that is real; turn each quality into a scenario; ask the stack forks that belong to the user's world.
4. Design one architecture — boundaries by ownership, contracts across them, the envelope, the stack with selectors, cheap and dear — and attack it: the field's convergences, the stressors, the settled decisions. Change what an attack breaks; record what it walked out of.
5. Play it back as consequences until the user says that's what they want; teach or record `assumed:` where they can't call a fork.
6. Write `ARCHITECTURE.md`, the log entry where there is a work, the decision-index lines; name the walking skeleton as the first slice.

The committed architecture is the deliverable; what happens next is the user's to type — nothing here advances anything for them. Done when the user has confirmed the design in consequences they could evaluate, every quality it promises has a scenario, every technology names its selector, and `ARCHITECTURE.md` says what it makes dear as plainly as what it makes cheap.
