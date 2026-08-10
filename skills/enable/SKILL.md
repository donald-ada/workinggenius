---
name: enable
description: Build one slice at a time with red-before-green tests at the agreed seams and tight feedback loops. Use when a tracked piece of work is at its enablement stage and a slice needs building.
argument-hint: "a work slug to coordinate all slices, or 'slug, slice N' to build one"
---

# Enablement

The genius of doing the work the work needs. Its failure mode is flying blind: code produced without feedback until a big-bang reveal at the end.

The concept: **build one slice at a time, in a fresh context, with reality voting every few minutes.** Tests lead the code — write the failing test at the agreed seam and watch it fail before the implementation exists; this is the one discipline a capable model still talks itself out of (measured 0/3 baseline), so hold it even when momentum says skip it. Test behavior through public seams, not implementation. Some criteria can't be red-green — verify those against the real thing and record what you observed; the rule is feedback, not ceremony.

Coordinating multiple slices? Hand each builder the work file path, verify each returned slice against real output yourself, and stay awake until they're done — a builder's word is not evidence. When the plan meets reality and loses, surface the problem and record the change — never silently improvise; a decision made without the user is an `assumed:` line, flagged for review. Close each slice in **one commit**: the code, the work file's build-log entry where the work file is committed, and the close of its issue if it carries one. The record then updates as a side effect of the action you had to take anyway, rather than as bookkeeping anyone has to remember. (An issue closes via `closes #N` in the message where that commit lands on the default branch, and directly, pointing at the commit, where it won't.) That entry is what the next session stands on: what landed, the conventions introduced, the edges left untested. The plan rides the same commit: when a slice revises a pinned value — a number, a seam, a criterion — correct it where the plan pinned it, in the commit that closes the slice, and in that slice's issue too where it carries one. Whoever makes the commit makes the correction. The build log stays current because updating it is a side effect of committing; nothing else stays current unless it travels the same way. Start each slice by reading the log, so a missing entry is caught by the next slice rather than at close-out. A slice reshaped mid-build closes its old issue with the reason, and its replacement joins the work's parent issue and label like any other.

Then `/tenacity`. Done when every slice is built and every criterion checked against output that actually ran — the build log naming, per criterion, what ran and what it showed. A criterion checked in your head has not been checked.
