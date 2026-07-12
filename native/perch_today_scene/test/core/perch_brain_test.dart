import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/events/perch_event.dart';

void main() {
  test('brain reduces journal and capture events into state', () async {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.journalFocused,
      source: 'test',
    ));

    expect(brain.state.journalFocused, isTrue);
    expect(brain.state.activeDeskObjectId, 'journal');

    brain.publish(const PerchEvent(
      type: PerchEventTypes.quickCaptureAdded,
      source: 'test',
      payload: {'text': 'Buy chicken feed'},
    ));

    expect(brain.state.captures.first, 'Buy chicken feed');

    brain.publish(const PerchEvent(
      type: PerchEventTypes.journalClosed,
      source: 'test',
    ));

    expect(brain.state.journalFocused, isFalse);
    expect(brain.state.activeDeskObjectId, isNull);
  });

  test('brain ignores empty captures', () {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.quickCaptureAdded,
      source: 'test',
      payload: {'text': '   '},
    ));

    expect(brain.state.captures, isEmpty);
  });
}
