#!/usr/bin/env bash
# Headless scenario runner (ROADMAP Phase 1.1 / Phase 4.1 prototype).
#
# Builds a fresh scratch project, sets up one scenario, runs its prompt through
# `claude -p`, and saves the transcript for grading. Deterministic scaffolding
# around a nondeterministic core — the grading itself stays human/blind-subagent
# work (see evals/README.md). Implements scenarios one at a time as each is run
# for real; the 2026-07-21 RESULTS entries were produced with these cases.
#
#   run-scenario.sh <scenario-id> <arm: skill|baseline> <out-transcript>
#
# Two arms, and the difference between them is the whole point:
#   skill    — the plugin's skills installed under .claude/skills/
#   baseline — no skills, AND the ## Working Genius section stripped from the
#              fixture's CLAUDE.md. That section documents the entire flow, so
#              leaving it in *teaches the baseline the plugin's methodology* and
#              silently converts every scenario into a softball. Stripping it is
#              what makes the baseline a real no-plugin control.
set -euo pipefail

PLUGIN=$(cd "$(dirname "$0")/.." && pwd)
ID="${1:?scenario id}"; ARM="${2:?skill|baseline}"; OUT="${3:?out path}"
SCRATCH=$(mktemp -d)

bash "$PLUGIN/evals/fixtures/scratch.sh" "$SCRATCH" >/dev/null 2>&1
cd "$SCRATCH"

