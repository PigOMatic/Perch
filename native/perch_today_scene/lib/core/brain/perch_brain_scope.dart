import 'package:flutter/widgets.dart';

import 'perch_brain.dart';

class PerchBrainScope extends InheritedNotifier<PerchBrain> {
  const PerchBrainScope({
    super.key,
    required PerchBrain brain,
    required super.child,
  }) : super(notifier: brain);

  static PerchBrain of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PerchBrainScope>();
    assert(scope != null, 'No PerchBrainScope found in context.');
    return scope!.notifier!;
  }

  static PerchBrain read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<PerchBrainScope>();
    final scope = element?.widget as PerchBrainScope?;
    assert(scope != null, 'No PerchBrainScope found in context.');
    return scope!.notifier!;
  }
}
