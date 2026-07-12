import 'package:flutter/foundation.dart';

@immutable
class ProjectSignal {
  const ProjectSignal({
    required this.id,
    required this.title,
    required this.importance,
    required this.progress,
    required this.confidence,
    required this.daysSinceActivity,
    this.blocked = false,
    this.waitingOn,
    this.nextAction,
  });

  final String id;
  final String title;
  final double importance;
  final double progress;
  final double confidence;
  final int daysSinceActivity;
  final bool blocked;
  final String? waitingOn;
  final String? nextAction;
}

@immutable
class ProjectAssessment {
  const ProjectAssessment({
    required this.projectId,
    required this.health,
    required this.momentum,
    required this.risk,
    required this.reason,
    this.recommendedAction,
  });

  final String projectId;
  final double health;
  final double momentum;
  final double risk;
  final String reason;
  final String? recommendedAction;
}

class ProjectAssessor {
  const ProjectAssessor();

  ProjectAssessment assess(ProjectSignal project) {
    final staleness = (project.daysSinceActivity / 30).clamp(0.0, 1.0);
    final blockerPenalty = project.blocked ? 0.35 : 0.0;
    final waitingPenalty = project.waitingOn == null ? 0.0 : 0.12;

    final momentum = (1 - staleness) * (project.progress * 0.6 + 0.4);
    final risk = (staleness * 0.45 +
            blockerPenalty +
            waitingPenalty +
            (1 - project.confidence) * 0.25)
        .clamp(0.0, 1.0);
    final health = (project.progress * 0.35 +
            project.confidence * 0.30 +
            momentum * 0.25 +
            project.importance * 0.10 -
            risk * 0.40)
        .clamp(0.0, 1.0);

    return ProjectAssessment(
      projectId: project.id,
      health: health,
      momentum: momentum.clamp(0.0, 1.0),
      risk: risk,
      reason: _reason(project, risk),
      recommendedAction: project.nextAction,
    );
  }

  String _reason(ProjectSignal project, double risk) {
    if (project.blocked) return 'Blocked and needs intervention.';
    if (project.waitingOn != null) return 'Waiting on ${project.waitingOn}.';
    if (project.daysSinceActivity >= 14) return 'Momentum is fading from inactivity.';
    if (risk >= 0.6) return 'Risk is elevated and deserves review.';
    if (project.progress >= 0.8) return 'Close to completion; protect momentum.';
    return 'Moving normally with a clear next action.';
  }
}