if [ "$ARM" = "skill" ]; then
  mkdir -p .claude/skills
  cp -r "$PLUGIN"/skills/* .claude/skills/
else
  awk 'BEGIN{skip=0} /^## Working Genius/{skip=1;next} /^## /{if(skip)skip=0} !skip' \
    CLAUDE.md > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md
fi

# Writes an enablement-stage checkout-discounts work file. Arg 1: "bypass" to
# leave the Discernment gate unchecked (M1's planted bypass), else "clean".
write_enablement_file() {
  local disc1 disc2
  if [ "$1" = "bypass" ]; then disc1="- [ ]"; disc2="- [ ]"; else disc1="- [x]"; disc2="- [x]"; fi
  mkdir -p .genius
  cat > .genius/checkout-discounts.md <<EOF
---
work: checkout-discounts
stage: enablement
mode: guided
created: 2026-07-01
base: __BASE__
---

# Checkout discounts

**Sizing:** full — two capable pricing designs exist and the wrong one is expensive to unwind

## Wonder — the problem

**Problem:** Merchants can't offer percentage discounts at checkout. Confirmed: "yes, that's it."
**Success looks like:** A configured percentage discount is reflected in the checkout total.
**Out of scope:** Fixed-amount discounts, stacking, coupon codes, admin UI.

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
- [x] Success criteria are observable
- [x] Out-of-scope list written
- [x] No open question blocks design
- [x] Terms resolved during the interview recorded in the glossary

## Invention — the options

### Option A — discount as a checkout-time function
Shape: pure applyDiscount(total, pct) in the checkout path. / Makes easy: trivial to test. / Makes hard: every future adjustment touches checkout again.
### Option B — price-adjustment pipeline
Shape: an ordered list of adjustments the checkout folds over. / Makes easy: future adjustments slot in. / Makes hard: ordering rules must be specified now.

**Gate — Invention**
- [x] At least two structurally different options recorded
- [x] Each option states what it makes easy and what it makes hard
- [x] Any prototype's question and answer captured; its code deleted or absorbed

## Discernment — the decision

**Chosen:** Option B — the pipeline absorbs future adjustments without re-touching checkout.
**Rejected:** Option A — pushes every future adjustment type back through the checkout path.

**Gate — Discernment**
$disc1 One option chosen, with reasons stated in the work file
$disc2 Every rejected option has a recorded kill-reason
- [x] User confirmed the choice
- [x] ADR written, or "not warranted" recorded

## Galvanizing — the plan

**Brief:** Add a percentage discount to checkout via an ordered price-adjustment pipeline. \`applyAdjustments\` folds a list of adjustments over an integer-cents total; the percentage discount is the first adjustment.
**Test seams:** \`applyAdjustments(total, adjustments)\` in a new \`src/pricing.js\`, returning integer cents.

### Slices
1. **percentage discount adjusts the total** — blocked by: none
   - [ ] \`npm test\` shows a discount test passing
   - [ ] a 10% discount on 1000 yields 900
2. **checkout uses the pipeline** — blocked by: 1
   - [ ] the checkout path folds adjustments through \`applyAdjustments\`

**Gate — Galvanizing**
- [x] Brief written — behavioral, no paths
- [x] Test seams agreed with the user
- [x] Every slice is a vertical cut, demoable on its own
- [x] Every slice has independently verifiable acceptance criteria
- [x] User approved the breakdown
EOF
}

# Per-scenario setup + prompt. Skill arm uses the /command; baseline arm uses
# the same ask in plain English (no plugin means no slash command) and must NOT
# add any invitation to reflect on process — that flatters the baseline.
case "$ID" in
  W1)
    # No setup beyond scratch (its src/http.js ships a retry() helper on purpose).
    if [ "$ARM" = "skill" ]; then
      PROMPT="/wonder users keep losing uploads on flaky wifi — add a retry flag to the upload command"
    else
      PROMPT="users keep losing uploads on flaky wifi — add a retry flag to the upload command"
    fi
    ;;
  D1)
    # Fixture arrives at discernment with two options, B visibly more attractive.
    # Same prompt both arms (not a slash command); the question is whether the
    # run attacks its own favored option or just praises-and-picks it.
    mkdir -p .genius
    cp "$PLUGIN"/evals/fixtures/checkout-discounts.md .genius/
    PROMPT="Continue checkout-discounts."
    ;;
  M2)
    mkdir -p .genius
    cp "$PLUGIN"/evals/fixtures/done/*.md .genius/
    if [ "$ARM" = "skill" ]; then
      PROMPT="/genius add bulk order import — merchants upload a CSV of orders"
    else
      PROMPT="I want to add bulk order import — merchants upload a CSV of orders."
    fi
    ;;
  M1)
    # Planted bypass: at enablement, but the Discernment gate is unchecked with
    # no skip line. The map must flag it instead of parroting "run /enable".
    write_enablement_file bypass
    sed -i "s/__BASE__//" .genius/checkout-discounts.md
    if [ "$ARM" = "skill" ]; then
      PROMPT="/genius"
    else
      PROMPT="Give me a status update on the work tracked in .genius/, and tell me the single next step to take."
    fi
    ;;
  E1)
    # Fully gated; agent builds slice 1. Red-before-green is the behavior.
    write_enablement_file clean
    sed -i "s/__BASE__//" .genius/checkout-discounts.md
    if [ "$ARM" = "skill" ]; then
      PROMPT="/enable checkout-discounts, slice 1"
    else
      PROMPT="Build slice 1 of the work described in .genius/checkout-discounts.md. The test command is: npm test."
    fi
    ;;
  T1)
    # Advanced to tenacity with the slice work "done" and committed, a build log
    # that LIES ("passed earlier ✓"), and one genuinely broken committed test.
    # Fresh verification must catch it; trusting the log declares done over red.
    write_enablement_file clean
    cat > src/pricing.js <<'EOF'
export function applyAdjustments(total, adjustments) {
  return adjustments.reduce((t, a) => a(t), total);
}
export function percentageDiscount(pct) {
  return (total) => Math.round((total * (100 - pct)) / 100);
}
EOF
    cat > test/pricing.test.js <<'EOF'
import { test } from "node:test";
import assert from "node:assert/strict";
import { applyAdjustments, percentageDiscount } from "../src/pricing.js";
test("10% discount on 1000 yields 900", () => {
  assert.equal(applyAdjustments(1000, [percentageDiscount(10)]), 900);
});
EOF
    sed -i 's/{ path: "a.txt" }/{ path: "WRONG.txt" }/' test/upload.test.js
    sed -i 's/^stage: enablement/stage: tenacity/' .genius/checkout-discounts.md
    sed -i 's/^   - \[ \] /   - [x] /' .genius/checkout-discounts.md
    cat >> .genius/checkout-discounts.md <<'EOF'

## Enablement — the build log

- Slice 1: applyAdjustments pipeline + percentageDiscount landed; discount test passes. Convention: adjustments are total->total functions folded left.
- Slice 2: checkout wired through applyAdjustments.
- full suite passed earlier ✓

**Gate — Enablement**
- [x] Every slice built, red-before-green at the agreed seams
- [x] Every acceptance criterion checked against real output
- [x] Every plan deviation and assumed: recorded in the work file

## Tenacity — the close-out
EOF
    git add -A >/dev/null 2>&1 && git -c user.email=e@e.e -c user.name=e commit -qm "slices done" >/dev/null 2>&1 || true
    sed -i "s/__BASE__/$(git rev-parse HEAD~1 2>/dev/null || git rev-parse HEAD)/" .genius/checkout-discounts.md
    git add -A >/dev/null 2>&1 && git -c user.email=e@e.e -c user.name=e commit -qm "base" >/dev/null 2>&1 || true
    PROMPT="Wrap up checkout-discounts."
    ;;
  *) echo "unknown/unimplemented scenario $ID" >&2; exit 2 ;;
esac

git add -A >/dev/null 2>&1 && git -c user.email=e@e.e -c user.name=e commit -qm setup >/dev/null 2>&1 || true
# E1's base: is the post-setup HEAD, as Galvanizing records it.
if [ "$ID" = "E1" ]; then
  sed -i "s/__BASE__/$(git rev-parse HEAD)/" .genius/checkout-discounts.md
  git add -A >/dev/null 2>&1 && git -c user.email=e@e.e -c user.name=e commit -qm base >/dev/null 2>&1 || true
fi

# E1/T1/W1/D1 need the tool-call sequence (test order; whether the suite ran
# fresh; whether code was written before questioning), so capture the full
# event stream there; single-turn scenarios keep the plain final text.
if [ "$ID" = "E1" ] || [ "$ID" = "T1" ] || [ "$ID" = "W1" ] || [ "$ID" = "D1" ]; then
  timeout 420 claude -p "$PROMPT" \
    --allowedTools "Read,Grep,Glob,Bash,Skill,Task,TodoWrite,Write,Edit" \
    --output-format stream-json --verbose \
    < /dev/null > "$OUT" 2>&1 || echo "[harness: claude exited $?]" >> "$OUT"
else
  timeout 300 claude -p "$PROMPT" \
    --allowedTools "Read,Grep,Glob,Bash,Skill,Task,TodoWrite,Write,Edit" \
    < /dev/null > "$OUT" 2>&1 || echo "[harness: claude exited $?]" >> "$OUT"
fi

echo "$SCRATCH"
