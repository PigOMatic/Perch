import 'package:flutter/material.dart';

import 'ambient_motion_profile.dart';

@immutable
class AmbientMotionFrame {
  const AmbientMotionFrame({
    required this.plant,
    required this.steam,
    required this.lantern,
  });

  final Animation<double> plant;
  final Animation<double> steam;
  final Animation<double> lantern;
}

typedef AmbientMotionBuilder = Widget Function(
  BuildContext context,
  AmbientMotionFrame frame,
);

/// Owns the living desk's continuous animation clocks.
///
/// The world-state policy remains in [AmbientMotionProfile]. This widget only
/// translates that policy into synchronized, lifecycle-safe animation sources
/// for the plant, coffee steam, and lantern. When reduced motion is requested,
/// all controllers stop on calm deterministic frames instead of continuing to
/// tick at an imperceptible strength.
class AmbientMotionDriver extends StatefulWidget {
  const AmbientMotionDriver({
    super.key,
    required this.profile,
    required this.builder,
  });

  final AmbientMotionProfile profile;
  final AmbientMotionBuilder builder;

  @override
  State<AmbientMotionDriver> createState() => _AmbientMotionDriverState();
}

class _AmbientMotionDriverState extends State<AmbientMotionDriver>
    with TickerProviderStateMixin {
  late final AnimationController _plantController;
  late final AnimationController _steamController;
  late final AnimationController _lanternController;

  @override
  void initState() {
    super.initState();
    _plantController = AnimationController(vsync: this);
    _steamController = AnimationController(vsync: this);
    _lanternController = AnimationController(vsync: this);
    _applyProfile(widget.profile);
  }

  @override
  void didUpdateWidget(covariant AmbientMotionDriver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameControllerPlan(oldWidget.profile, widget.profile)) {
      _applyProfile(widget.profile);
    }
  }

  bool _sameControllerPlan(
    AmbientMotionProfile previous,
    AmbientMotionProfile next,
  ) {
    return previous.continuousMotionEnabled == next.continuousMotionEnabled &&
        previous.plantPeriod == next.plantPeriod &&
        previous.steamPeriod == next.steamPeriod &&
        previous.lanternPeriod == next.lanternPeriod &&
        (previous.steamDrift > 0) == (next.steamDrift > 0) &&
        (previous.lanternPulse > 0) == (next.lanternPulse > 0);
  }

  void _applyProfile(AmbientMotionProfile profile) {
    _configure(
      _plantController,
      period: profile.plantPeriod,
      enabled: profile.continuousMotionEnabled,
      reverse: true,
      restingValue: .5,
    );
    _configure(
      _steamController,
      period: profile.steamPeriod,
      enabled: profile.continuousMotionEnabled && profile.steamDrift > 0,
      restingValue: 0,
    );
    _configure(
      _lanternController,
      period: profile.lanternPeriod,
      enabled: profile.continuousMotionEnabled && profile.lanternPulse > 0,
      reverse: true,
      restingValue: .5,
    );
  }

  void _configure(
    AnimationController controller, {
    required Duration period,
    required bool enabled,
    required double restingValue,
    bool reverse = false,
  }) {
    controller.stop();
    controller.duration = period == Duration.zero ? null : period;

    if (!enabled || period == Duration.zero) {
      controller.value = restingValue;
      return;
    }

    controller.repeat(reverse: reverse);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      AmbientMotionFrame(
        plant: _plantController,
        steam: _steamController,
        lantern: _lanternController,
      ),
    );
  }

  @override
  void dispose() {
    _plantController.dispose();
    _steamController.dispose();
    _lanternController.dispose();
    super.dispose();
  }
}
