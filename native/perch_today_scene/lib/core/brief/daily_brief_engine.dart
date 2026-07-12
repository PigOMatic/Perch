import 'package:flutter/foundation.dart';

import '../context/perch_context_snapshot.dart';
import '../recommendations/perch_recommendation.dart';

@immutable
class DailyBrief {
  const DailyBrief({
    required this.opening,
    required this.facts,
    required this.recommendation,
    required this.generatedAt,
  });

  final String opening;
  final List<String> facts;
  final PerchRecommendation? recommendation;
  final DateTime generatedAt;
}

class DailyBriefEngine {
  const DailyBriefEngine();

  DailyBrief build({
    required PerchContextSnapshot context,
    required Iterable<String> facts,
    required Iterable<PerchRecommendation> recommendations,
    DateTime? now,
  }) {
    final generatedAt = now ?? DateTime.now();
    final sorted = recommendations.toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    return DailyBrief(
      opening: _opening(context, generatedAt),
      facts: facts.where((fact) => fact.trim().isNotEmpty).take(3).toList(),
      recommendation: sorted.isEmpty ? null : sorted.first,
      generatedAt: generatedAt,
    );
  }

  String _opening(PerchContextSnapshot context, DateTime now) {
    final daypart = switch (now.hour) {
      < 12 => 'morning',
      < 17 => 'afternoon',
      _ => 'evening',
    };

    if (context.isLowEnergy && context.isTimeConstrained) {
      return 'Good $daypart. Keep this small and protect your energy.';
    }
    if (context.totalPressure >= 0.7) {
      return 'Good $daypart. There is pressure today, so Perch narrowed the field.';
    }
    return 'Good $daypart. Here is what matters without the noise.';
  }
}
