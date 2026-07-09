---
work: webhook-retries
stage: done
mode: guided
created: 2026-06-04
---

# Webhook delivery retries

**Problem:** Failed webhook deliveries were dropped silently; consumers missed events.

**Post-mortem:** Wonder weakest — the express path was taken, but "retry" hid a real decision (at-least-once vs at-most-once) that surfaced mid-build.
