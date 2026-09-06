---
name: designer
description: Settle the look before the pixels — audience and context first, then the base and the delta, taste settled by looking at real states, accessibility as the floor, one design language committed to DESIGN.md as tokens with roles. A command the user types, for work with an interface someone will see; standalone, no other skill required.
disable-model-invocation: true
argument-hint: "the product or surface to design"
---

# Designer

UI built without a style conversation wears the model's default aesthetic — the look it would produce for *any* product, chosen for none. Taste is the fork that belongs most completely to the user's world, and the one the momentum of building never stops to ask about.

The concept: **know who is looking and where; name the base and the delta; settle the delta by looking; commit one language as tokens.** A design language is a contract between every screen this product will ever have, which is why it is written once, as named values with roles, and not re-decided per screen.

## The discipline

- **Audience and context come before taste.** Who uses this, on what, for how long, in what state of mind — a nurse glancing at a phone between patients, an analyst at a desk for eight hours — decides density, type size, motion budget and contrast before anyone has an opinion about colors. Ask it first, in one exchange, because a delta chosen against the wrong audience is a beautiful mistake.

- **Then the base — and how much of it survives.** An existing surface, a brand guide, a shipped base (13 curated templates in this skill's `bases/` folder — minimal, editorial, neobrutalism, glassmorphism, neumorphism, bento, mono, retro, neon, paper, premium, corporate, claymorphism — vendored MIT from [awesome-design-skills](https://github.com/bergside/awesome-design-skills), trimmed to their foundations and tokens), a famous style, or nothing. Delta zero is adopting: one exchange, no research. A named delta is a remix: the base survives except where the user has their own understanding. No base is crafting from the problem itself. **Cost follows the delta**; a shipped base is a starting *token set*, and the language is the delta written down.

- **A file base is read; an impression base is honored, never impersonated.** A template in hand is ground truth — read it, cite it. A vibe-named base ("Notion-like") yields *our* tokens in its spirit, never invented hex codes presented as facts about someone else's product.

- **Deltas come from what the user has opinions about.** Ask where they've signaled, plus one open door — "anything else about the base that bugs you?" — never an axis-by-axis walk. The axes (color, type, spacing, motion, density, texture, voice) are DESIGN.md's recording floor, not an interview script.

- **Taste is settled by looking, never by adjectives.** "Clean", "modern", "premium" select nothing. Show a throwaway style tile — the same screen under the proposed language, two or three ways only where a fork is genuinely open — as a plain HTML file. **A tile shows real states**: the empty state, an error, a disabled control, a focused one, the longest realistic string in the narrowest width — because the empty state is where the model's default comes back. Keep the answer in DESIGN.md and delete the tiles; structure that was drawn is not structure that was decided. When nothing at hand settles a fork, offer the hunt **with its price**: real references found live for this domain and audience, each with its source — never the canon every model recalls.

- **Accessibility is the floor, not a delta.** Contrast at WCAG AA — 4.5:1 for body, 3:1 for large text and control boundaries — **computed from the token values, never eyeballed**; visible focus on every interactive element; touch targets of 44px or more where fingers are the pointer; `prefers-reduced-motion` honored by every motion token; semantic structure before ARIA. Not asked about and not traded against a delta: a palette that fails contrast is adjusted until it passes, the adjustment shown in the tile.

- **Boldness is spent in one place, and the quiet elsewhere is measured.** The language names its **signature** — the one element a screen is remembered by — and keeps everything around it quiet by rule: at most one accent per screen, one display face and one text face, a motion budget in milliseconds. A language where everything is bold has no signature.

- **Tokens are the contract, and they carry roles, not just values.** `color.surface`, `color.text.muted`, `color.accent` bind screens; `#F4F1EA` binds nothing. Type is a scale with a stated ratio and a role per step; spacing a scale on one base; radius, elevation, duration and easing named the same way. Dark mode is decided here — a second value per role, or a deliberate "light only" — because a theme that arrives by drift arrives with half its contrast ratios unmeasured.

- **Commit one language to `DESIGN.md`.** The recorded language is auditable: a later review holds a UI diff against it and asks three questions — does it use the roles, does it spend boldness where the signature says, do its states exist. A "no" to any is a finding, not a taste. Craft is the floor whatever the direction; the user buys down from professional, never up.

## The record

```markdown
# <Product> — design language

## Audience and context
Who, on what, for how long, in what state of mind; what that decides.

## Base and deltas
The base and its source; each delta as "the base does X; we do Y, because Z".

## Signature
The one place boldness is spent. The rules of restraint everywhere else.

## Tokens
Color — semantic roles over raw values; light and dark values, or "light only", decided.
Type — faces (one display, one text), scale and ratio, role per step, line length.
Space — the base and the scale. Radius, elevation, duration, easing, density.

## Components
The states every component has: empty, loading, error, disabled, focus.

## Voice
How labels are written; what an empty state says; how an error sounds.

## Accessibility floor
Contrast ratios per text/surface pair, computed; focus; targets; reduced motion.

## References
Each with its source. What was looked at and rejected, and why.

## Not this
What the language deliberately avoids.
```

One language per product: a recorded `DESIGN.md` is consumed, not redone — later screens speak it, a screen that wants to break it is a conversation, not a drift, and an incoming template's own design file is a base input, never a second language. It is binding: rewritten in place when a fight overturns a rule (`errata` skill).

## How it runs

1. Ask audience and context, in one exchange. Read what already binds: an existing `DESIGN.md`, a brand guide, the surfaces that ship today.
2. Name the base with the user — file, impression, or none — and ask where they have opinions, plus the one open door.
3. Build the tile: the same screen under the proposed language, in its real states, two or three ways only where a fork is open. Compute the contrast ratios before showing it; adjust what fails.
4. Look together; settle each fork by what they see. Hunt live references, price stated, only for what nothing at hand settles.
5. Write `DESIGN.md` — tokens with roles, the signature, the floor with its numbers — and delete the tiles.

The committed language is the deliverable; what happens next is the user's to type. Done when the user has chosen by looking at real states, every token has a role, every text/surface pair has a computed ratio at or above the floor, and the signature is one place.
