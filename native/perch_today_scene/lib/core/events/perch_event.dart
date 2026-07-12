import 'package:flutter/foundation.dart';

/// Immutable event passed through the Perch intelligence bus.
@immutable
class PerchEvent {
  const PerchEvent({
    required this.type,
    required this.source,
    this.payload = const <String, Object?>{},
    this.occurredAt,
  });

  final String type;
  final String source;
  final Map<String, Object?> payload;
  final DateTime? occurredAt;

  DateTime get timestamp => occurredAt ?? DateTime.now();
}

abstract final class PerchEventTypes {
  static const journalFocused = 'journal.focused';
  static const journalClosed = 'journal.closed';
  static const quickCaptureAdded = 'capture.added';
  static const priorityChanged = 'priority.changed';
  static const taskCompletionChanged = 'task.completion.changed';
  static const deskObjectActivated = 'desk.object.activated';
  static const worldStateChanged = 'world.state.changed';
}
