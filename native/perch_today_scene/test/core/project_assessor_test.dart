import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/projects/project_assessor.dart';

void main() {
  const assessor = ProjectAssessor();

  test('healthy active project scores above stale blocked project', () {
    const healthy = ProjectSignal(
      id: 'healthy',
      title: 'Healthy project',
      importance: 0.8,
      progress: 0.65,
      confidence: 0.9,
      daysSinceActivity: 1,
      nextAction: 'Continue implementation',
    );

    const blocked = ProjectSignal(
      id: 'blocked',
      title: 'Blocked project',
      importance: 0.8,
      progress: 0.2,
      confidence: 0.3,
      daysSinceActivity: 20,
      blocked: true,
    );

    final healthyResult = assessor.assess(healthy);
    final blockedResult = assessor.assess(blocked);

    expect(healthyResult.health, greaterThan(blockedResult.health));
    expect(healthyResult.risk, lessThan(blockedResult.risk));
    expect(blockedResult.reason, contains('Blocked'));
  });

  test('preserves recommended next action', () {
    const signal = ProjectSignal(
      id: 'perch',
      title: 'Perch',
      importance: 1,
      progress: 0.5,
      confidence: 0.8,
      daysSinceActivity: 0,
      nextAction: 'Run Windows build',
    );

    final result = assessor.assess(signal);

    expect(result.recommendedAction, 'Run Windows build');
    expect(result.health, inInclusiveRange(0, 1));
    expect(result.momentum, inInclusiveRange(0, 1));
    expect(result.risk, inInclusiveRange(0, 1));
  });
}
