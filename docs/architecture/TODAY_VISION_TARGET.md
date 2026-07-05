# Today Vision Target

**Status:** Direction correction  
**Created:** July 5, 2026

---

## Current assessment

The rebuilt Today preview is a step forward, but it is not yet the Perch vision.

It proves the architecture path works:

- clean shell
- rebuilt renderer
- read-only storage input
- visible source indicator
- debug drawer

But visually and emotionally it still feels too much like a cleaned-up dashboard.

That is not the target.

---

## Product truth

Perch Today should not feel like an admin panel.

It should not feel like a finance dashboard, task manager, CRM, calendar app, or settings screen.

Perch Today should feel like a calm personal operating surface that quietly answers:

```text
Am I okay?
What matters today?
What should I not forget?
What can wait?
Why does Perch think that?
```

---

## What is wrong with the current preview

The current preview is better than legacy, but still too generic.

Problems:

- Too card-grid driven
- Too evenly weighted
- Too much visible system scaffolding
- Too little emotional hierarchy
- Too little personal language
- The hero is not yet meaningful enough
- The data source/debug pieces are useful but visually too close to the main product surface
- It still reads like a dashboard, not a trusted daily briefing

---

## Target feeling

The new Today page should feel:

- calm
- spacious
- human
- personal
- quietly intelligent
- low-pressure
- confidence-building
- less like software
- more like a daily clearing ritual

---

## Target structure

Today should have one dominant answer first.

Suggested hierarchy:

```text
1. Opening sentence
2. Today's actual state
3. One thing that needs attention, if any
4. Money / schedule / brain context only as supporting evidence
5. Trust/source notes tucked away
6. Debug tools hidden from product surface
```

---

## Visual direction

Move away from:

```text
card grid
admin dashboard
three equal columns
developer preview feel
all sections visually equal
```

Move toward:

```text
one calm daily brief
large readable statement
single primary action/attention item
supporting context as quiet evidence
soft source/trust disclosure
minimal controls
```

---

## Design rule

If everything looks equally important, the design failed.

Today should make one thing obvious.

---

## Implementation implication

Do not keep expanding the current card grid as the final form.

The current preview may remain as a technical proof, but the next visual iteration should introduce a new Today layout mode, likely:

```text
Today Brief View
```

This should be developed beside the current renderer before replacing it.

---

## Next build target

Create a second Today visual prototype:

```text
src/ui/todayBriefView.js
```

It should consume the same Today PageState but render a more opinionated daily brief experience.

The current `todayView.js` can remain as the structural/debug preview until the brief view is good enough to become the default.
