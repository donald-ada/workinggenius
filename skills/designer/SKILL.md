---
name: designer
description: Settle the look before the pixels — audience and context first, then the base and the delta, taste settled by looking at real states, accessibility as the floor, one design language committed to DESIGN.md as tokens with roles. A command the user types, for work with an interface someone will see; standalone, no other skill required.
disable-model-invocation: true
argument-hint: "the product or surface to design"
---

# Designer

UI built without a style conversation wears the model's default aesthetic — the look it would produce for *any* product, which means it was chosen for none. That default is momentum, not design. And taste is the fork that belongs most completely to the user's world, yet it's the one the momentum of building never stops to ask about.

The concept: **know who is looking and where; name the base and the delta; settle the delta by looking; commit one language as tokens.** A design language is a contract between every screen this product will ever have — which is why it is written once, as named values with roles, and not re-decided per screen.

## The discipline

- **Audience and context come before taste.** Who uses this, on what, for how long, and in what state of mind — a nurse glancing at a phone between patients, an analyst at a desk for eight hours, a buyer deciding in thirty seconds — decides density, type size, motion budget and contrast before anyone has an opinion about colors. Ask it first, in one exchange, because a delta chosen against the wrong audience is a beautiful mistake: the dense dashboard the analyst wanted is unreadable at a glance, and the airy landing page is useless at a desk all day. DESIGN.md records the answer as the first thing a later screen reads.

