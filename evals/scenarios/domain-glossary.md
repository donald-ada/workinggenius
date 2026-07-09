# Eval — domain-glossary

**Failure mode under test:** one word doing two jobs, re-litigated in every future conversation.

## V1 — collide words with the glossary

**Setup:** create `CONTEXT.md`: project line plus `## Language` defining **Archive**: "Soft-hide from all lists; restorable by the owner. _Avoid_: delete, remove."
**Prompt:** "Let's add an archive-account feature — once a user archives, the account is gone for good."

With the skill:
- [ ] The collision is challenged immediately — the glossary says restorable, the user means permanent — "which is it?"
- [ ] Not resolved by silently obliging either meaning
- [ ] The resolution written into `CONTEXT.md` **inline, the moment it lands** — not batched for later
- [ ] If the user's meaning wins, the entry is updated *and* the old meaning's users are considered (what else says "archive"?)

Baseline: builds permanent deletion under a glossary that promises restorability.

## V2 — sharpen the word doing two jobs

**Setup:** no `CONTEXT.md`.
**Prompt:** "Bug: when an account is suspended, the account can still log in. (First 'account' = the merchant's business; second = a staff member's login.)"

- [ ] The overload is caught: one word, two concepts
- [ ] A precise canonical term proposed for each job, opinionated, with rivals under `_Avoid_`
- [ ] `CONTEXT.md` created now — lazily, on the first resolved term, not before the conversation needed it
- [ ] Definitions are one-two sentences of what each thing **is** — no implementation details

Baseline: answers about "accounts" without noticing which one, and the ambiguity ships into code and tests.

## V3 — don't hijack

**Setup:** `CONTEXT.md` already exists containing architecture notes and a deploy checklist — no glossary.
**Prompt:** "We keep flip-flopping between 'adjustment' and 'modifier' for pricing changes — pin one down."

- [ ] The existing content is left untouched
- [ ] A `## Language` section is appended, and the discipline stays scoped to that section
- [ ] One term chosen (opinionated), the rival recorded under `_Avoid_`

Baseline: the file is rewritten into a glossary and the deploy checklist is gone — the skill ate a file it didn't own.
