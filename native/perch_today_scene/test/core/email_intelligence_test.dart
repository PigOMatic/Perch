import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/email/email_intelligence.dart';

void main() {
  const intelligence = EmailIntelligence();
  final now = DateTime(2026, 7, 12, 12);

  test('urgent direct deadline email ranks above quiet newsletter', () {
    final urgent = EmailSignal(
      id: 'urgent',
      sender: 'Charge Nurse',
      subject: 'Response needed before shift',
      receivedAt: now.subtract(const Duration(hours: 1)),
      senderImportance: 1,
      hasDeadlineLanguage: true,
      hasQuestion: true,
    );

    final quiet = EmailSignal(
      id: 'quiet',
      sender: 'Newsletter',
      subject: 'Weekly digest',
      receivedAt: now.subtract(const Duration(days: 3)),
      isUnread: false,
      isDirectToUser: false,
      senderImportance: 0.1,
    );

    final ranked = intelligence.rank([quiet, urgent], now: now);

    expect(ranked.first.emailId, 'urgent');
    expect(ranked.first.level, EmailAttentionLevel.urgent);
    expect(ranked.last.level, EmailAttentionLevel.quiet);
  });

  test('assessment score remains normalized', () {
    final email = EmailSignal(
      id: 'email',
      sender: 'Sender',
      subject: 'Question',
      receivedAt: now,
      senderImportance: 4,
      hasDeadlineLanguage: true,
      hasQuestion: true,
      hasAttachment: true,
    );

    final result = intelligence.assess(email, now: now);

    expect(result.score, inInclusiveRange(0, 1));
    expect(result.suggestedAction, isNotEmpty);
    expect(result.reason, isNotEmpty);
  });
}
