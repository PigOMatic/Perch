import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/email/email_intelligence.dart';
import 'package:perch_today_scene/scenes/home_perch/email_workspace_panel.dart';

void main() {
  testWidgets('email workspace slides in and can be dismissed', (tester) async {
    final assessment = EmailAssessment(
      emailId: 'important',
      score: 0.91,
      level: EmailAttentionLevel.urgent,
      reason: 'Contains time-sensitive language.',
      suggestedAction: 'Open now and confirm the deadline.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => showEmailWorkspace(
                  context,
                  assessments: [assessment],
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Email Intelligence'), findsOneWidget);
    expect(find.text('Open now and confirm the deadline.'), findsOneWidget);
    expect(find.text('Contains time-sensitive language.'), findsOneWidget);
    expect(find.text('91'), findsOneWidget);

    await tester.tap(find.byTooltip('Return letters to envelope'));
    await tester.pumpAndSettle();

    expect(find.text('Email Intelligence'), findsNothing);
  });

  testWidgets('email workspace handles an empty inbox', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showEmailWorkspace(
                context,
                assessments: const [],
              ),
              child: const Text('Open empty'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open empty'));
    await tester.pumpAndSettle();

    expect(find.text('No letters need your attention.'), findsOneWidget);
  });
}
