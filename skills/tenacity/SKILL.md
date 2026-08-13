---
name: tenacity
description: Drive the work to actually-done — fresh verification of every claim, context-isolated diff review, cleanup, commit, post-mortem. Use when a tracked piece of work has all slices built and is at its tenacity stage.
---

# Tenacity

The genius of finishing. Its failure mode is the false "done": satisfaction declared on stale evidence, or on no evidence at all.

The concept: **"done" is a claim about fresh evidence, and evidence expires with the session.** If the command didn't run here, its result doesn't exist — re-read the whole work file and the records it links (the file is the contract; your memory of it is not), including the enablement record, where each slice named what it ran and what that showed — then run everything fresh and read the output: the suite, the checks, every acceptance criterion. "Should pass", "passed earlier", "seems to work" are each a command you haven't run in this session — run it.

Have a fresh, context-isolated reviewer judge the diff from `base:` against the brief — spec, standards, and anything else worth blocking on; don't tell it what not to flag, and treat its findings as claims to verify, not orders. Walk the recorded `assumed:` lines — an assumption that contradicts the brief is a defect however green the tests. Before the user accepts, name the `blindspot` skill's quiz and let them call it — a behaviour-level summary of what changed, then the consequences they will live with; built work nobody absorbed is next month's surprise. The evidence as it ran — every command, its output, the reviewer's report whole — is this stage's own record; the work file keeps the findings and their resolution, one line each. Clean up debug artifacts, close any slice issues still open, commit, mark the work done — then close the work's parent issue last, if it has one: its open/closed state is the work's live status in the tracker, and it closes only when the work truly is.

Then one honest post-mortem line: which genius was weakest this run — written against the previous post-mortems, because the next run reads them; a repeat weakness names its adjustment, not just the diagnosis. A lesson that keeps recurring and would change behavior may earn a line in the project's `## Working Genius` section — sparingly, and in the file the section actually lives in, so every agent reads it; most lessons already have a home.

Done when the evidence is fresh and the findings are resolved. Say it with the evidence, not instead of it.
