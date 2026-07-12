import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/brain/perch_brain_scope.dart';
import 'package:perch_today_scene/core/events/perch_event.dart';
import 'package:perch_today_scene/data/demo_today_data.dart';
import 'package:perch_today_scene/scenes/home_perch/home_perch_scene.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';

void main() {
  testWidgets('journal focus follows shared brain state', (tester) async {
    final brain = PerchBrain();
    addTearDown(brain.dispose);

    await tester.pumpWidget(
      PerchBrainScope(
        brain: brain,
        child: const MaterialApp(
          home: SizedBox(
            width: 1200,
            height: 800,
            child: HomePerchScene(
              data: demoTodayData,
              worldState: demoWorldState,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Back to desk'), findsNothing);

    brain.publish(
      const PerchEvent(
        type: PerchEventTypes.journalFocused,
        source: 'test',
      ),
    );
    await tester.pump();

    expect(brain.state.journalFocused, isTrue);
    expect(find.text('Back to desk'), findsOneWidget);

    brain.publish(
      const PerchEvent(
        type: PerchEventTypes.journalClosed,
        source: 'test',
      ),
    );
    await tester.pump();

    expect(brain.state.journalFocused, isFalse);
    expect(find.text('Back to desk'), findsNothing);
  });
}
