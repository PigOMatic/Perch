import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/email/email_intelligence.dart';
import 'package:perch_today_scene/scenes/home_perch/email_workspace_panel.dart';

void main() {
  testWidgets('email workspace slides up and can be dismissed', (tester) async {
    final assessment = EmailAssessment(
      emailId: 'important',
      sender: 'Charge Nurse',
      subject: 'Response needed before shift',
      preview: 'Please confirm the updated assignment.',
      receivedAt: DateTime(2026, 7, 12, 10),
      isUnread: true,
      hasAttachment: true,
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
    expect(find.text('Response needed before shift'), findsOneWidget);
    expect(find.text('Charge Nurse'), findsOneWidget);
    expect(find.text('Please confirm the updated assignment.'), findsOneWidget);
    expect(find.text('Open now and confirm the deadline.'), findsOneWidget);
    expect(find.text('Contains time-sensitive language.'), findsOneWidget);
    expect(find.text('91'), findsOneWidget);
    expect(find.text('Attachment'), findsOneWidget);
    expect(find.text('Unread'), findsOneWidget);

    await tester.tap(find.byTooltip('Return to desk'));
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

    expect(find.text('No messages need your attention.'), findsOneWidget);
  });
}
