import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brain/perch_brain.dart';
import 'package:perch_today_scene/core/brain/perch_brain_scope.dart';
import 'package:perch_today_scene/data/demo_today_data.dart';
import 'package:perch_today_scene/scenes/home_perch/home_perch_scene.dart';
import 'package:perch_today_scene/world/perch_world_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSceneAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;

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
  }

  void expectCleanFrame(WidgetTester tester) {
    expect(tester.takeException(), isNull);
    expect(find.byType(HomePerchScene), findsOneWidget);
    expect(find.byKey(const ValueKey('desk-journal')), findsOneWidget);
    expect(find.byKey(const ValueKey('plant-pot')), findsOneWidget);
  }

  for (final viewport in <({String name, Size size})>[
    (name: 'compact phone', size: const Size(320, 568)),
    (name: 'modern phone', size: const Size(390, 844)),
    (name: 'phone landscape', size: const Size(844, 390)),
    (name: 'tablet portrait', size: const Size(768, 1024)),
    (name: 'desktop', size: const Size(1440, 900)),
  ]) {
    testWidgets('desk remains stable on ${viewport.name}', (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpSceneAt(tester, viewport.size);
      expectCleanFrame(tester);

      await tester.tap(find.byKey(const ValueKey('desk-journal')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('ruled-journal-page')), findsOneWidget);

      final backToDesk = find.text('Back to desk');
      expect(backToDesk, findsOneWidget);
      await tester.tap(backToDesk);
      await tester.pumpAndSettle();
      expectCleanFrame(tester);

      await tester.pump(const Duration(seconds: 20));
      await tester.pump();
      expect(tester.takeException(), isNull);

      final sceneCenter = tester.getCenter(find.byType(HomePerchScene));
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: sceneCenter);
      await gesture.moveTo(sceneCenter + const Offset(2, 2));
      await tester.pump();
      await gesture.removePointer();

      expectCleanFrame(tester);
    });
  }
}
