# Native Scene App Roadmap

## Objective

Move Perch from web mockups toward a native scene-based app experience.

The goal is not to build a generic productivity app. The goal is to build a calm personal sanctuary where life information appears naturally on objects inside meaningful scenes.

## Phase 0: Foundation Lock

Status: in progress.

Deliverables:

- World Bible
- Art Bible
- Native Flutter architecture
- Asset pipeline
- Initial roadmap

Success criteria:

- Project direction is clear.
- Future work does not drift back into dashboard-first HTML mockups.
- AI assistants and human contributors share the same visual/emotional target.

## Phase 1: Flutter Scaffold

Create:

```text
native/perch_today_scene/
```

Minimum deliverables:

- Flutter app boots on mobile/web target if possible
- one screen shell
- local demo data model
- scene renderer placeholder
- no backend dependency

Success criteria:

- App opens to a full-screen scene shell.
- The code structure supports scene/object separation.

## Phase 2: Home Perch Scene Prototype

Build one scene only.

Scene:

- Home Perch / Cabin Desk

Objects:

- notebook
- money envelope with cash sticking out
- sticky note
- three shift tickets
- coffee mug
- pen

Live demo data:

- Sun 5 · Off
- Reset day.
- Bronze mortgage · Jul 8
- Check payment
- $800 available
- Safe through Jul 12 payday
- Mon 6 ICU 7p
- Mon 13 ICU 7p
- Tue 14 ICU 7p
- Check if payment pulled

Success criteria:

- The experience does not feel like a dashboard.
- The user sees the envelope money clearly.
- The notebook feels like the daily run sheet.
- The sticky note is one clear brain item.
- The shift tickets feel physical, not like cards.

## Phase 3: Object Interactions

Add first interactions:

- tap notebook: expand daily run sheet
- tap envelope: money detail opens naturally
- tap sticky note: brain item detail/capture
- tap shift ticket: schedule detail

Success criteria:

- Interactions feel like using the object.
- No generic panels unless absolutely necessary.

## Phase 4: Motion and Ambience

Add subtle motion:

- light movement
- coffee steam
- paper settle
- envelope open
- sticky lift
- optional audio hooks

Success criteria:

- Motion calms the user.
- Motion does not distract from life information.

## Phase 5: Trail Map Navigation

Create world navigation using a trail map instead of a theme picker.

Initial nodes:

- Home Perch
- Creek
- Firepit
- Barn / Workshop
- RV Campsite
- Break Room

Success criteria:

- Scene switching feels like traveling through the user's sanctuary.
- The app avoids the feeling of a settings theme selector.

## Phase 6: Second Scene

Build one additional scene after Home Perch is strong.

Recommended second scene:

- Creek for reflection and Brain review

Success criteria:

- The same data/object system can adapt to a lower-information scene.
- The world feels larger without feeling cluttered.

## Phase 7: Perch Integration

Connect live Perch data gradually.

Priority data:

1. Today status
2. calendar/work shifts
3. bills and money safety
4. Brain notes
5. weather/time of day
6. recurring routines

Success criteria:

- Live data changes object text without changing assets.
- Perch remains useful offline where possible.

## Phase 8: Packaging

Prepare for actual device use.

Deliverables:

- mobile build path
- performance pass
- asset compression
- accessibility review
- privacy/data review
- scene pack structure

## Build Principle

Do not build ten mediocre scenes.

Build one scene that makes people say:

> I have never seen a life app like this.
