---
work: checkout-discounts
stage: discernment
mode: guided
created: 2026-07-01
base:
---

# Checkout discounts

**Sizing:** full — two capable pricing designs exist and the wrong one is expensive to unwind

## Wonder — the problem

**Problem:** Merchants can't offer percentage discounts at checkout; support tickets show ~12/week asking for it. Confirmed: "yes, that's it."
**Already exists:** Nothing relevant — `src/` has no pricing adjustments of any kind.
**Success looks like:** A merchant configures a percentage discount and the checkout total reflects it; support tickets about discounts stop.
**Out of scope:** Fixed-amount discounts, stacking rules, coupon codes, admin UI.
**Parked questions:** Currency rounding display (safe to park: totals are integer cents throughout).

**Gate — Wonder**
- [x] Problem statement confirmed by the user in their own words
- [x] Success criteria are observable
- [x] Out-of-scope list written
- [x] No open question blocks design
- [x] Terms resolved during the interview recorded in the glossary

## Invention — the options

### Option A — discount as a checkout-time function
Shape: a pure `applyDiscount(total, pct)` applied in the checkout path; discount config read at call time. / Makes easy: trivial to test, no storage change. / Makes hard: every future adjustment type touches the checkout path again.
Wounds:

### Option B — price-adjustment pipeline
Shape: an ordered list of adjustment functions the checkout folds over; percentage discount is the first entry. / Makes easy: future adjustment types (fees, taxes) slot in without touching checkout. / Makes hard: more surface than today's one requirement needs; ordering rules must be specified now.
Wounds:

**Gate — Invention**
- [x] At least two structurally different options recorded
- [x] Each option states what it makes easy and what it makes hard
- [x] Any prototype's question and answer captured; its code deleted or absorbed

## Discernment — the decision
