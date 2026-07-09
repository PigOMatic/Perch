# Native Flutter Scene Engine Architecture

## Purpose

This document defines the first technical direction for turning Perch Today into a native scene-based app experience.

The HTML demos are useful artifacts, but the product direction is a native app experience where the scene is the interface and Perch data is layered onto physical-feeling objects.

## Recommended Stack

- Flutter for iOS and Android
- Local-first demo data for first prototype
- Asset-based scene composition
- Layered live UI over images
- Subtle animation controllers
- Optional ambient audio layer

## Core Concepts

### Scene

A full-screen place the user returns to.

Examples:

- Home Perch / Cabin Desk
- Creek
- Firepit
- RV Campsite
- Break Room

A scene owns:

- background layers
- object placements
- ambience
- animation profile
- available tools
- live data bindings

### Scene Object

A physical-feeling object that displays or controls Perch data.

Examples:

- notebook
- envelope
- sticky note
- shift ticket
- journal
- clipboard
- map

Each object defines:

- asset references
- position rules
- responsive scaling
- live text areas
- tap behavior
- animation behavior

### Data Binding

Perch information remains live and layered. It is not baked into images.

Example:

```text
Money envelope image
  └── live amount text
  └── safe-through text
  └── tap to open details
```

## Suggested Flutter Folder Structure

```text
native/perch_today_scene/
  pubspec.yaml
  lib/
    main.dart
    app.dart
    data/
      demo_today_data.dart
      perch_today_models.dart
    scene_engine/
      scene_definition.dart
      scene_layer.dart
      scene_object.dart
      scene_renderer.dart
      responsive_scene_layout.dart
    scenes/
      home_perch/
        home_perch_scene.dart
        home_perch_objects.dart
      creek/
      firepit/
    objects/
      notebook_object.dart
      money_envelope_object.dart
      sticky_note_object.dart
      shift_ticket_object.dart
      journal_object.dart
    animation/
      ambient_motion.dart
      parallax_controller.dart
    audio/
      ambience_controller.dart
    theme/
      perch_typography.dart
      perch_motion.dart
  assets/
    scenes/
    objects/
    audio/
```

## First Prototype Scope

Build only one scene first.

### Scene: Home Perch / Cabin Desk

Required visual layers:

- background wood/cabin table
- notebook
- money envelope with cash sticking out
- sticky note
- three shift tickets
- coffee mug
- pen
- light/shadow overlay

Required live data:

- day/status: `Sun 5 · Off`
- reset note: `Reset day.`
- next due: `Bronze mortgage · Jul 8`
- action: `Check payment`
- money: `$800 available`
- context: `Safe through Jul 12 payday`
- shifts: `Mon 6`, `Mon 13`, `Tue 14`
- brain note: `Check if payment pulled`

## Scene Definition Sketch

```dart
class PerchSceneDefinition {
  final String id;
  final String name;
  final List<SceneLayer> layers;
  final List<SceneObjectDefinition> objects;
  final AmbienceProfile ambience;
  final MotionProfile motion;
}
```

## Object Definition Sketch

```dart
class SceneObjectDefinition {
  final String id;
  final String assetPath;
  final Rect Function(Size screen) layout;
  final Widget Function(BuildContext context, PerchTodayData data) overlay;
  final VoidCallback? onTap;
}
```

## Rendering Rule

All scenes should render from back to front:

1. environment background
2. surface/table layer
3. shadow/light layer
4. physical objects
5. live data overlays
6. ambient foreground effects
7. minimal system navigation

## Data Rule

The first prototype should use hardcoded demo data, not backend integration.

Reason: the scene engine must prove the experience before data complexity enters.

## Interaction Rules

- Tapping notebook expands the day plan.
- Tapping envelope opens money detail.
- Tapping sticky opens Brain capture/detail.
- Tapping shift ticket opens calendar context.
- Tapping map/trail changes scenes.

No object should open a generic dashboard panel unless absolutely necessary.

## Animation Rules

First prototype animations:

- very slight parallax on device tilt or touch drag
- coffee steam loop
- soft light movement
- envelope open/close
- sticky note lift/settle

## Audio Rules

Audio is optional and off by default unless the user enables ambience.

The engine should support ambient loops later but should not require audio for usability.

## Technical Priorities

1. Prove one beautiful scene.
2. Keep data overlays live.
3. Keep object mapping reusable.
4. Avoid overbuilding navigation.
5. Avoid building ten mediocre scenes.
6. Build one scene that makes people understand Perch immediately.
