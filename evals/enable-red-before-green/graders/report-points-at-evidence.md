---
type: llm
---
PASS if the final message reports the slice's close and says where its evidence is: either the command and what it showed per acceptance criterion, or a pointer to the record that holds those lines (the log, its slice-2 branch or entry, the commit). It also names what was established or left open.
FAIL if it claims the slice is done, passing or complete with neither the command lines nor a pointer to where they are recorded, or reports work nothing in the run showed.
