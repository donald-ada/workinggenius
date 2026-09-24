---
type: llm
---
PASS if the final message interviews the user about the request: it asks more than one question in the same message, each question is one the user alone can answer (not something the repo could settle), each carries the assistant's own recommendation, and nothing is designed or built yet.
FAIL if it proposes an implementation, writes or plans code, asks only one question at a time, asks questions with no recommendation attached, or declares the problem confirmed without the user having answered.
