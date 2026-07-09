# ADR 005: Perch Becomes a World-First Native App Experience

## Status

Accepted direction.

## Context

Perch began with dashboard and web demo explorations. Those explorations clarified the emotional target but also revealed a repeated failure mode: HTML layouts naturally drift toward cards, sections, headers, and dashboards.

The strongest Perch direction is not a dashboard.

Perch should feel like a calm place the user returns to. The world is grounded in nature. The user's life tools appear as physical objects in that world.

The name `Perch` supports this. A perch is a safe place to land, rest, look over the world, and decide what matters next.

## Decision

Perch Today and future primary experiences should move toward a native, scene-based app experience.

The preferred implementation path is Flutter with:

- realistic full-screen scenes
- live UI layered onto physical objects
- subtle animation
- optional ambience
- iPhone and Android support
- future widgets
- offline scene packs
- Perch integration later

HTML mockups may remain useful for fast exploration, but they are not the primary product direction.

## Product Model

The user does not change themes.

The user builds and returns to a sanctuary.

The user's world expands through trails and places:

- Home Perch
- Creek
- Cabin
- Firepit
- Barn / Workshop
- RV Campsite
- Dock
- Rainy Window
- Nurse Break Room

Each place is a chapter, context, or priority area in the user's life.

## Information Model

Information lives on objects:

- calendar = notebook/planner
- tasks = clipboard/checklist
- money = envelope/ledger
- reminders = sticky note
- weather = window/outdoor scene
- Brain = journal
- shifts = tickets or badge cards

## Consequences

This decision changes the next build path.

Priority should move from polishing web demos to:

1. World Bible
2. Art Bible
3. Flutter scene engine
4. Asset pipeline
5. One excellent native scene prototype

## Guardrails

1. Do not rebuild Perch as a standard dashboard app.
2. Do not make scenes feel like cosmetic themes.
3. Do not lock core utility behind progression.
4. Do not bake live data into images.
5. Do not over-gamify the sanctuary.
6. Do not build ten scenes before one scene is excellent.

## Success Test

A user should be able to open Perch and say:

> I feel like I returned to a place where my life is organized and I can breathe.
