import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/brain/perch_brain_scope.dart';
import 'package:perch_today_scene/core/events/perch_event.dart';
import 'package:perch_today_scene/data/demo_today_data.dart';
import 'package:perch_today_scene/scenes/home_perch/home_perch_scene.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<PerchBrain> pumpScene(
    WidgetTester tester, {
    Size size = const Size(1200, 800),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final brain = PerchBrain();
    addTearDown(brain.dispose);

    await tester.pumpWidget(
      PerchBrainScope(
        brain: brain,
        child: const MaterialApp(
          home: HomePerchScene(
            data: demoTodayData,
            worldState: demoWorldState,
          ),
        ),
      ),
    );
    await tester.pump();
    return brain;
  }

  testWidgets('journal opens a large ruled workspace on phones', (tester) async {
    await pumpScene(tester, size: const Size(390, 844));

    final journal = find.byKey(const ValueKey('desk-journal'));
    expect(journal, findsOneWidget);

    final journalSize = tester.getSize(journal);
    expect(journalSize.width, greaterThan(350));

    await tester.tap(journal);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ruled-journal-page')), findsOneWidget);
    expect(find.text('What matters next'), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-object-sheet')), findsOneWidget);
  });

  testWidgets('journal focus still follows shared brain state', (tester) async {
    final brain = await pumpScene(tester);

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

  testWidgets('quiet view hides software but keeps physical desk', (tester) async {
    await pumpScene(tester);

    AnimatedOpacity softwareOpacity() => tester.widget<AnimatedOpacity>(
          find.byKey(const ValueKey('desk-software-affordances')),
        );
    AnimatedOpacity journalOpacity() => tester.widget<AnimatedOpacity>(
          find.byKey(const ValueKey('journal-live-content')),
        );

    expect(softwareOpacity().opacity, 1);
    expect(journalOpacity().opacity, 0);

    await tester.pump(const Duration(seconds: 20));
    await tester.pump();

    expect(softwareOpacity().opacity, 0);
    expect(journalOpacity().opacity, 0);
    expect(find.byKey(const ValueKey('plant-pot')), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    final center = tester.getCenter(find.byType(HomePerchScene));
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: center);
    await gesture.moveTo(center + const Offset(1, 1));
    await tester.pump();

    expect(softwareOpacity().opacity, 1);
    expect(journalOpacity().opacity, 0);
  });

  testWidgets('focused journal prevents quiet presentation', (tester) async {
    final brain = await pumpScene(tester);

    brain.publish(
      const PerchEvent(
        type: PerchEventTypes.journalFocused,
        source: 'test',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 20));
    await tester.pump();

    final journalOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const ValueKey('journal-live-content')),
    );

    expect(brain.state.journalFocused, isTrue);
    expect(journalOpacity.opacity, 1);
    expect(find.text('Back to desk'), findsOneWidget);
  });
}
