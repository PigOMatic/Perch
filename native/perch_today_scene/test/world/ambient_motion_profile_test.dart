import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/world/ambient_motion_profile.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';

void main() {
  PerchWorldState world({
    PerchSeason season = PerchSeason.summer,
    PerchWeather weather = PerchWeather.clear,
    PerchTimeOfDay timeOfDay = PerchTimeOfDay.midday,
    PerchLifeContext lifeContext = PerchLifeContext.home,
  }) {
    return PerchWorldState(
      season: season,
      weather: weather,
      timeOfDay: timeOfDay,
      lifeContext: lifeContext,
      currentLocationId: 'home_perch',
      unlockedLocationIds: const ['home_perch'],
      ambientSoundEnabled: false,
      welcomeBackMode: false,
    );
  }

  test('wind drives the strongest plant and steam movement', () {
    final rain = AmbientMotionProfile.fromWorldState(
      world(weather: PerchWeather.rain),
    );
    final wind = AmbientMotionProfile.fromWorldState(
      world(
        weather: PerchWeather.wind,
        timeOfDay: PerchTimeOfDay.evening,
      ),
    );

    expect(wind.weather, greaterThan(rain.weather));
    expect(wind.plantSway, greaterThan(rain.plantSway));
    expect(wind.steamDrift, greaterThan(rain.steamDrift));
  });

  test('clear summer midday keeps coffee still and plant nearly still', () {
    final profile = AmbientMotionProfile.fromWorldState(world());

    expect(profile.weather, 0);
    expect(profile.steamDrift, 0);
    expect(profile.plantSway, lessThan(0.1));
    expect(profile.lanternPulse, 0);
    expect(profile.continuousMotionEnabled, isTrue);
  });

  test('dark weather evening gives the lantern a restrained pulse', () {
    final profile = AmbientMotionProfile.fromWorldState(
      world(
        weather: PerchWeather.fog,
        timeOfDay: PerchTimeOfDay.evening,
      ),
    );

    expect(profile.lanternPulse, greaterThan(0));
    expect(profile.lanternPulse, lessThan(0.25));
  });

  test('reduced motion disables continuous decorative movement', () {
    final profile = AmbientMotionProfile.fromWorldState(
      world(
        weather: PerchWeather.wind,
        timeOfDay: PerchTimeOfDay.night,
      ),
      reduceMotion: true,
    );

    expect(profile.continuousMotionEnabled, isFalse);
    expect(profile.plantSway, 0);
    expect(profile.weather, lessThanOrEqualTo(0.08));
    expect(profile.steamDrift, lessThanOrEqualTo(0.12));
    expect(profile.lanternPulse, lessThanOrEqualTo(0.08));
  });
}
