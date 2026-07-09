import 'package:flutter/widgets.dart';

/// Central performance choices for the Perch scene engine.
///
/// Milestone 0 should feel premium, but it also has to run well on phones.
/// These constants keep animation subtle, bounded, and cheap.
class PerchPerformance {
  const PerchPerformance._();

  static const Duration ambientLoopDuration = Duration(seconds: 12);
  static const Duration objectFocusDuration = Duration(milliseconds: 220);

  /// Target a quiet ambient effect instead of constant heavy animation.
  static const double maxLightDrift = 0.08;
  static const double maxParallaxOffset = 10;

  /// Keep blur low. Large real-time blurs are expensive on phones.
  static const double softShadowBlur = 24;
  static const double deepShadowBlur = 36;

  /// Wrap expensive scene groups in repaint boundaries so steam/light updates
  /// do not force static objects to repaint unnecessarily.
  static Widget isolateStaticLayer(Widget child) => RepaintBoundary(child: child);
  static Widget isolateAnimatedLayer(Widget child) => RepaintBoundary(child: child);
}
