---
type: llm
---
PASS if the reply says there is no work in flight here (no work files, nothing tracked yet) and names a way to start the flow on an idea: `/genius <idea>` (the map starts a piece of work) or `/wonder` (the interview on a new idea).
FAIL if it claims some piece of work exists or is at a stage, reports counts that were not in any tool output, asks the user what to build, or starts building or interviewing on its own.
