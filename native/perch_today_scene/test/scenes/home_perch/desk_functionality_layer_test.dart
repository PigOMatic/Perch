import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/brain/perch_brain_scope.dart';
import 'package:perch_today_scene/data/demo_today_data.dart';
import 'package:perch_today_scene/scenes/home_perch/desk_functionality_layer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'perch.sticky.priority': 'Finish the mobile workspace',
      'perch.brain.captures': <String>['Check the phone layout'],
      'perch.task.done': false,
      'perch.lantern.on': false,
      'perch.coffee.steam': true,
      'perch.plant.stage': 2,
    });
  });

  Future<PerchBrain> pumpDesk(
    WidgetTester tester, {
    Size size = const Size(390, 844),
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
          home: Scaffold(
            body: DeskFunctionalityLayer(
              data: demoTodayData,
              journalFocused: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return brain;
  }

  testWidgets('phone desk exposes only useful interactive tools', (tester) async {
    await pumpDesk(tester);

    expect(find.byKey(const ValueKey('desk-hit-pen')), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-hit-envelope')), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-hit-sticky_note')), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-hit-coffee')), findsNothing);
    expect(find.byKey(const ValueKey('desk-hit-plant')), findsNothing);
    expect(find.byKey(const ValueKey('desk-hit-lantern')), findsNothing);
  });

  testWidgets('sticky note opens a yellow draggable workspace', (tester) async {
    await pumpDesk(tester);

    await tester.tap(find.byKey(const ValueKey('desk-hit-sticky_note')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('desk-object-sheet')), findsOneWidget);
    expect(find.text('The one thing that matters most'), findsOneWidget);
    expect(find.text('Place on desk'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('pen opens quick capture with recent memory', (tester) async {
    await pumpDesk(tester);

    await tester.tap(find.byKey(const ValueKey('desk-hit-pen')));
    await tester.pumpAndSettle();

    expect(find.text('Quick Capture'), findsOneWidget);
    expect(find.textContaining('Check the phone layout'), findsOneWidget);
    expect(find.text('Save capture'), findsOneWidget);
  });

  testWidgets('envelope opens ranked email details in the same sheet model', (
    tester,
  ) async {
    await pumpDesk(tester);

    await tester.tap(find.byKey(const ValueKey('desk-hit-envelope')));
    await tester.pumpAndSettle();

    expect(find.text('Email Intelligence'), findsOneWidget);
    expect(find.text('Response needed before your next shift'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-object-sheet')), findsOneWidget);
  });

  testWidgets('wide surfaces keep a centered readable workspace', (tester) async {
    await pumpDesk(tester, size: const Size(1440, 900));

    await tester.tap(find.byKey(const ValueKey('desk-hit-envelope')));
    await tester.pumpAndSettle();

    final sheet = tester.getSize(find.byKey(const ValueKey('desk-object-sheet')));
    expect(sheet.width, lessThanOrEqualTo(900));
    expect(sheet.width, greaterThanOrEqualTo(500));
    expect(sheet.height, lessThan(900));
  });
}
