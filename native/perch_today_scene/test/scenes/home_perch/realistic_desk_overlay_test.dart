import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/scenes/home_perch/realistic_desk_overlay.dart';

void main() {
  Widget buildOverlay({
    required bool steamOn,
    required bool lanternOn,
    int plantStage = 1,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 1200,
          height: 800,
          child: RealisticDeskOverlay(
            journalFocused: false,
            lanternOn: lanternOn,
            steamOn: steamOn,
            plantStage: plantStage,
            priority: 'Protect focused work',
          ),
        ),
      ),
    );
  }

  Iterable<CustomPaint> activePainters(WidgetTester tester) {
    return tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((paint) => paint.painter != null);
  }

  testWidgets('steam painter follows the shared steam setting', (tester) async {
    await tester.pumpWidget(buildOverlay(steamOn: false, lanternOn: false));
    expect(activePainters(tester), isEmpty);

    await tester.pumpWidget(buildOverlay(steamOn: true, lanternOn: false));
    await tester.pump();
    expect(activePainters(tester), hasLength(1));
  });

  testWidgets('plant visual follows the shared growth stage', (tester) async {
    await tester.pumpWidget(
      buildOverlay(steamOn: false, lanternOn: false, plantStage: 0),
    );
    expect(find.byKey(const ValueKey('plant-stage-0')), findsOneWidget);
    expect(find.bySemanticsLabel('Plant growth stage 0'), findsOneWidget);

    await tester.pumpWidget(
      buildOverlay(steamOn: false, lanternOn: false, plantStage: 3),
    );
    await tester.pump(const Duration(milliseconds: 420));
    expect(find.byKey(const ValueKey('plant-stage-3')), findsOneWidget);
    expect(find.bySemanticsLabel('Plant growth stage 3'), findsOneWidget);
    expect(find.byIcon(Icons.local_florist), findsOneWidget);
  });

  testWidgets('plant stage is defensively clamped', (tester) async {
    await tester.pumpWidget(
      buildOverlay(steamOn: false, lanternOn: false, plantStage: 99),
    );
    expect(find.byKey(const ValueKey('plant-stage-3')), findsOneWidget);
    expect(find.bySemanticsLabel('Plant growth stage 3'), findsOneWidget);
  });

  testWidgets('journal focus hides the realistic desk layer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RealisticDeskOverlay(
            journalFocused: true,
            lanternOn: true,
            steamOn: true,
            plantStage: 2,
            priority: 'Protect focused work',
          ),
        ),
      ),
    );

    final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacity.opacity, 0);
  });
}
