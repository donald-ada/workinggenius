---
name: designer
description: Settle the look before the pixels — audience and context first, then the base and the delta, directions drawn by Claude Code's `/design` from a brief and a critic's read of the chosen one, accessibility as the floor, one design language committed to DESIGN.md as tokens with roles. A command the user types, for work with an interface someone will see; standalone, no other skill required.
disable-model-invocation: true
argument-hint: "the product or surface to design"
---

# Designer

UI built without a style conversation wears the model's default aesthetic — the look it would produce for *any* product, chosen for none. Taste is the fork that belongs most completely to the user's world, and the one the momentum of building never stops to ask about.

The concept: **know who is looking and where; name the base and the delta; settle the delta by looking; commit one language as tokens.** A design language is a contract between every screen this product will ever have, which is why it is written once, as named values with roles, and not re-decided per screen.

## The discipline

- **Audience and context come before taste.** Who uses this, on what, for how long, in what state of mind — a nurse glancing at a phone between patients, an analyst at a desk for eight hours — decides density, type size, motion budget and contrast before anyone has an opinion about colors. Ask it first, in one exchange, because a delta chosen against the wrong audience is a beautiful mistake.

- **Then the base — and how much of it survives.** An existing surface, a brand guide, a style the user names, or nothing. Nothing is the ordinary case, not the gap to fill: with no base, the directions are drawn from the problem itself (below), because a template reached for when nobody asked for one is a default wearing a name. The 13 shipped bases in this skill's `bases/` folder (minimal, editorial, neobrutalism, glassmorphism, neumorphism, bento, mono, retro, neon, paper, premium, corporate, claymorphism; vendored MIT from [awesome-design-skills](https://github.com/bergside/awesome-design-skills), trimmed to their foundations and tokens) are the fast path when the user names one of those looks: delta zero is adopting, one exchange about the base and no directions drawn. The floor and the critic still run, because a shipped base's tokens are not guaranteed to pass (mono's text on its surface is 3.82:1). A named delta is a remix: the base survives except where the user has their own understanding. **Cost follows the delta**; a shipped base is a starting *token set*, and the language is the delta written down.

- **A file base is read; an impression base is honored, never impersonated.** A template in hand is ground truth — read it, cite it. A vibe-named base ("Notion-like") yields *our* tokens in its spirit, never invented hex codes presented as facts about someone else's product.

- **Deltas come from what the user has opinions about.** Ask where they've signaled, plus one open door — "anything else about the base that bugs you?" — never an axis-by-axis walk. The axes (color, type, spacing, motion, density, texture, voice) are DESIGN.md's recording floor, not an interview script.

- **Taste is settled by looking, never by adjectives.** "Clean", "modern", "premium" select nothing. Where a fork is open, the directions are drawn by Claude Code's `/design`, which publishes a canvas of editable artboards the user picks from; this skill's part is the **brief** it draws from, because a generator handed one line draws the default for any product. The brief carries the audience and context, the base and each delta, the screen, **the real states every artboard must show** (the empty state, an error, a disabled control, a focused one, the longest realistic string in the narrowest width, because the empty state is where the model's default comes back), the floor below with its numbers, one signature and quiet elsewhere, and the defaults to stay off: the look any similar product would get, named for this one. `/design` is typed by the user with the brief as its argument, since whether a skill can start it is not yet measured; where it is absent (a research preview, not every client has it), build the same screens as a throwaway HTML tile by hand, two or three ways, under the same brief. Keep the answer in DESIGN.md and delete the tiles; structure that was drawn is not structure that was decided. When nothing at hand settles a fork, offer the hunt **with its price**: real references found live for this domain and audience, each with its source — never the canon every model recalls.

- **The chosen direction is read by a critic before it becomes the language.** The user picks by taste; whether the pick holds the brief is not taste, and the session that watched the user fall for an option is the one that will wave its gaps through. Spawn the plugin's `design-critic` agent ([agents/design-critic.md](agents/design-critic.md)) on the chosen artboard or tile, its task message carrying the brief and where the direction lives; it hands back findings with evidence (a missing state, a pair under the floor with its computed ratio, a second place spending boldness, a default the brief named) and never a preference. Verify each finding yourself; fix what fails in the next `/design` round or the tile, and show the user what changed. The critic judges the brief, never the user's choice.

- **Accessibility is the floor, not a delta.** Contrast at WCAG AA — 4.5:1 for body, 3:1 for large text and control boundaries — **computed from the token values, never eyeballed**; visible focus on every interactive element; touch targets of 44px or more where fingers are the pointer; `prefers-reduced-motion` honored by every motion token; semantic structure before ARIA. Not asked about and not traded against a delta: a palette that fails contrast is adjusted until it passes, the adjustment shown in the tile.

- **Boldness is spent in one place, and the quiet elsewhere is measured.** The language names its **signature** — the one element a screen is remembered by — and keeps everything around it quiet by rule: at most one accent per screen, one display face and one text face, a motion budget in milliseconds. A language where everything is bold has no signature.

- **Tokens are the contract, and they carry roles, not just values.** `color.surface`, `color.text.muted`, `color.accent` bind screens; `#F4F1EA` binds nothing. Type is a scale with a stated ratio and a role per step; spacing a scale on one base; radius, elevation, duration and easing named the same way. Dark mode is decided here — a second value per role, or a deliberate "light only" — because a theme that arrives by drift arrives with half its contrast ratios unmeasured.

- **Commit one language to `DESIGN.md`.** The recorded language is auditable: a later review holds a UI diff against it and asks three questions — does it use the roles, does it spend boldness where the signature says, do its states exist. A "no" to any is a finding, not a taste. Craft is the floor whatever the direction; the user buys down from professional, never up to it.

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

The study — the base named, the brief, the forks the artboards or tiles put and what the user saw that settled each, the critic's findings and what fixed them, the references hunted — is a log entry under `## designer` where the work has a work file (`genius-file` skill), and the snapshot keeps a section pointing at `DESIGN.md`, because a handoff that never mentions the design sends the next session to redo it. One language per product: a recorded `DESIGN.md` is consumed, not redone — later screens speak it, a screen that wants to break it is a conversation, not a drift, and an incoming template's own design file is a base input, never a second language. It is binding: rewritten in place when a fight overturns a rule (`errata` skill).

## How it runs

1. Ask audience and context, in one exchange. Read what already binds: an existing `DESIGN.md`, a brand guide, the surfaces that ship today.
2. Name the base with the user — file, impression, or none — and ask where they have opinions, plus the one open door.
3. Where a fork is open, write the brief and hand it to the user to run as `/design <brief>`; where `/design` is absent, build the tile by hand under the same brief. A delta-zero base skips to 4 with its own tokens on the screen.
4. Look together; the user picks by what they see. Hunt live references, price stated, only for what nothing at hand settles.
5. Spawn the `design-critic` on the chosen direction; verify its findings, fix what fails, show the user the change.
6. Write `DESIGN.md` — tokens with roles, the signature, the floor with its numbers — and the log entry where there is a work, and delete the tiles.

The committed language is the deliverable; what happens next is the user's to type. Done when the user has chosen by looking at real states, the critic's findings are fixed or answered, every token has a role, every text/surface pair has a computed ratio at or above the floor, and the signature is one place.
