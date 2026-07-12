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
    switch (event.type) {
      case PerchEventTypes.journalFocused:
        _state = _state.copyWith(journalFocused: true, activeDeskObjectId: 'journal');
      case PerchEventTypes.journalClosed:
        _state = _state.copyWith(journalFocused: false, clearActiveDeskObject: true);
      case PerchEventTypes.quickCaptureAdded:
        final value = event.payload['text'];
        if (value is String && value.trim().isNotEmpty) {
          _state = _state.copyWith(captures: <String>[value.trim(), ..._state.captures]);
        }
      case PerchEventTypes.priorityChanged:
        final value = event.payload['text'];
        if (value is String) _state = _state.copyWith(priority: value.trim());
      case PerchEventTypes.deskObjectActivated:
        final id = event.payload['id'];
        if (id is String) _state = _state.copyWith(activeDeskObjectId: id);
      default:
        return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    eventBus.dispose();
    super.dispose();
  }
}
