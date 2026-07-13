enum PerchSeason {
  spring,
  summer,
  fall,
  winter,
}

enum PerchWeather {
  clear,
  rain,
  fog,
  snow,
  wind,
}

enum PerchTimeOfDay {
  morning,
  midday,
  evening,
  night,
}

enum PerchLifeContext {
  home,
  work,
  travel,
  recovery,
  planning,
}

class PerchWorldState {
  const PerchWorldState({
    required this.season,
    required this.weather,
    required this.timeOfDay,
    required this.lifeContext,
    required this.currentLocationId,
    required this.unlockedLocationIds,
    required this.ambientSoundEnabled,
    required this.welcomeBackMode,
  });

  final PerchSeason season;
  final PerchWeather weather;
  final PerchTimeOfDay timeOfDay;
  final PerchLifeContext lifeContext;
  final String currentLocationId;
  final List<String> unlockedLocationIds;
  final bool ambientSoundEnabled;
  final bool welcomeBackMode;

  bool get isNight => timeOfDay == PerchTimeOfDay.night;
  bool get isWorkContext => lifeContext == PerchLifeContext.work;
  bool get hasWeatherMotion => weather != PerchWeather.clear;

  /// Normalized strength for visual weather motion.
  ///
  /// Fog and snow should remain restful, rain can be more present, and wind is
  /// the strongest condition. Clear weather intentionally produces no motion.
  double get weatherMotionIntensity {
    switch (weather) {
      case PerchWeather.clear:
        return 0;
      case PerchWeather.fog:
        return 0.22;
      case PerchWeather.snow:
        return 0.34;
      case PerchWeather.rain:
        return 0.62;
      case PerchWeather.wind:
        return 0.82;
    }
  }

  /// Coffee steam is environmental, not a permanent looping decoration.
  ///
  /// It is most believable during cooler or restorative moments and should
  /// settle during hot, active midday scenes. A manual brain-state switch can
  /// still disable steam entirely before this policy is applied by the scene.
  bool get shouldSteamCoffee {
    if (weather == PerchWeather.snow ||
        weather == PerchWeather.rain ||
        weather == PerchWeather.fog) {
      return true;
    }
    if (season == PerchSeason.winter || season == PerchSeason.fall) return true;
    if (lifeContext == PerchLifeContext.recovery) return true;
    return timeOfDay == PerchTimeOfDay.morning ||
        timeOfDay == PerchTimeOfDay.evening;
  }

  /// The lantern is part of the room rather than a dashboard control.
  /// It should quietly come alive when the room would naturally need warmth.
  bool get shouldAutoIlluminateLantern {
    if (timeOfDay == PerchTimeOfDay.night) return true;
    if (timeOfDay != PerchTimeOfDay.evening) return false;
    return weather == PerchWeather.rain ||
        weather == PerchWeather.fog ||
        weather == PerchWeather.snow ||
        weather == PerchWeather.wind;
  }

  String get welcomeLine {
    if (welcomeBackMode) return "Welcome back. Let's get your footing again.";
    return 'Your place is ready.';
  }

  String get ambientLabel {
    if (!ambientSoundEnabled) return 'Ambience off';
    switch (weather) {
      case PerchWeather.rain:
        return 'Rain ambience';
      case PerchWeather.fog:
        return 'Soft fog ambience';
      case PerchWeather.snow:
        return 'Quiet snow ambience';
      case PerchWeather.wind:
        return 'Wind ambience';
      case PerchWeather.clear:
        return isNight ? 'Night room tone' : 'Birds and room tone';
    }
  }
}

const demoWorldState = PerchWorldState(
  season: PerchSeason.summer,
  weather: PerchWeather.clear,
  timeOfDay: PerchTimeOfDay.morning,
  lifeContext: PerchLifeContext.home,
  currentLocationId: 'home_perch',
  unlockedLocationIds: [
    'home_perch',
    'creek',
    'firepit',
  ],
  ambientSoundEnabled: false,
  welcomeBackMode: false,
);
