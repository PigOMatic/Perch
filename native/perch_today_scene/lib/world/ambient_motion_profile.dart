import 'package:flutter/foundation.dart';

import 'perch_world_state.dart';

/// A single motion contract for the living desk.
///
/// Ambient objects should feel like they share one room rather than each
/// running an unrelated animation. This profile translates world conditions
/// into restrained, normalized strengths and provides a reduced-motion mode
/// that preserves meaning without continuous movement.
@immutable
class AmbientMotionProfile {
  const AmbientMotionProfile({
    required this.weather,
    required this.plantSway,
    required this.steamDrift,
    required this.lanternPulse,
    required this.continuousMotionEnabled,
  });

  factory AmbientMotionProfile.fromWorldState(
    PerchWorldState worldState, {
    bool reduceMotion = false,
  }) {
    if (reduceMotion) {
      return AmbientMotionProfile(
        weather: worldState.hasWeatherMotion ? 0.08 : 0,
        plantSway: 0,
        steamDrift: worldState.shouldSteamCoffee ? 0.12 : 0,
        lanternPulse: worldState.shouldAutoIlluminateLantern ? 0.08 : 0,
        continuousMotionEnabled: false,
      );
    }

    final weather = worldState.weatherMotionIntensity;
    final plantSway = switch (worldState.weather) {
      PerchWeather.clear => 0.08,
      PerchWeather.fog => 0.05,
      PerchWeather.snow => 0.10,
      PerchWeather.rain => 0.18,
      PerchWeather.wind => 0.42,
    };

    final steamDrift = worldState.shouldSteamCoffee
        ? switch (worldState.weather) {
            PerchWeather.wind => 0.48,
            PerchWeather.rain => 0.34,
            PerchWeather.snow => 0.22,
            PerchWeather.fog => 0.16,
            PerchWeather.clear => 0.20,
          }
        : 0.0;

    final lanternPulse = worldState.shouldAutoIlluminateLantern ? 0.18 : 0.0;

    return AmbientMotionProfile(
      weather: weather,
      plantSway: plantSway,
      steamDrift: steamDrift,
      lanternPulse: lanternPulse,
      continuousMotionEnabled: true,
    );
  }

  /// Strength of visible weather movement, from still to pronounced.
  final double weather;

  /// Strength of plant movement. Even clear rooms retain barely perceptible
  /// life, while wind remains noticeably stronger than rain or snow.
  final double plantSway;

  /// Horizontal and vertical looseness of coffee steam.
  final double steamDrift;

  /// Subtle breathing of lantern light. This should never read as flashing.
  final double lanternPulse;

  /// False when the platform requests reduced motion.
  final bool continuousMotionEnabled;
}
