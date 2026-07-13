import 'package:flutter/foundation.dart';

@immutable
class PerchNotificationCandidate {
  const PerchNotificationCandidate({
    required this.id,
    required this.title,
    required this.reason,
    required this.urgency,
    this.requiresAction = false,
    this.isTimeSensitive = false,
  });

  final String id;
  final String title;
  final String reason;
  final double urgency;
  final bool requiresAction;
  final bool isTimeSensitive;
}

@immutable
class NotificationDecision {
  const NotificationDecision({
    required this.shouldSurface,
    required this.priority,
    required this.presentation,
  });

  final bool shouldSurface;
  final double priority;
  final String presentation;
}

class NotificationEngine {
  const NotificationEngine();

  NotificationDecision decide(PerchNotificationCandidate candidate) {
    var priority = candidate.urgency.clamp(0.0, 1.0);
    if (candidate.requiresAction) priority += 0.15;
    if (candidate.isTimeSensitive) priority += 0.20;
    priority = priority.clamp(0.0, 1.0);

    final shouldSurface = priority >= 0.45;
    final presentation = switch (priority) {
      >= 0.85 => 'interruptive',
      >= 0.65 => 'prominent',
      >= 0.45 => 'ambient',
      _ => 'silent',
    };

    return NotificationDecision(
      shouldSurface: shouldSurface,
      priority: priority,
      presentation: presentation,
    );
  }
}
