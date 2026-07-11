enum EmailSignalCategory {
  money,
  calendar,
  travel,
  family,
  health,
  work,
  delivery,
  project,
  security,
  reference,
  noise,
}

enum EmailSuggestedActionType {
  addToToday,
  attachToProject,
  createMilestone,
  updateMilestone,
  addCalendarEvent,
  addReminder,
  addTravelRecord,
  addMoneyRecord,
  saveReference,
  askUser,
  ignore,
}

enum EmailReviewStatus {
  proposed,
  accepted,
  rejected,
  superseded,
  expired,
}

class EmailSourceReference {
  const EmailSourceReference({
    required this.messageId,
    required this.threadId,
    required this.subject,
    required this.sender,
    required this.receivedAt,
    this.openUrl,
  });

  final String messageId;
  final String threadId;
  final String subject;
  final String sender;
  final DateTime receivedAt;
  final Uri? openUrl;
}

class EmailRelevanceDimensions {
  const EmailRelevanceDimensions({
    required this.urgency,
    required this.importance,
    required this.confidence,
    required this.actionability,
    required this.projectMatch,
    required this.contextMatch,
    required this.freshness,
    required this.consequence,
    required this.userInterest,
  });

  /// Values are normalized from 0.0 to 1.0.
  final double urgency;
  final double importance;
  final double confidence;
  final double actionability;
  final double projectMatch;
  final double contextMatch;
  final double freshness;
  final double consequence;
  final double userInterest;

  double get displayPriority {
    final weighted =
        urgency * 0.18 +
        importance * 0.17 +
        confidence * 0.08 +
        actionability * 0.14 +
        projectMatch * 0.14 +
        contextMatch * 0.08 +
        freshness * 0.07 +
        consequence * 0.10 +
        userInterest * 0.04;
    return weighted.clamp(0.0, 1.0);
  }
}

class EmailSuggestedAction {
  const EmailSuggestedAction({
    required this.type,
    required this.label,
    this.targetProjectId,
    this.proposedDate,
    this.requiresConfirmation = true,
  });

  final EmailSuggestedActionType type;
  final String label;
  final String? targetProjectId;
  final DateTime? proposedDate;
  final bool requiresConfirmation;
}

class EmailSignal {
  const EmailSignal({
    required this.id,
    required this.category,
    required this.title,
    required this.fact,
    required this.supportingExcerpt,
    required this.source,
    required this.relevance,
    required this.suggestedActions,
    required this.createdAt,
    this.eventAt,
    this.amount,
    this.currencyCode,
    this.matchedProjectIds = const [],
    this.matchedEntityIds = const [],
    this.reviewStatus = EmailReviewStatus.proposed,
    this.supersedesSignalId,
  });

  final String id;
  final EmailSignalCategory category;
  final String title;
  final String fact;
  final String supportingExcerpt;
  final EmailSourceReference source;
  final EmailRelevanceDimensions relevance;
  final List<EmailSuggestedAction> suggestedActions;
  final DateTime createdAt;
  final DateTime? eventAt;
  final double? amount;
  final String? currencyCode;
  final List<String> matchedProjectIds;
  final List<String> matchedEntityIds;
  final EmailReviewStatus reviewStatus;
  final String? supersedesSignalId;

  bool get needsReview => reviewStatus == EmailReviewStatus.proposed;

  bool get isTimeSensitive {
    if (eventAt == null) return relevance.urgency >= 0.7;
    return eventAt!.isBefore(DateTime.now().add(const Duration(days: 14)));
  }
}

abstract interface class EmailIntelligenceRepository {
  Future<List<EmailSignal>> reviewCandidateSignals({
    DateTime? since,
    Set<EmailSignalCategory>? categories,
  });

  Future<void> acceptSignal(
    String signalId, {
    required EmailSuggestedAction action,
  });

  Future<void> rejectSignal(String signalId);

  Future<void> rescoreSignals({required DateTime now});
}
