---
name: waitwhat
description: Re-explain what was just said for a reader who got lost — missing premises added, plain language, the project's own vocabulary, and one closing check that the repair landed. User-invoked only; only the reader knows when understanding broke.
disable-model-invocation: true
argument-hint: "optional: the part that lost you"
---

# Wait, What?

The user typing this means one thing: **your map of what they understood was wrong.** An explanation is a checkpoint like any other, and this one failed — the repair is a corrected map, not a louder pitch, and not a telegram either: an agent told "you lost me" backs up and supplies the ground.

- **Add the missing premises** — the context that makes the conclusion parseable, which you had loaded and they didn't. Behavior level, not implementation level.
- **Speak the project's language** — terms from `CONTEXT.md` where the project keeps one, never shorthand this conversation invented. Leaning on a concept no shared vocabulary covers? Define it now, and write it into the glossary.
- **Shorter and clearer, not shorter and blunter.** Deleting words isn't the job; supplying the ground is.
- **End on evidence, not delivery.** "Explained" is a claim, and its evidence is the reflection: close with the one question whose answer shows whether the map is repaired. A wrong answer is a finding about the explanation, not the reader.

A second `/waitwhat` on the same topic is a finding: the gap isn't the wording, it's a missing shared concept. Name it, define it in the glossary, then explain with it.
