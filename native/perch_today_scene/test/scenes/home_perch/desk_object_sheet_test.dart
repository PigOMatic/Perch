import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/scenes/home_perch/desk_object_sheet.dart';

void main() {
  Future<void> pumpHarness(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    DeskObjectSheetStyle style = DeskObjectSheetStyle.paper,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                key: const ValueKey('open-sheet'),
                onPressed: () => showDeskObjectSheet<void>(
                  context: context,
                  semanticsLabel: 'Desk workspace',
                  style: style,
                  builder: (context) => const DeskObjectSheetBody(
                    eyebrow: 'Desk priority',
                    title: 'Finish the most important thing',
                    child: Text('A focused workspace that remains scrollable.'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('opens a draggable phone-safe workspace', (tester) async {
    await pumpHarness(tester);
    await tester.tap(find.byKey(const ValueKey('open-sheet')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('desk-object-sheet')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('desk-object-sheet-handle')),
      findsOneWidget,
    );
    expect(find.text('Finish the most important thing'), findsOneWidget);
    expect(find.byType(DraggableScrollableSheet), findsOneWidget);

    final sheetSize = tester.getSize(
      find.byKey(const ValueKey('desk-object-sheet')),
    );
    expect(sheetSize.width, closeTo(390, 1));
    expect(sheetSize.height, lessThan(844));
    expect(sheetSize.height, greaterThan(300));
  });

  testWidgets('supports the sticky-note physical treatment', (tester) async {
    await pumpHarness(
      tester,
      size: const Size(430, 932),
      style: DeskObjectSheetStyle.stickyNote,
    );
    await tester.tap(find.byKey(const ValueKey('open-sheet')));
    await tester.pumpAndSettle();

    final material = tester.widget<Material>(
      find.byKey(const ValueKey('desk-object-sheet')),
    );
    expect(material.borderRadius, isNotNull);
    expect(find.text('DESK PRIORITY'), findsOneWidget);
  });

  testWidgets('remains constrained on a wide desktop surface', (tester) async {
    await pumpHarness(tester, size: const Size(1440, 900));
    await tester.tap(find.byKey(const ValueKey('open-sheet')));
    await tester.pumpAndSettle();

    final sheetSize = tester.getSize(
      find.byKey(const ValueKey('desk-object-sheet')),
    );
    expect(sheetSize.height, lessThanOrEqualTo(900));
    expect(sheetSize.height, greaterThan(300));
  });
}
