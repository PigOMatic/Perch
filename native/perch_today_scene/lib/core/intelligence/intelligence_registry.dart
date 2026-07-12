import '../email/email_intelligence.dart';
import '../projects/project_assessor.dart';
import '../recommendations/perch_recommendation.dart';

/// Central composition root for Perch's reasoning services.
///
/// UI code should depend on this registry or PerchBrain rather than constructing
/// intelligence systems independently.
class IntelligenceRegistry {
  const IntelligenceRegistry({
    this.projectAssessor = const ProjectAssessor(),
    this.emailIntelligence = const EmailIntelligence(),
    this.recommendationEngine = const RecommendationEngine(),
  });

  final ProjectAssessor projectAssessor;
  final EmailIntelligence emailIntelligence;
  final RecommendationEngine recommendationEngine;
}
