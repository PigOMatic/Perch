# Perch Today Scene Prototype

This is the first native Flutter prototype for the Perch world-first scene experience.

## Goal

Prove one scene before building many.

The app opens into **Home Perch**, a cabin-desk style sanctuary where useful life information appears on physical-feeling objects instead of dashboard cards.

## Current Prototype

The first pass is intentionally asset-light. It uses Flutter shapes, gradients, shadows, and live text overlays to establish the object system before final AI-generated/illustrated assets are added.

Objects included:

- Notebook for the daily run sheet
- Cash envelope with money sticking out
- Sticky note for one Brain item
- Shift tickets
- Calendar stub
- Coffee mug, pen, and desk props

## Demo Data

The current prototype uses hardcoded demo data:

- `Sun 5 · Off`
- `Reset day.`
- `Bronze mortgage · Jul 8`
- `$800 available`
- `Safe through Jul 12 payday`
- `Check if payment pulled`
- ICU shift tickets

## Run Locally

From this directory:

```bash
flutter pub get
flutter run
```

## Next Build Steps

1. Replace shape-generated props with actual scene/object assets.
2. Add subtle animation: steam, light movement, envelope open, sticky lift.
3. Add responsive layouts for smaller phones.
4. Add a trail-map scene switcher.
5. Connect to real Perch data after the scene experience feels right.

## Product Rule

Do not turn this into a dashboard.

The scene is the interface.
