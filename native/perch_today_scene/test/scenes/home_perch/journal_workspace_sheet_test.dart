import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/data/demo_today_data.dart';
import 'package:perch_today_scene/scenes/home_perch/journal_engine.dart';

void main() {
  testWidgets('desk journal opens a large ruled phone workspace', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              height: 230,
              child: JournalEngine(
                data: demoTodayData,
                focused: false,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-journal-workspace')));
    await tester.pumpAndSettle();

    final sheet = find.byKey(const ValueKey('desk-object-sheet'));
    final journalPage = find.byKey(const ValueKey('ruled-journal-page'));
    expect(sheet, findsOneWidget);
    expect(journalPage, findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text('Today')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: journalPage,
        matching: find.text(demoTodayData.dayStatus),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: journalPage,
        matching: find.text('WHAT MATTERS NEXT'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: journalPage,
        matching: find.text(demoTodayData.nextDue.title),
      ),
      findsOneWidget,
    );

    final sheetSize = tester.getSize(sheet);
    expect(sheetSize.width, closeTo(390, 1));
    expect(sheetSize.height, greaterThan(600));
  });

  testWidgets('journal workspace can return to the desk', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 240,
            child: JournalEngine(data: demoTodayData, focused: false),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-journal-workspace')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Return journal to desk'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('ruled-journal-page')), findsNothing);
  });
}
