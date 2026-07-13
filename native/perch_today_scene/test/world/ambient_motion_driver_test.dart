import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/world/ambient_motion_driver.dart';
import 'package:perch_today_scene/world/ambient_motion_profile.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';

void main() {
  const clearMorning = PerchWorldState(
    season: PerchSeason.summer,
    weather: PerchWeather.clear,
    timeOfDay: PerchTimeOfDay.morning,
    lifeContext: PerchLifeContext.home,
    currentLocationId: 'home_perch',
    unlockedLocationIds: ['home_perch'],
    ambientSoundEnabled: false,
    welcomeBackMode: false,
  );

  const clearMidday = PerchWorldState(
    season: PerchSeason.summer,
    weather: PerchWeather.clear,
    timeOfDay: PerchTimeOfDay.midday,
    lifeContext: PerchLifeContext.home,
    currentLocationId: 'home_perch',
    unlockedLocationIds: ['home_perch'],
    ambientSoundEnabled: false,
    welcomeBackMode: false,
  );

  testWidgets('reduced motion holds calm deterministic frames', (tester) async {
    AmbientMotionFrame? frame;
    final profile = AmbientMotionProfile.fromWorldState(
      clearMorning,
      reduceMotion: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AmbientMotionDriver(
          profile: profile,
          builder: (context, value) {
            frame = value;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(frame, isNotNull);
    expect(frame!.plant.value, .5);
    expect(frame!.steam.value, 0);
    expect(frame!.lantern.value, .5);

    await tester.pump(const Duration(seconds: 2));

    expect(frame!.plant.value, .5);
    expect(frame!.steam.value, 0);
    expect(frame!.lantern.value, .5);
  });

  testWidgets('weather timing advances active plant and steam clocks', (
    tester,
  ) async {
    AmbientMotionFrame? frame;
    final profile = AmbientMotionProfile.fromWorldState(clearMorning);

    await tester.pumpWidget(
      MaterialApp(
        home: AmbientMotionDriver(
          profile: profile,
          builder: (context, value) {
            frame = value;
            return const SizedBox();
          },
        ),
      ),
    );

    final initialPlant = frame!.plant.value;
    final initialSteam = frame!.steam.value;

    await tester.pump(const Duration(milliseconds: 700));

    expect(frame!.plant.value, isNot(initialPlant));
    expect(frame!.steam.value, isNot(initialSteam));
    expect(frame!.lantern.value, .5);
  });

  testWidgets('backgrounding pauses motion and resuming restarts it', (
    tester,
  ) async {
    AmbientMotionFrame? frame;

    await tester.pumpWidget(
      MaterialApp(
        home: AmbientMotionDriver(
          profile: AmbientMotionProfile.fromWorldState(clearMorning),
          builder: (context, value) {
            frame = value;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    final pausedPlant = frame!.plant.value;
    final pausedSteam = frame!.steam.value;

    await tester.pump(const Duration(milliseconds: 700));

    expect(frame!.plant.value, pausedPlant);
    expect(frame!.steam.value, pausedSteam);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(frame!.plant.value, isNot(pausedPlant));
    expect(frame!.steam.value, isNot(pausedSteam));
  });

  testWidgets('same-weather context changes start and stop steam', (
    tester,
  ) async {
    AmbientMotionFrame? frame;

    Widget build(PerchWorldState worldState) {
      return MaterialApp(
        home: AmbientMotionDriver(
          profile: AmbientMotionProfile.fromWorldState(worldState),
          builder: (context, value) {
            frame = value;
            return const SizedBox();
          },
        ),
      );
    }

    await tester.pumpWidget(build(clearMidday));
    await tester.pump(const Duration(milliseconds: 500));
    expect(frame!.steam.value, 0);

    await tester.pumpWidget(build(clearMorning));
    await tester.pump(const Duration(milliseconds: 500));
    expect(frame!.steam.value, greaterThan(0));

    await tester.pumpWidget(build(clearMidday));
    await tester.pump(const Duration(milliseconds: 500));
    expect(frame!.steam.value, 0);
  });
}
