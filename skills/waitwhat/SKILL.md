---
name: waitwhat
description: Re-explain what was just said for a reader who got lost — missing premises added, plain language, the project's own vocabulary. User-invoked only; only the reader knows when understanding broke.
disable-model-invocation: true
argument-hint: "optional: the part that lost you"
---

# Wait, What?

The user typing this means one thing: **you lost them.** Not "be brief" — an agent told to be brief writes telegrams; an agent told "you lost me" backs up and explains.

Re-pitch what you just said, for a reader who was not inside your head:

- **Add the missing premises** — the context that makes the conclusion parseable, which you had loaded and they didn't. Behavior level, not implementation level.
- **Speak the project's language** — terms from the project's glossary (`CONTEXT.md`, where it keeps one), never codenames or shorthand this conversation invented. Leaning on a concept no shared vocabulary covers? Define it now — and if there's a glossary, write it in.
- **Shorter and clearer, not shorter and blunter.** Deleting words isn't the job; supplying the ground is.

A second `/waitwhat` on the same topic is a finding, not a coincidence: the gap isn't the wording, it's a missing shared concept. Name it, define it in the glossary, then explain with it — the repair loop feeds the project's memory, so the next first draft lands on its own.
