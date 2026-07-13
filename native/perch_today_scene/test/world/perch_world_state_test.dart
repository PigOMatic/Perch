import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';

PerchWorldState world({
  PerchSeason season = PerchSeason.summer,
  PerchWeather weather = PerchWeather.clear,
  PerchTimeOfDay timeOfDay = PerchTimeOfDay.morning,
  PerchLifeContext lifeContext = PerchLifeContext.home,
  bool ambientSoundEnabled = true,
  bool welcomeBackMode = false,
}) {
  return PerchWorldState(
    season: season,
    weather: weather,
    timeOfDay: timeOfDay,
    lifeContext: lifeContext,
    currentLocationId: 'home_perch',
    unlockedLocationIds: const ['home_perch'],
    ambientSoundEnabled: ambientSoundEnabled,
    welcomeBackMode: welcomeBackMode,
  );
}

void main() {
  group('PerchWorldState', () {
    test('clear weather has no motion and changes room tone at night', () {
      final morning = world();
      final night = world(timeOfDay: PerchTimeOfDay.night);

      expect(morning.hasWeatherMotion, isFalse);
      expect(morning.weatherMotionIntensity, 0);
      expect(morning.isNight, isFalse);
      expect(morning.ambientLabel, 'Birds and room tone');
      expect(night.isNight, isTrue);
      expect(night.ambientLabel, 'Night room tone');
    });

    test('weather motion intensity remains calm and ordered', () {
      final fog = world(weather: PerchWeather.fog).weatherMotionIntensity;
      final snow = world(weather: PerchWeather.snow).weatherMotionIntensity;
      final rain = world(weather: PerchWeather.rain).weatherMotionIntensity;
      final wind = world(weather: PerchWeather.wind).weatherMotionIntensity;

      expect(fog, greaterThan(0));
      expect(snow, greaterThan(fog));
      expect(rain, greaterThan(snow));
      expect(wind, greaterThan(rain));
      expect(wind, lessThanOrEqualTo(1));
    });

    test('coffee steam follows believable weather, season, and context', () {
      expect(world().shouldSteamCoffee, isTrue);
      expect(
        world(timeOfDay: PerchTimeOfDay.midday).shouldSteamCoffee,
        isFalse,
      );
      expect(
        world(
          timeOfDay: PerchTimeOfDay.midday,
          weather: PerchWeather.rain,
        ).shouldSteamCoffee,
        isTrue,
      );
      expect(
        world(
          season: PerchSeason.winter,
          timeOfDay: PerchTimeOfDay.midday,
        ).shouldSteamCoffee,
        isTrue,
      );
      expect(
        world(
          timeOfDay: PerchTimeOfDay.midday,
          lifeContext: PerchLifeContext.recovery,
        ).shouldSteamCoffee,
        isTrue,
      );
    });

    test('lantern automatically illuminates for night and dark evenings', () {
      expect(
        world(timeOfDay: PerchTimeOfDay.night).shouldAutoIlluminateLantern,
        isTrue,
      );
      expect(
        world(
          timeOfDay: PerchTimeOfDay.evening,
          weather: PerchWeather.rain,
        ).shouldAutoIlluminateLantern,
        isTrue,
      );
      expect(
        world(
          timeOfDay: PerchTimeOfDay.evening,
          weather: PerchWeather.fog,
        ).shouldAutoIlluminateLantern,
        isTrue,
      );
      expect(
        world(timeOfDay: PerchTimeOfDay.evening)
            .shouldAutoIlluminateLantern,
        isFalse,
      );
      expect(world().shouldAutoIlluminateLantern, isFalse);
    });

    test('every non-clear weather requests motion and a distinct ambience', () {
      final expected = <PerchWeather, String>{
        PerchWeather.rain: 'Rain ambience',
        PerchWeather.fog: 'Soft fog ambience',
        PerchWeather.snow: 'Quiet snow ambience',
        PerchWeather.wind: 'Wind ambience',
      };

      for (final entry in expected.entries) {
        final state = world(weather: entry.key);
        expect(state.hasWeatherMotion, isTrue, reason: '${entry.key}');
        expect(state.ambientLabel, entry.value, reason: '${entry.key}');
      }
    });

    test('disabled ambience overrides weather-specific labels', () {
      for (final weather in PerchWeather.values) {
        expect(
          world(weather: weather, ambientSoundEnabled: false).ambientLabel,
          'Ambience off',
          reason: '$weather',
        );
      }
    });

    test('work context and welcome-back mode remain independent', () {
      final state = world(
        lifeContext: PerchLifeContext.work,
        welcomeBackMode: true,
      );

      expect(state.isWorkContext, isTrue);
      expect(state.welcomeLine, "Welcome back. Let's get your footing again.");
    });

    test('normal mode uses the stable default welcome line', () {
      expect(world().welcomeLine, 'Your place is ready.');
    });
  });
}
