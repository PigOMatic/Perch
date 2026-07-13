import 'package:flutter/foundation.dart';

@immutable
class PerchContextSnapshot {
  const PerchContextSnapshot({
    required this.capturedAt,
    this.locationId,
    this.lifeMode = 'home',
    this.energy = 0.5,
    this.availableMinutes = 30,
    this.unreadImportantEmailCount = 0,
    this.activeProjectIds = const <String>[],
    this.calendarPressure = 0,
    this.financialPressure = 0,
  });

  final DateTime capturedAt;
  final String? locationId;
  final String lifeMode;
  final double energy;
  final int availableMinutes;
  final int unreadImportantEmailCount;
  final List<String> activeProjectIds;
  final double calendarPressure;
  final double financialPressure;

  double get totalPressure =>
      ((calendarPressure + financialPressure) / 2).clamp(0.0, 1.0);

  bool get isTimeConstrained => availableMinutes < 20;
  bool get isLowEnergy => energy < 0.35;

  PerchContextSnapshot copyWith({
    DateTime? capturedAt,
    String? locationId,
    String? lifeMode,
    double? energy,
    int? availableMinutes,
    int? unreadImportantEmailCount,
    List<String>? activeProjectIds,
    double? calendarPressure,
    double? financialPressure,
  }) {
    return PerchContextSnapshot(
      capturedAt: capturedAt ?? this.capturedAt,
      locationId: locationId ?? this.locationId,
      lifeMode: lifeMode ?? this.lifeMode,
      energy: energy ?? this.energy,
      availableMinutes: availableMinutes ?? this.availableMinutes,
      unreadImportantEmailCount:
          unreadImportantEmailCount ?? this.unreadImportantEmailCount,
      activeProjectIds: activeProjectIds ?? this.activeProjectIds,
      calendarPressure: calendarPressure ?? this.calendarPressure,
      financialPressure: financialPressure ?? this.financialPressure,
    );
  }
}
