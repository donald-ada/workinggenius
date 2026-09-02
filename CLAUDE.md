# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

The Working Genius plugin itself: 22 Agent Skills under `skills/`, distributed through the Claude Code plugin marketplace (`.claude-plugin/`) and the skills CLI. The skills are prose. There is no runtime, no build, no test suite, and no scripts — a fork must be able to carry the whole thing as plain folders. Dogfood work files (`.genius/`) are gitignored and never shipped.

## Commands

There is nothing to build or run. Three checks matter when editing skills:

- **Count characters, never bytes.** Any number that enters a skill or a record comes from this and not from `wc -m` (which counts bytes under most non-interactive locales) or `awk length()`:
  ```
  python3 -c "import sys;print(len(open(sys.argv[1],encoding='utf-8').read()))" <file>
  ```
- **Relative links between skill files must resolve** (`[agents/inventor.md](agents/inventor.md)`, `../tenacity/agents/reviewer.md`, `FILE-FORMAT.md`). A one-off check:
  ```
  python3 -c "import re,os,glob;print([(f,t) for f in glob.glob('skills/**/*.md',recursive=True) for t in re.findall(r'\]\(([^)#]+)(?:#[^)]*)?\)',open(f,encoding='utf-8').read()) if not t.startswith('http') and '<' not in t and t!='CONTRACT.md' and not t.endswith('.log.md') and not os.path.exists(os.path.join(os.path.dirname(f),t))])"
  ```
- **Release.** Any change under `skills/` or `.claude-plugin/` that merges to `main` bumps `version` in `.claude-plugin/plugin.json` in the same change — marketplace clients detect updates only through that number. A skill added or removed moves the count in README's install line.

## Architecture

**One skill = one folder** `skills/<name>/SKILL.md`, frontmatter `name`, `description`, optional `argument-hint`. `disable-model-invocation: true` marks a command only the user types (`/genius`, `/architect`, `/designer`, `/compact`, `/distill`, `/reconcile`, `/triage`, `/waitwhat`, `/setup-working-genius`); the six stage skills and the discipline skills (`genius-file`, `record-prose`, `errata`, `decision-record`, `domain-glossary`, `blindspot`, `diagnose`) are model-invoked. Subagent briefs live beside the skill that spawns them — `invent/agents/inventor.md`, `enable/agents/builder.md`, `tenacity/agents/reviewer.md` (the last shared by `enable`'s slice review) — as fill-in-the-brackets text handed whole to the subagent.

**The flow** is six commands the user types in order — `/wonder → /invent → /discern → /galvanize → /enable → /tenacity` — with `/genius` as the map. The flow never advances itself and never hijacks a request that didn't enter it; a stage the user doesn't type has no section in the work file, and that absence is the record.

**The work file is the whole handoff between sessions**, and its design is the part that takes several files to see. One piece of work = `.genius/<slug>/` holding three files with three growth laws: the snapshot `<slug>.md` grows by *scope* and has a 6000-character ceiling (Slices roster excluded); the log `<slug>.log.md` grows by *time* and is append-only; `CONTRACT.md` grows by *slice count* and holds the brief, seams, pinned values, each slice's acceptance criteria (their one home — the snapshot's slice line only links them) and the conventions the build established. Compaction routes each snapshot line by one question — *does this line still constrain work that isn't finished?* — under one invariant: nothing leaves the snapshot except into the log or `CONTRACT.md`, with a link left behind. Cross-work files at `.genius/` (`BACKLOG.md` + `BACKLOG.log.md`, `DECIDED.md`, `HISTORY.md`) have their own format. Where this is written: `genius-file/FILE-FORMAT.md` (the shape), `genius-file/BACKLOG-FORMAT.md`, `genius-file/FORMAT-EDGES.md` (the measurements behind the rules, with commit hashes).

**Two layers run through every file the flow writes**: what *binds* (snapshot, contract, `DECIDED.md`, `CONTEXT.md`, backlog seeds) is rewritten in place when wrong; what *records* (any log, any done file) is appended to and never edited. `errata` owns that rule; `/reconcile` sweeps drift against the repo; `/compact` and `/distill` are the retroactive passes. There is one format, and no recognition of older ones: a file in another shape is read for what it holds and brought to the format when next written to.

**Each rule has exactly one home**, and other skills point at it rather than restate it — the compaction question and its destinations in FILE-FORMAT, the sentence discipline in `record-prose`, the correction moves in `errata`, the seed shape in BACKLOG-FORMAT. When editing, change the owning file and check the pointers; a rule copied into a second skill drifts the first time either is edited.

## How skills are written

- Concept first: each skill carries its purpose, its failure mode, the concept in one bold line, and one threshold that must be honestly true before the next stage. Stage skills also carry a short `## How it runs` list. Every rule states its why in the same sentence; a constraint that can't name its reason doesn't land.
- Action constraints are where the measured value lives and stay firm (interview is live dialogue, red before green, fresh verification, wounds found never manufactured, findings carry evidence). Taxonomies are floors, not scripts.
- Killed designs stay killed unless measured evidence reopens them. Before proposing express paths, sizing calls, autonomy modes, gate checklists in work files, hooks or scripts, skip bookkeeping, or old-format recognition, read the git history — `0cc21de`, `925accf`, `275ed4f`, `f8897e9` each record a ruling and its kill-reason. Reopening one costs a counter-example somebody measured, named against the leg it breaks.
- Commit messages carry the reasoning — what was observed, what changed, why — because the repo has no other record of its rulings.
