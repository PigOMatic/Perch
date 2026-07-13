import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/brief/daily_brief_engine.dart';
import 'package:perch_today_scene/core/context/perch_context_snapshot.dart';
import 'package:perch_today_scene/core/recommendations/perch_recommendation.dart';

void main() {
  const engine = DailyBriefEngine();

  test('brief limits facts and chooses highest-priority recommendation', () {
    final context = PerchContextSnapshot(
      capturedAt: DateTime(2026, 7, 12),
      energy: 0.8,
      availableMinutes: 60,
    );

    final brief = engine.build(
      context: context,
      facts: const ['One', 'Two', 'Three', 'Four'],
      recommendations: const [
        PerchRecommendation(
          id: 'low',
          title: 'Low',
          reason: 'Low priority',
          actionLabel: 'Later',
          priority: 0.2,
          source: 'test',
        ),
        PerchRecommendation(
          id: 'high',
          title: 'High',
          reason: 'High priority',
          actionLabel: 'Do it',
          priority: 0.9,
          source: 'test',
        ),
      ],
      now: DateTime(2026, 7, 12, 9),
    );

    expect(brief.facts, hasLength(3));
    expect(brief.recommendation?.id, 'high');
    expect(brief.opening, contains('morning'));
  });

  test('low energy and little time changes the opening', () {
    final context = PerchContextSnapshot(
      capturedAt: DateTime(2026, 7, 12),
      energy: 0.2,
      availableMinutes: 10,
    );

    final brief = engine.build(
      context: context,
      facts: const [],
      recommendations: const [],
      now: DateTime(2026, 7, 12, 20),
    );

    expect(brief.opening, contains('protect your energy'));
  });
}
