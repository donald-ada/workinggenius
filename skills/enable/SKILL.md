---
name: enable
description: Build one slice at a time with red-before-green tests at the agreed seams and tight feedback loops. Use when a tracked piece of work is at its enablement stage and a slice needs building.
argument-hint: "a work slug to coordinate all slices, or 'slug, slice N' to build one"
---

# Enablement

The genius of doing the work the work needs. Its failure mode is flying blind: code produced without feedback until a big-bang reveal at the end.

The concept: **build one slice at a time, in a fresh context, with reality voting every few minutes.** Tests lead the code — write the failing test at the agreed seam and watch it fail before the implementation exists; this is the one discipline a capable model still talks itself out of (measured 0/3 baseline), so hold it even when momentum says skip it. Test behavior through public seams, not implementation. Some criteria can't be red-green — verify those against the real thing and record what you observed; the rule is feedback, not ceremony.

Coordinating multiple slices? Hand each builder the work file path, verify each returned slice against real output yourself, and stay awake until they're done — a builder's word is not evidence. When the plan meets reality and loses, surface the problem and record the change — never silently improvise; a decision made without the user is an `assumed:` line, flagged for review. Close each slice with a build-log entry the next session can stand on and a commit (closing its issue, if it carries one).

Done when every slice is built and every criterion checked against output that actually ran. Next: `/tenacity`.
