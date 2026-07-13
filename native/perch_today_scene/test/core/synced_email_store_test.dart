import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/email/email_intelligence.dart';
import 'package:perch_today_scene/core/email/synced_email_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('round trips normalized email signals without credentials', () async {
    const store = SyncedEmailStore();
    final receivedAt = DateTime(2026, 7, 12, 14, 30);
    final email = EmailSignal(
      id: 'message-1',
      sender: 'Charge Nurse',
      subject: 'Updated assignment',
      preview: 'Please confirm before the shift.',
      receivedAt: receivedAt,
      senderImportance: .95,
      hasDeadlineLanguage: true,
      hasQuestion: true,
      hasAttachment: true,
    );

    await store.replace([email]);
    final restored = await store.read();

    expect(restored, hasLength(1));
    expect(restored.single.id, 'message-1');
    expect(restored.single.sender, 'Charge Nurse');
    expect(restored.single.subject, 'Updated assignment');
    expect(restored.single.preview, 'Please confirm before the shift.');
    expect(restored.single.receivedAt, receivedAt);
    expect(restored.single.hasDeadlineLanguage, isTrue);
    expect(restored.single.hasQuestion, isTrue);
    expect(restored.single.hasAttachment, isTrue);
  });

  test('ignores malformed stored data safely', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'perch.email.synced.v1': '{not json',
    });

    const store = SyncedEmailStore();
    expect(await store.read(), isEmpty);
  });

  test('clear removes the synchronized inbox', () async {
    const store = SyncedEmailStore();
    await store.replace([
      EmailSignal(
        id: 'one',
        sender: 'Sender',
        subject: 'Subject',
        receivedAt: DateTime(2026, 7, 12),
      ),
    ]);

    await store.clear();
    expect(await store.read(), isEmpty);
  });
}
