import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'email_intelligence.dart';

/// Local boundary between Perch's UI and a future Gmail or backend sync.
///
/// Connectors can write normalized message records without coupling the desk to
/// a specific provider. The app can then rank the same records with
/// [EmailIntelligence]. No message bodies or credentials are committed to the
/// repository.
class SyncedEmailStore {
  const SyncedEmailStore();

  static const _storageKey = 'perch.email.synced.v1';

  Future<List<EmailSignal>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const <EmailSignal>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const <EmailSignal>[];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .whereType<EmailSignal>()
          .toList(growable: false);
    } on FormatException {
      return const <EmailSignal>[];
    }
  }

  Future<void> replace(Iterable<EmailSignal> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = messages.map(_toJson).toList(growable: false);
    await prefs.setString(_storageKey, jsonEncode(payload));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Map<String, Object?> _toJson(EmailSignal email) => <String, Object?>{
        'id': email.id,
        'sender': email.sender,
        'subject': email.subject,
        'preview': email.preview,
        'receivedAt': email.receivedAt.toUtc().toIso8601String(),
        'isUnread': email.isUnread,
        'isDirectToUser': email.isDirectToUser,
        'senderImportance': email.senderImportance,
        'hasDeadlineLanguage': email.hasDeadlineLanguage,
        'hasQuestion': email.hasQuestion,
        'hasAttachment': email.hasAttachment,
      };

  EmailSignal? _fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final sender = json['sender'];
    final subject = json['subject'];
    final receivedAt = DateTime.tryParse('${json['receivedAt'] ?? ''}');
    if (id is! String ||
        sender is! String ||
        subject is! String ||
        receivedAt == null) {
      return null;
    }

    return EmailSignal(
      id: id,
      sender: sender,
      subject: subject,
      preview: json['preview'] is String ? json['preview'] as String : '',
      receivedAt: receivedAt.toLocal(),
      isUnread: json['isUnread'] is bool ? json['isUnread'] as bool : true,
      isDirectToUser: json['isDirectToUser'] is bool
          ? json['isDirectToUser'] as bool
          : true,
      senderImportance: json['senderImportance'] is num
          ? (json['senderImportance'] as num).toDouble()
          : .5,
      hasDeadlineLanguage: json['hasDeadlineLanguage'] is bool
          ? json['hasDeadlineLanguage'] as bool
          : false,
      hasQuestion:
          json['hasQuestion'] is bool ? json['hasQuestion'] as bool : false,
      hasAttachment: json['hasAttachment'] is bool
          ? json['hasAttachment'] as bool
          : false,
    );
  }
}
