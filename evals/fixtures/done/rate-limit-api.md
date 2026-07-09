---
work: rate-limit-api
stage: done
mode: delegated
created: 2026-05-19
---

# Per-user API rate limiting

**Problem:** One tenant's polling loop degraded the API for everyone.

**Post-mortem:** Enablement weakest — two slices drifted off the agreed seam and the tests had to be rewritten at close-out.
