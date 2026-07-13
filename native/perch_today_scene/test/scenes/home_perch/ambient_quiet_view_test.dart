import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/scenes/home_perch/ambient_quiet_view.dart';

void main() {
  testWidgets('enters quiet mode after inactivity and wakes on input', (
    tester,
  ) async {
    final changes = <bool>[];

    await tester.pumpWidget(
      MaterialApp(
        home: AmbientQuietView(
          settleDelay: const Duration(milliseconds: 100),
          onQuietChanged: changes.add,
          builder: (context, quiet) => Center(
            child: Text(quiet ? 'quiet' : 'working'),
          ),
        ),
      ),
    );

    expect(find.text('working'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 99));
    expect(find.text('working'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('quiet'), findsOneWidget);
    expect(changes, [true]);

    await tester.tap(find.text('quiet'));
    await tester.pump();

    expect(find.text('working'), findsOneWidget);
    expect(changes, [true, false]);
  });

  testWidgets('rearms the inactivity deadline when activity occurs', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AmbientQuietView(
          settleDelay: const Duration(milliseconds: 100),
          builder: (context, quiet) => Center(
            child: Text(quiet ? 'quiet' : 'working'),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.text('working'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    expect(find.text('working'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    expect(find.text('quiet'), findsOneWidget);
  });

  testWidgets('keyboard input keeps an active workspace awake', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AmbientQuietView(
          settleDelay: const Duration(milliseconds: 100),
          builder: (context, quiet) => Column(
            children: [
              Text(quiet ? 'quiet' : 'working'),
              const TextField(autofocus: true),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 80));
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    expect(find.text('working'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    expect(find.text('quiet'), findsOneWidget);
  });
}
