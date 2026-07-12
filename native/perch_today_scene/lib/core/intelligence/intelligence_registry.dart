import '../brief/daily_brief_engine.dart';
import '../email/email_intelligence.dart';
import '../memory/memory_engine.dart';
import '../notifications/notification_engine.dart';
import '../projects/project_assessor.dart';
import '../recommendations/perch_recommendation.dart';

/// Central composition root for Perch's reasoning services.
///
/// UI code should depend on this registry or PerchBrain rather than constructing
/// intelligence systems independently.
class IntelligenceRegistry {
  IntelligenceRegistry({
    this.projectAssessor = const ProjectAssessor(),
    this.emailIntelligence = const EmailIntelligence(),
    this.recommendationEngine = const RecommendationEngine(),
    this.dailyBriefEngine = const DailyBriefEngine(),
    this.notificationEngine = const NotificationEngine(),
    MemoryEngine? memoryEngine,
  }) : memoryEngine = memoryEngine ?? MemoryEngine();

  final ProjectAssessor projectAssessor;
  final EmailIntelligence emailIntelligence;
  final RecommendationEngine recommendationEngine;
  final DailyBriefEngine dailyBriefEngine;
  final NotificationEngine notificationEngine;
  final MemoryEngine memoryEngine;
}
