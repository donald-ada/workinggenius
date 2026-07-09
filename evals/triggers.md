# Trigger evals

Should-trigger / should-not-trigger prompt sets for every model-invoked skill. Run each prompt headless in the prepared scratch project (see README) and check whether the skill loaded. The near-misses are the rows that matter: prompts *adjacent* to the trigger that must not fire. `/genius` and `/setup-working-genius` are user-invoked only — no rows here; typing them is the test.

Setup shorthand: **[tracked]** = `fixtures/checkout-discounts.md` copied to `.genius/`, with `stage:` set as the row needs. **[bare]** = no `.genius/` directory.

## wonder

Should trigger:
- [tracked, stage: wonder] "Pick up the checkout-discounts work."
- [bare] "I want to start a proper piece of tracked work: merchants keep asking for gift wrapping at checkout. Question me on it first."
- [tracked, stage: wonder] "Before anyone designs anything, make sure we actually understand the discounts problem."

Should NOT trigger:
- [bare] "Add per-user rate limiting to the API." — substantive but untracked; the flow never hijacks work the user didn't put in it. The README promise, as a test.
- [tracked, stage: wonder] "What's the status of checkout-discounts?" — a read, not the interview; `genius-file` territory.
- [bare] "Quick question: what does src/upload.js do?"

## invent

Should trigger:
- [tracked, stage: invention] "Continue checkout-discounts."
- [tracked, stage: invention] "Put some genuinely different design options on the table for the discounts work."

Should NOT trigger:
- [tracked, stage: invention] "I've already got a design for discounts — poke holes in it." — an attack on a ready-made plan is Discernment.
- [bare] "Brainstorm some names for this npm package." — divergence, but not a tracked piece of work.

## discern

Should trigger:
- [tracked, stage: discernment] "Continue checkout-discounts."
- [bare] "Here's the plan a coworker wrote for the exports feature — tear it apart before we build it."

Should NOT trigger:
- [bare] "Review this diff before I merge." — review of built work, not judgment of options.
- [tracked, stage: discernment] "Which of these two npm test runners is faster in CI?" — a fact question; no work-file decision at stake.

## galvanize

Should trigger:
- [tracked, stage: galvanizing] "Continue checkout-discounts."
- [tracked, stage: galvanizing] "We settled on the pipeline option — break it into slices fresh sessions can pick up."

Should NOT trigger:
- [bare] "Add these three items to my TODO list."
- [tracked, stage: galvanizing] "Remind me what we decided for discounts and why." — a read of Discernment's record, not planning.

## enable

Should trigger:
- [tracked, stage: enablement, slices present] "Build slice 1 of checkout-discounts."
- [tracked, stage: enablement, slices present] "Carry on with the discounts build."

Should NOT trigger:
- [bare] "Write a quick script that parses this CSV." — untracked; just do it.
- [tracked, stage: enablement] "How many slices are left on checkout-discounts?" — status, not building.

## tenacity

Should trigger:
- [tracked, stage: tenacity] "All slices are built — wrap up checkout-discounts."
- [tracked, stage: tenacity] "Is the discounts work actually done? Prove it and close it out."

Should NOT trigger:
- [bare] "Run the tests." — a command, not a close-out.
- [tracked, stage: enablement] "Commit what we have so far." — mid-build commit belongs to Enablement's loop.

## genius-file

Should trigger:
- [tracked, any stage] "Where did the checkout-discounts work leave off?"
- [tracked, any stage] "Before you touch anything: what's in flight in this repo?"

Should NOT trigger:
- [bare] "Summarize the README."
- [tracked] "What does CONTEXT.md say 'adjustment' means?" — glossary lookup, not work-file discipline.

## domain-glossary

Should trigger:
- [CONTEXT.md defines *archive* = soft-hide, restorable] "Let's add a way for users to archive their account — gone for good." — collides with the glossary; the conflict must be challenged.
- [bare] "The team says 'account' meaning both the customer and the login — pin our terms down."

Should NOT trigger:
- [CONTEXT.md present] "Use the glossary's vocabulary in these test names." — merely *reading* the glossary is any skill's one-liner, not this skill; its own "What this skill is not", as a test.
- [bare] "What's the difference between authentication and authorization?" — general concepts don't belong in the glossary.
