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
