---
name: domain-glossary
description: Maintain the project's shared vocabulary in CONTEXT.md — challenge conflicting terms, sharpen fuzzy language, record resolutions inline. Use when a term conflicts with or is missing from the glossary, when a decision names a new concept, or when another skill needs the glossary discipline.
---

# Domain Glossary

One shared language between the user, the agent and the code — Domain-Driven Design's *ubiquitous language* — living in `CONTEXT.md` at the repo root: a glossary and nothing else. A term sharpened during one piece of work serves every later one: shorter conversations, consistent naming in code and tests.

## Format

```markdown
# {Project Name}

{One or two sentences on what this project is.}

## Language

**customer**:
{One or two sentences. What it IS, not what it does.}
Killed: *client*, *buyer* — one concept, one word.

**archive**:
Soft-hide; the user can restore it. Settled against permanent deletion in the
exports work — restorability is a support contract.
Killed: *trash*, *delete* — each carried both meanings at once.
```

- **Be opinionated.** When several words name one concept, pick the best and name the losers as killed — with what killed them where there was a real fight.
- **A fought term keeps its fight.** A term that collided carries the collision in one line: what collided, which won, why. A resolution recorded without its collision gets re-litigated.
- **Published API names outrank opinion.** A misleading name that's public API can't be renamed — define it *against* its general meaning instead ("not actually a cryptographic salt; the name is API, the definition rules").
- **Tight definitions**, one or two sentences, of what it *is*. **Project concepts only** — general programming concepts don't belong. **No implementation details**: not a spec, a scratchpad or a decision log — decisions live in their work file, indexed in `.genius/DECIDED.md`.
- **Create lazily**, at the first resolved term. **Don't hijack**: an existing `CONTEXT.md` with other content keeps it; append the `## Language` section and stay scoped to it.

## The discipline

While any conversation is shaping work:

- **Collide words with the glossary.** The user's term conflicts with an entry → stop and hold the two meanings up side by side: "The glossary says an *archived* account is restorable, but you're describing permanent deletion — which do you mean?" No building on a word that means two things at once.
- **Sharpen fuzzy terms.** One word doing two jobs → propose a precise canonical term for each.
- **Collide claims with the code.** The user says how something works; the code disagrees → surface the contradiction.
- **Update inline.** The moment a term resolves, write it — not batched at the end. A resolution that isn't written down will be re-litigated.
- **The flow's own names get one rendering in the project's language.** Where records are written in a language other than English, *slice*, *snapshot*, *contract*, *seam*, *kill-reason*, *assumed*, *backlog* and the six stage names are terms like any other: rendered differently at each writing they become several words for one concept. Record each once under `## Language`, the first time a record is written in that language (`setup-working-genius` offers it), and every record uses that rendering (`record-prose` skill).

Merely *reading* `CONTEXT.md` to use its vocabulary is not this skill. Invoke it only when the language itself is being built, challenged or changed.
