import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/scenes/home_perch/realistic_desk_overlay.dart';

void main() {
  Widget buildOverlay({
    required bool steamOn,
    required bool lanternOn,
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
            priority: 'Protect focused work',
          ),
        ),
      ),
    );
  }

  testWidgets('steam painter follows the shared steam setting', (tester) async {
    await tester.pumpWidget(buildOverlay(steamOn: false, lanternOn: false));
    expect(find.byType(CustomPaint), findsNothing);

    await tester.pumpWidget(buildOverlay(steamOn: true, lanternOn: false));
    await tester.pump();
    expect(find.byType(CustomPaint), findsOneWidget);
  });

  testWidgets('journal focus hides the realistic desk layer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RealisticDeskOverlay(
            journalFocused: true,
            lanternOn: true,
            steamOn: true,
            priority: 'Protect focused work',
          ),
        ),
      ),
    );

    final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacity.opacity, 0);
  });
}
