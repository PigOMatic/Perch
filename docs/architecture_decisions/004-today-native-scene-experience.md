# ADR 004: Today Becomes a Native Scene Experience

## Status

Accepted direction for the next Perch Today build path.

## Context

The recent HTML Today demos were useful for discovering the emotional target, but they kept pulling the experience back toward web-page layout patterns: cards, panels, sections, large headings, and dashboard thinking.

That is not the desired product direction.

Perch Today is not a dashboard. It is a one-minute relief experience.

The emotional target remains:

> I know what matters.  
> I know what is safe.  
> I know what is coming.  
> I know what can wait.  
> I can breathe.

The strongest direction is a native app experience where the user opens Perch and feels like they are sitting somewhere real.

Examples:

- Cabin table
- Firepit
- Creek
- Barn porch
- RV campsite
- Desk
- Dock
- Rainy window
- Hospital break room

Life tools appear as objects in that place:

- Calendar = notebook on table
- Tasks = clipboard
- Money = envelope or ledger
- Reminders = sticky note
- Weather = outside window
- Perch Brain = journal

## Decision

Stop treating HTML mockups as the primary build path for Today.

The next serious Today experience should be built as a native app prototype, likely in Flutter, with AI-generated image assets, layered live UI, subtle animation, and eventual support for mobile platforms.

The app should feel like:

> You open Perch and you are sitting somewhere. Your life is already organized in front of you.

It should not feel like:

> A web page with buttons on it.

## Why Flutter

Flutter is the preferred candidate for this experience because it supports:

- iPhone and Android builds from one codebase
- Full-screen visual scenes
- Layered UI over image assets
- Smooth animation and transitions
- Offline bundled scene packs
- Future widget paths
- Future integration with Perch data models
- Audio ambience such as fire, creek, rain, wind, and room tone

## Experience Model

The scene is the interface.

A Today scene is composed of:

1. A full-screen realistic environment.
2. Physical objects inside that environment.
3. Live Perch data layered onto those objects.
4. Small, useful interactions that feel natural to the object.

Example object mapping:

| Life function | Scene object |
| --- | --- |
| Calendar | Notebook, wall calendar, planner page |
| Tasks | Clipboard, checklist, index card |
| Money | Cash envelope, ledger, receipt stack |
| Reminders | Sticky note, pinned card |
| Weather | Window, porch view, dock view |
| Perch Brain | Journal, field notebook, voice note card |
| Work shifts | Tickets, slips, badge cards |

## First Native Prototype Goal

Build one scene only:

**Desk / cabin table scene**

Required objects:

- Notebook with live Today summary
- Cash envelope with money sticking out
- Three shift tickets
- One sticky note
- Scene ambience placeholder hook
- Subtle parallax or breathing motion

Required live content:

- Today status: `Sun 5 · Off`
- Reset message: `Reset day.`
- Next due: `Bronze mortgage · Jul 8`
- CTA: `Check payment`
- Money: `$800 available`
- Safe-through/payday context
- Shift tickets: `Mon 6`, `Mon 13`, `Tue 14`
- Brain note: `Check if payment pulled`

## Rules

1. Do not make the native scene feel like a dashboard.
2. Do not use big app-section cards as the primary metaphor.
3. Do not make the word `Today` the visual hero.
4. Do not bake user data into scene images.
5. Scene images are visual assets; Perch information remains live UI layered on top.
6. Every visible object should have a reason to exist.
7. The first open should create relief before explanation.

## Consequences

HTML demos may still be used for quick exploration, but they are no longer the primary target for Today.

Future work should prioritize:

- Native Flutter prototype structure
- Scene asset pipeline
- Object/data mapping
- Animation and ambience model
- Perch data integration points

The current web demo can remain as a design artifact, but the product direction is native, scene-based, and emotionally grounded.
