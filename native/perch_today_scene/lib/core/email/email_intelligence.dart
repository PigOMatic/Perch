import 'package:flutter/foundation.dart';

@immutable
class EmailSignal {
  const EmailSignal({
    required this.id,
    required this.sender,
    required this.subject,
    required this.receivedAt,
    this.preview = '',
    this.isUnread = true,
    this.isDirectToUser = true,
    this.senderImportance = 0.5,
    this.hasDeadlineLanguage = false,
    this.hasQuestion = false,
    this.hasAttachment = false,
  });

  final String id;
  final String sender;
  final String subject;
  final String preview;
  final DateTime receivedAt;
  final bool isUnread;
  final bool isDirectToUser;
  final double senderImportance;
  final bool hasDeadlineLanguage;
  final bool hasQuestion;
  final bool hasAttachment;
}

enum EmailAttentionLevel { quiet, review, important, urgent }

@immutable
class EmailAssessment {
  const EmailAssessment({
    required this.emailId,
    required this.sender,
    required this.subject,
    required this.preview,
    required this.receivedAt,
    required this.isUnread,
    required this.hasAttachment,
    required this.score,
    required this.level,
    required this.reason,
    required this.suggestedAction,
  });

  final String emailId;
  final String sender;
  final String subject;
  final String preview;
  final DateTime receivedAt;
  final bool isUnread;
  final bool hasAttachment;
  final double score;
  final EmailAttentionLevel level;
  final String reason;
  final String suggestedAction;
}

class EmailIntelligence {
  const EmailIntelligence();

  EmailAssessment assess(EmailSignal email, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final ageHours = current.difference(email.receivedAt).inMinutes / 60;
    final recency = (1 - ageHours / 72).clamp(0.0, 1.0);

    var score = email.senderImportance.clamp(0.0, 1.0) * 0.30;
    if (email.isUnread) score += 0.15;
    if (email.isDirectToUser) score += 0.12;
    if (email.hasDeadlineLanguage) score += 0.22;
    if (email.hasQuestion) score += 0.13;
    if (email.hasAttachment) score += 0.03;
    score += recency * 0.05;
    score = score.clamp(0.0, 1.0);

    final level = switch (score) {
      >= 0.78 => EmailAttentionLevel.urgent,
      >= 0.58 => EmailAttentionLevel.important,
      >= 0.34 => EmailAttentionLevel.review,
      _ => EmailAttentionLevel.quiet,
    };

    return EmailAssessment(
      emailId: email.id,
      sender: email.sender,
      subject: email.subject,
      preview: email.preview,
      receivedAt: email.receivedAt,
      isUnread: email.isUnread,
      hasAttachment: email.hasAttachment,
      score: score,
      level: level,
      reason: _reason(email, level),
      suggestedAction: _action(email, level),
    );
  }

  List<EmailAssessment> rank(Iterable<EmailSignal> emails, {DateTime? now}) {
    final results = emails.map((email) => assess(email, now: now)).toList();
    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }

  String _reason(EmailSignal email, EmailAttentionLevel level) {
    if (email.hasDeadlineLanguage) return 'Contains time-sensitive language.';
    if (email.hasQuestion && email.isDirectToUser) {
      return 'A direct question appears to need a response.';
    }
    if (email.senderImportance >= 0.8) return 'From a high-priority sender.';
    if (level == EmailAttentionLevel.quiet) {
      return 'No strong attention signals detected.';
    }
    return 'Unread and recent enough to review.';
  }

  String _action(EmailSignal email, EmailAttentionLevel level) {
    if (email.hasQuestion) return 'Review and draft a response.';
    if (email.hasDeadlineLanguage) return 'Open now and confirm the deadline.';
    if (level == EmailAttentionLevel.quiet) {
      return 'Leave in the normal inbox flow.';
    }
    return 'Review when the desk is clear.';
  }
}