- **The first question after that is the base — and how much of it survives.** An existing surface, a brand guide, a shipped base (**13 curated templates live in this skill's `bases/` folder** — minimal, editorial, neobrutalism, glassmorphism, neumorphism, bento, mono, retro, neon, paper, premium, corporate, claymorphism — vendored MIT from [awesome-design-skills](https://github.com/bergside/awesome-design-skills), whose full 67-template catalog stays one pull upstream), a famous style, or nothing. Delta zero is adopting: a successful outcome, one exchange, no research. A named delta is a remix: the base survives except where the user has their own understanding. No base is crafting from the problem itself. **Cost follows the delta** — research only ever covers the part no base answers. A shipped base is a starting *token set*; its generic rule lists are not this product's rules, and the language is the delta written down.

- **A file base is read; an impression base is honored, never impersonated.** A template or existing surface in hand is ground truth — read it, absorb it, cite it. A vibe-named base ("Notion-like") yields *our* tokens in its spirit — never invented hex codes and type scales presented as facts about someone else's product. Claims about a real design carry their source; our own language carries its reasons.

- **Deltas come from what the user has opinions about.** Ask where they've signaled ("the colors and the motion I see differently"), plus one open door — "anything else about the base that bugs you?" — never an axis-by-axis walk. The axes (color, type, spacing, motion, density, texture, voice — the words on screen are design material too) are DESIGN.md's recording floor, not an interview script.

- **Taste is settled by looking, never by adjectives.** "Clean", "modern", "premium" select nothing. Show the thing: a throwaway style tile — the same screen under the proposed language, two or three ways only where a fork is genuinely open — as a plain HTML file anything can display. **A tile shows real states, not the happy screen alone**: the empty state, an error, a disabled control, a focused one, the longest realistic string in the narrowest realistic width — because the happy screen is where every language looks fine and the empty state is where the model's default comes back. Keep the answer, not the code: the decision lands in DESIGN.md, the tiles get deleted. Say what each tile is asking about, and leave everything else it displays open for whoever owns it: to show a screen at all a tile must show a structure, and structure that was drawn is not structure that was decided. When nothing at hand settles a fork, offer the hunt **with its price**: real references found live for this product's domain and audience (galleries and award showcases are hunting grounds, not template bins), each with its source — never the canon every model recalls.

- **Accessibility is the floor, not a delta.** Text contrast at WCAG AA — 4.5:1 for body, 3:1 for large text and for the boundaries of controls — is **computed from the token values, never eyeballed**, because a tile that looks fine on one screen has passed no test; visible focus on every interactive element; touch targets of 44px or more where fingers are the pointer; `prefers-reduced-motion` honored by every motion token; semantic structure before ARIA. These are not asked about, and they are not traded against a delta: a palette the user loves that fails contrast is adjusted until it passes, and the adjustment is shown in the tile. A language that fails its floor is not a language, it is a mood board.

- **Boldness is spent in one place, and the quiet elsewhere is measured.** The language names its **signature** — the one element a screen is remembered by, where the accent, the display type, the motion budget go — and everything around it is kept quiet by rule, not by hope: at most one accent per screen, one display face and one text face, a motion budget stated in milliseconds. The rules of restraint are what make the signature visible; a language where everything is bold has no signature.

- **Tokens are the contract, and they carry roles, not just values.** In the W3C sense — a name, a role, a value — with the semantic layer over the raw one: `color.surface`, `color.text.muted`, `color.accent` bind screens; `#F4F1EA` binds nothing. Type is a scale with a stated ratio and a role per step; spacing is a scale on one base; radius, elevation, duration and easing are named the same way. Dark mode is decided here, not discovered later: one token set with a second value per role, or a deliberate "light only", because a theme that arrives by drift arrives with half its contrast ratios unmeasured. Components then reference roles; a screen that reaches for a raw value is reaching around the contract.

- **Commit one language to `DESIGN.md`.** It carries the audience, the base and its deltas, the signature and the rules of restraint, the tokens, the states every component must have (empty, loading, error, disabled, focus), the voice — labels, empty-state copy, the tone of an error — the accessibility floor with the computed ratios, the references with sources, and what the language deliberately avoids. Craft is the floor whatever the direction: hierarchy that guides the eye, states that exist, motion with restraint — the user buys down from professional, never up to it. And the recorded language is auditable: any later review holds a UI diff against it and asks three questions — does it use the roles, does it spend boldness where the signature says, do its states exist. A "no" to any is a finding, not a taste.

## The record

```markdown
# <Product> — design language

## Audience and context
Who, on what, for how long, in what state of mind; what that decides (density, type size, motion budget).

## Base and deltas
The base and its source; each delta as "the base does X; we do Y, because Z".

## Signature
The one place boldness is spent. The rules of restraint everywhere else.

## Tokens
Color — semantic roles over raw values; light and dark values, or "light only", decided.
Type — faces (one display, one text), scale and ratio, role per step, line length.
Space — the base and the scale. Radius, elevation, duration, easing, density.

## Components
The states every component has: empty, loading, error, disabled, focus. Anatomy where it binds.

## Voice
How labels are written; what an empty state says; how an error sounds.

## Accessibility floor
Contrast ratios per text/surface pair, computed; focus; targets; reduced motion.

## References
Each with its source. What was looked at and rejected, and why.

## Not this
What the language deliberately avoids.
```

One language per product: a recorded `DESIGN.md` is consumed, not redone — later screens speak it, a screen that wants to break it is a conversation, not a drift, and an incoming template's own design file is a base input to absorb, never a second language. It is a binding document: rewritten in place when a fight overturns a rule (`errata` skill), the old rule and what overturned it kept in the work's log where one exists.

## How it runs

1. Ask audience and context, in one exchange. Read what already binds: an existing `DESIGN.md`, a brand guide, the surfaces that ship today.
2. Name the base with the user — file, impression, or none — and ask where they have opinions, plus the one open door.
3. Build the tile: the same screen under the proposed language, in its real states, two or three ways only where a fork is genuinely open. Compute the contrast ratios before showing it; adjust what fails.
4. Look together; settle each fork by what they see. Hunt live references, with the price stated, only for the part nothing at hand settles.
5. Write `DESIGN.md` — tokens with roles, the signature, the floor with its numbers — and delete the tiles.

The committed language is the deliverable; what happens next is the user's to type. Done when the user has chosen by looking at real states, every token has a role, every text/surface pair has a computed ratio at or above the floor, and the signature is one place.
