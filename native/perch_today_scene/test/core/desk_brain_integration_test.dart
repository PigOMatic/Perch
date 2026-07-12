import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/events/perch_event.dart';

void main() {
  test('desk events update priority capture active object and completion', () {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.priorityChanged,
      source: 'desk.sticky_note',
      payload: {'text': 'Finish Perch Windows build'},
    ));
    brain.publish(const PerchEvent(
      type: PerchEventTypes.quickCaptureAdded,
      source: 'desk.pen',
      payload: {'text': 'Review email ranking'},
    ));
    brain.publish(const PerchEvent(
      type: PerchEventTypes.deskObjectActivated,
      source: 'desk.envelope',
      payload: {'id': 'envelope'},
    ));
    brain.publish(const PerchEvent(
      type: PerchEventTypes.taskCompletionChanged,
      source: 'desk.today',
      payload: {'taskId': 'next_due', 'completed': true},
    ));

    expect(brain.state.priority, 'Finish Perch Windows build');
    expect(brain.state.captures.first, 'Review email ranking');
    expect(brain.state.activeDeskObjectId, 'envelope');
    expect(brain.state.completedTaskIds, contains('next_due'));
  });

  test('duplicate captures are moved to front without duplication', () {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    for (final value in ['One', 'Two', 'One']) {
      brain.publish(PerchEvent(
        type: PerchEventTypes.quickCaptureAdded,
        source: 'test',
        payload: {'text': value},
      ));
    }

    expect(brain.state.captures, ['One', 'Two']);
  });
}
