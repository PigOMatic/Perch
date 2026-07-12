import 'dart:async';

import 'perch_event.dart';

/// Lightweight in-process bus used to keep desk objects and intelligence
/// systems decoupled. Services publish facts; interested systems subscribe.
class PerchEventBus {
  PerchEventBus();

  final StreamController<PerchEvent> _controller =
      StreamController<PerchEvent>.broadcast(sync: true);

  Stream<PerchEvent> get events => _controller.stream;

  Stream<PerchEvent> whereType(String type) =>
      events.where((event) => event.type == type);

  void publish(PerchEvent event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
