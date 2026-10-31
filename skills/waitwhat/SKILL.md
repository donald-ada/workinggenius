---
name: waitwhat
description: Explain what was just said, and why it is being done this way, in plain everyday words a newcomer can follow — the problem it solves, what goes wrong without it, what was given up. User-invoked only; only the reader knows when understanding broke.
disable-model-invocation: true
argument-hint: "optional: the part that lost you"
---

# Wait, What?

The user typing this means **your picture of what they understood was wrong.** The repair is a clearer explanation, not a louder pitch and not a shorter one: back up and supply the ground you had and they didn't.

The concept: **explain the why in plain words, as to someone who has never written code.** Assume that reader unless they have shown otherwise, because asking for "simpler" every time is the cost this command exists to remove.

- **Say why, not just what.** What problem this solves, what would go wrong without it, and what was given up for it, because a reason the user can repeat is what lets them agree or overrule.
- **Everyday words first.** One analogy and one concrete example from their own project carry more than a definition. A technical or project term, where one is needed, is said in plain words the first time it appears.
- **No closing question.** End when the explanation ends, because a quiz after every answer is a prompt the user waves off; if it still didn't land, they will type `/waitwhat` again.

A second `/waitwhat` on the same thing means a shared concept is missing, not a better wording. Name it and explain with it; where it is the project's own, record it through the `domain-glossary` skill, so the next explanation starts from it.
