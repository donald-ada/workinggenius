---
name: discern
description: Judge the invented options adversarially and choose one, with recorded reasons and kill-reasons.
disable-model-invocation: true
---

# Discernment

The genius of judgment. Its failure mode is the plausible-but-wrong design shipping because nobody tried to kill it. Discernment is where every option earns its survival.

Run the `genius-file` skill: read the work file. Invention's gate must be checked (or skipped, recorded) before this stage begins.

## Process

### 1. Try to kill every option

For each option — including the one you privately prefer — attack it:

- **Against the success criteria** from Wonder: walk each criterion; where does this option strain to meet it?
- **Against edge cases**: invent concrete scenarios that probe the boundaries. "What happens when X and then Y?" beats abstract doubt.
- **Against the codebase**: does it fight an existing convention, contradict a recorded decision (check `docs/adr/` if present), or demand a migration nobody scoped?
- **Against the future**: what does the next change in this area cost under this option?

Record each wound in the work file under its option. An option that takes no wounds hasn't been attacked hard enough.

If **every** option takes a fatal wound, that's a finding, not a failure: go back to `/invent` with the wounds as new constraints — or to `/wonder` if the wounds reveal the problem itself was mis-stated. Record the loop-back in the work file.

### 2. Choose one — opinionated

Pick the survivor and say why in plain language. Do not present a menu and make the user choose from silence — recommend, with reasons, then let them overrule.

Name the choice in the project's language: if the decision christens a new concept or settles an overloaded term, run the `domain-glossary` skill and update `CONTEXT.md` inline — the deepened module deserves a name the whole project will keep using.

### 3. Record the kill-reasons

For every rejected option, write one line: what killed it. This is the part future sessions thank you for — a rejection without a recorded reason gets re-proposed in six weeks.

### 4. Offer an ADR — sparingly

Offer to write an ADR (`docs/adr/NNNN-slug.md`, a paragraph is enough) only when all three hold:

1. **Hard to reverse** — changing your mind later costs real work
2. **Surprising without context** — a future reader would wonder "why on earth?"
3. **A real trade-off** — genuine alternatives existed and you picked one for specific reasons

Any of the three missing → skip the ADR; the work file's Discernment section already records the decision.

## Gate — Discernment

- [ ] One option chosen, with reasons stated in the work file
- [ ] Every rejected option has a recorded kill-reason
- [ ] User confirmed the choice
- [ ] ADR written, or "not warranted" recorded

Set `stage: galvanizing` and tell the user: next is `/galvanize`.
