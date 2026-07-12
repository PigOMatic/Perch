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

  test('ambience updates can change one setting without resetting the other', () {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.deskAmbienceChanged,
      source: 'desk.persistence',
      payload: {'lanternOn': true, 'steamOn': false},
    ));
    expect(brain.state.lanternOn, isTrue);
    expect(brain.state.steamOn, isFalse);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.deskAmbienceChanged,
      source: 'desk.coffee',
      payload: {'steamOn': true},
    ));
    expect(brain.state.lanternOn, isTrue);
    expect(brain.state.steamOn, isTrue);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.deskAmbienceChanged,
      source: 'desk.lantern',
      payload: {'lanternOn': false},
    ));
    expect(brain.state.lanternOn, isFalse);
    expect(brain.state.steamOn, isTrue);
  });

  test('plant growth is clamped before entering shared brain state', () {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.plantStageChanged,
      source: 'desk.plant',
      payload: {'stage': 99},
    ));
    expect(brain.state.plantStage, 3);

    brain.publish(const PerchEvent(
      type: PerchEventTypes.plantStageChanged,
      source: 'desk.plant',
      payload: {'stage': -4},
    ));
    expect(brain.state.plantStage, 0);
  });
}
