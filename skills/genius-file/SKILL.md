---
name: genius-file
description: Read and update Working Genius work files. Use when a stage skill needs the work-file discipline, when the user asks what work is in flight or where a piece of work left off, or before resuming any work tracked under .genius/.
---

# The Work File

One piece of work = one markdown file under `.genius/`. The file is the contract: it carries the work across sessions, so no stage depends on conversation memory. Full template in [FILE-FORMAT.md](FILE-FORMAT.md).

## Where files live

Default `.genius/<slug>.md` at the repo root. A `## Working Genius` section in `CLAUDE.md` or `AGENTS.md` may override the directory — check there first. Create the directory lazily, on the first work file.

## Read discipline

- **Read before acting.** Any skill or session touching a tracked piece of work reads its file first — the file outranks whatever you remember about the work.
- The `stage:` frontmatter names the stage the work is **currently in** (not the last one finished): `wonder | invention | discernment | galvanizing | enablement | tenacity | done`.

## Write discipline

- **Write at the moment a decision lands**, not in a batch at the end. A gate that passed but wasn't written down did not pass.
- Each stage owns one section of the file and ends it with its **gate** — a checklist of completion criteria. Check items off only when they are true; never pre-check. A conditional item whose condition never arose gets checked with an inline `(n/a — reason)` — honesty needs an idiom, or it hesitates.
- Keep entries behavioral: interfaces, contracts, acceptance criteria. No *code* paths or line numbers — they go stale before the next session. Pointers to durable artifacts (an ADR, a spec doc, a docs page or tested snippet) are fine; that's what they're for.

## Modes

`mode:` in the frontmatter sets how much the flow leans on the user (default `guided`):

- **`guided`** — every stage's user checkpoints run as written. The default; right when the user is present and the work is theirs to shape.
- **`delegated`** — wherever a stage would ask the user, adopt your recommended answer and record it in that section as `assumed: <question> → <answer>`. Stop exactly once: at Galvanizing's breakdown approval — this one stop **subsumes** every checkpoint Galvanizing names (seam agreement included); present design, seams, and slices together there rather than logging theater `assumed:` lines for things visible at the same stop. Commit the plan before stopping. When the user approves at the stop, the approving session checks the **entire** Galvanizing gate right then — approval satisfies those boxes, and leaving them unchecked makes every later builder relitigate the gate. Quote the approval on the gate item (`"two slices, right size" — user`): an approval without attributed words is indistinguishable from the flow approving itself, and a reviewer will rightly ask who ratified a scope change. Then build through to done.
- **`auto`** — as `delegated`, but even that checkpoint becomes a recorded assumption. Only enter this mode when the user explicitly asked for hands-off ("run it all, don't stop me").

Assumptions are gate-satisfying: a "user confirmed" gate item may be checked in delegated/auto mode when the corresponding `assumed:` line exists — annotate the checkbox `(via assumed: — delegated)` so the page reads honestly. They are also the first thing a returning user should review — surface them.

`assumed:` is not mode-exclusive: in **any** mode, a question that arises when the user isn't reachable gets the same treatment — adopt your recommended answer, record `assumed: <question> → <answer>` in the current stage's section, surface it at next contact.

## The gate rule

A stage skill may not begin until the previous stage's gate is fully checked **or** an explicit skip is recorded. When you hit an unchecked gate, stop and offer the user two options: run the missing stage, or skip it.

## The skip protocol

Skipping a genius is allowed — silently skipping is not. To skip, record in the skipped stage's section:

```markdown
> ⚠ Skipped — <one-line reason, e.g. "trivial change, options are obvious">
```

Skips are visible on purpose: when work goes wrong later, the recorded skips are the first suspects (`/genius` reads them to diagnose genius gaps).

## Small work

Not everything deserves six stages. If the user asks to track something genuinely small (a fix, a tweak), create the file with Wonder filled in one paragraph, mark Invention and Discernment skipped with reason "small work — single obvious approach", and set `stage: galvanizing`. Record `base:` as the current commit — no separate plan commit needed; the work file rides in the slice commit. The express path is a first-class citizen, not a violation.

## Done

When Tenacity's gate is fully checked, set `stage: done` and add a one-line post-mortem: which genius was weakest this run. Done files stay in place as decision history.

Post-mortems have readers — that's what makes them worth writing honestly. Tenacity reads the earlier ones before writing a new one (a repeat weakness must name its adjustment); `/genius` reads them as a set to spot the genius that keeps coming up weakest and to calibrate sizing and mode for new work. Write each one as if the next run will act on it, because it will.

Abandoning work is also a way to be done: set `stage: done` with post-mortem `abandoned — <reason>`. An honest abandonment beats a zombie file nagging every session.
