---
name: diagnose
description: Reproduction before theory on anything broken — a red-capable command before any hypothesis, ranked falsifiable hypotheses before any fix, the loop turned green as the proof. Use when something is broken, throwing, failing, flaky, or slow, or when the user asks to debug or diagnose.
---

# Diagnose

The failure mode of debugging is theory before evidence: read code until a plausible cause appears, fix that, declare victory when nothing visibly objects. It is the same momentum that skips the failing test, wearing a different problem — and the fix it produces is for a bug nobody proved exists.

The concept: **no reproduction, no hypothesis; no prediction, no fix.** (The loop discipline follows [mattpocock/skills](https://github.com/mattpocock/skills)' diagnosing-bugs.)

- **The first deliverable is a loop, not a theory.** One command, run here at least once, that shows the bug: red while the bug is present, green when it's gone, deterministic and fast enough to run after every change. A failing test is the best loop; a curl, a CLI run against a fixture, a bisection harness — whatever reaches the symptom. Catching yourself building a theory before this command exists is the stop signal: jumping to a hypothesis is the exact failure this discipline prevents. A flaky bug's loop raises the reproduction rate until signal beats noise — a one-in-two flake is debuggable, a one-in-a-hundred is not.
- **Reproduce the user's symptom, then minimise.** The loop must show *their* bug — wrong bug, wrong fix. Then cut inputs, config, and callers one at a time, re-running after each cut, until everything still standing is load-bearing.
- **Hypotheses come plural, ranked, and falsifiable.** Several before testing any — one at a time is anchoring — each in the form "if X is the cause, changing Y turns the loop green"; a hypothesis with no prediction is a vibe. Test in rank order, one variable at a time, and tag every debug artifact (`[DEBUG-xxxx]`) so cleanup is a grep, not a memory.
- **The fix earns a regression test at a real seam** — and where no correct seam exists, that absence is a finding about the design, recorded, never a license to skip. Three failed fixes mean stop fixing: the reproduction, or an assumption underneath it, is what's actually wrong.

Done when the loop that showed the bug shows it gone, run fresh; the debug tags grep to nothing; and the winning hypothesis is stated where the fix is recorded — a fix whose cause is unstated gets un-fixed by the next confident refactor.
