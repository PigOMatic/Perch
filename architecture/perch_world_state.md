# Perch World State

## Purpose

Perch is not a static set of screens. It is a persistent world that should respond to the user's current life context.

The world state is the first technical model for that idea.

## World State Fields

Initial fields:

- season
- weather
- time of day
- life context
- current location
- unlocked locations
- ambient sound enabled
- welcome back mode

## Why It Matters

Scenes should not be isolated themes.

The same Home Perch scene can feel different based on:

- morning vs night
- clear vs rainy weather
- home vs work context
- new day vs welcome-back recovery mode

## Example

If the user comes back after weeks away, Perch should not punish them.

Instead of showing missed tasks, world state can trigger a welcome-back mode:

> Welcome back. Let's get your footing again.

## Implementation Status

The Flutter prototype now includes:

- `PerchWorldState`
- demo world state
- scene renderer world-state passthrough
- Home Perch background responding to time/weather/season
- a world status pill for welcome/ambience feedback

## Future Fields

Possible future world state fields:

- active trip
- next work shift context
- household mode
- holiday/seasonal decoration state
- preferred scene
- user energy level
- privacy mode
- family/shared mode
- asset pack version

## Rule

World state should make Perch feel more alive and more supportive.

It must not become another dashboard of settings.
