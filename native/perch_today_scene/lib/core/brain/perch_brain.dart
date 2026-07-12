import 'dart:async';

import 'package:flutter/foundation.dart';

import '../events/perch_event.dart';
import '../events/perch_event_bus.dart';
import 'perch_brain_state.dart';

class PerchBrain extends ChangeNotifier {
  PerchBrain({PerchEventBus? eventBus})
      : eventBus = eventBus ?? PerchEventBus() {
    _subscription = this.eventBus.events.listen(_reduce);
  }

  final PerchEventBus eventBus;
  late final StreamSubscription<PerchEvent> _subscription;
  PerchBrainState _state = const PerchBrainState();

  PerchBrainState get state => _state;

  void publish(PerchEvent event) => eventBus.publish(event);

  void _reduce(PerchEvent event) {
    PerchBrainState? next;

    switch (event.type) {
      case PerchEventTypes.journalFocused:
        next = _state.copyWith(
          journalFocused: true,
          activeDeskObjectId: 'journal',
        );
        break;
      case PerchEventTypes.journalClosed:
        next = _state.copyWith(
          journalFocused: false,
          clearActiveDeskObject: true,
        );
        break;
      case PerchEventTypes.quickCaptureAdded:
        final value = event.payload['text'];
        if (value is String && value.trim().isNotEmpty) {
          final capture = value.trim();
          final captures = <String>[
            capture,
            ..._state.captures.where((item) => item != capture),
          ];
          next = _state.copyWith(captures: captures);
        }
        break;
      case PerchEventTypes.priorityChanged:
        final value = event.payload['text'];
        if (value is String) {
          next = _state.copyWith(priority: value.trim());
        }
        break;
      case PerchEventTypes.taskCompletionChanged:
        final taskId = event.payload['taskId'];
        final completed = event.payload['completed'];
        if (taskId is String && completed is bool) {
          final completedIds = Set<String>.from(_state.completedTaskIds);
          if (completed) {
            completedIds.add(taskId);
          } else {
            completedIds.remove(taskId);
          }
          next = _state.copyWith(completedTaskIds: completedIds);
        }
        break;
      case PerchEventTypes.deskObjectActivated:
        final id = event.payload['id'];
        if (id is String) {
          next = _state.copyWith(activeDeskObjectId: id);
        }
        break;
      default:
        break;
    }

    if (next == null) return;
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    eventBus.dispose();
    super.dispose();
  }
}
