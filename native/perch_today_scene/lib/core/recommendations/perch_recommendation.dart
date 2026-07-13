import 'package:flutter/foundation.dart';

@immutable
class PerchRecommendation {
  const PerchRecommendation({
    required this.id,
    required this.title,
    required this.reason,
    required this.actionLabel,
    required this.priority,
    required this.source,
  });

  final String id;
  final String title;
  final String reason;
  final String actionLabel;
  final double priority;
  final String source;
}

class RecommendationEngine {
  const RecommendationEngine();

  List<PerchRecommendation> rank(Iterable<PerchRecommendation> items) {
    final ranked = items.toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    return ranked;
  }

  PerchRecommendation? top(Iterable<PerchRecommendation> items) {
    final ranked = rank(items);
    return ranked.isEmpty ? null : ranked.first;
  }
}
