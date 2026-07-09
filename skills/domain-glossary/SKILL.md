---
name: domain-glossary
description: Maintain the project's shared vocabulary in CONTEXT.md — challenge conflicting terms, sharpen fuzzy language, record resolutions inline. Use when a term conflicts with or is missing from the glossary, when a decision names a new concept, or when another skill needs the glossary discipline.
---

# Domain Glossary

One shared language between the user, the agent, and the code, living in `CONTEXT.md` at the repo root — a glossary and nothing else. The payoff compounds across work: a term sharpened during one piece of work serves every later one — shorter conversations, consistent naming in code and tests, fewer tokens spent decoding jargon.

## Format

```markdown
# {Project Name}

{One or two sentences on what this project is.}

## Language

**Order**:
{One or two sentences. What it IS, not what it does.}
_Avoid_: purchase, transaction

**Customer**:
A person or organization that places orders.
_Avoid_: client, buyer, account
```

Rules of the file:

- **Be opinionated.** When several words name one concept, pick the best and list the rivals under `_Avoid_`.
- **Published API names outrank opinion.** A misleading name that's public API (a decade-old keyword argument) can't be renamed — define it *against* its general meaning instead ("not actually a cryptographic salt; the name is API, the definition rules"). The glossary's job there is disambiguation, not renaming.
- **Tight definitions.** One or two sentences; define what it *is*.
- **Project concepts only.** General programming concepts (retries, timeouts, error types) don't belong, however often the project uses them.
- **No implementation details.** `CONTEXT.md` is not a spec, a scratchpad, or a decision log — decisions go in the work file or an ADR.
- **Create lazily.** No `CONTEXT.md`? Create it when the first term is resolved, not before.
- **Don't hijack.** If `CONTEXT.md` already exists with non-glossary content, leave that content alone: append the `## Language` section to it and keep the discipline scoped to that section.

## The discipline

While any conversation is shaping work:

- **Collide words with the glossary.** The user's term conflicts with an entry → stop and hold the two meanings up side by side: "The glossary says an *archived* account is restorable, but you're describing permanent deletion — which do you mean?" No building on a word that means two things at once.
- **Sharpen fuzzy terms.** One word doing two jobs ("account" naming both the merchant and a staff member's login) → propose a precise canonical term for each job.
- **Collide claims with the code.** The user says how something works; the code disagrees → surface the contradiction, don't paper over it.
- **Update inline.** The moment a term resolves, write it into `CONTEXT.md` — not batched at the end. A resolution that isn't written down will be re-litigated.

## What this skill is not

Merely *reading* `CONTEXT.md` to use its vocabulary is not this skill — any skill does that with one line. Invoke this skill only when the language itself is being built, challenged, or changed.
