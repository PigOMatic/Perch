/*
 * Perch Priority Engine
 * ---------------------
 * First testable priority module extracted for the rebuild.
 *
 * Scope is intentionally small:
 * - rank existing candidates
 * - urgent money risk should outrank a low-consequence task
 *
 * Priority ranks attention. It does not create facts or recommendations.
 */

(function attachPerchPriority(global) {
  'use strict';

  const DOMAIN_WEIGHTS = Object.freeze({
    money: 40,
    calendar: 25,
    obligation: 25,
    health: 20,
    project: 10,
    brain: 10,
    unknown: 0
  });

  const URGENCY_WEIGHTS = Object.freeze({
    due_before_payday: 40,
    low_cushion: 35,
    due_today: 30,
    due_tomorrow: 20,
    overdue: 45
  });

  const CONSEQUENCE_WEIGHTS = Object.freeze({
    missed_bill_risk: 40,
    financial_risk: 35,
    health_risk: 30,
    family_impact: 20,
    medium: 10,
    low: 0
  });

  function weightFromList(signals, weights) {
    if (!Array.isArray(signals)) return 0;
    return signals.reduce((sum, signal) => sum + (weights[signal] || 0), 0);
  }

  function scoreCandidate(candidate) {
    if (!candidate || typeof candidate !== 'object') return 0;

    const domain = candidate.domain || 'unknown';
    const domainScore = DOMAIN_WEIGHTS[domain] || 0;
    const urgencyScore = weightFromList(candidate.urgencySignals, URGENCY_WEIGHTS);
    const consequenceScore = weightFromList(candidate.consequenceSignals, CONSEQUENCE_WEIGHTS);

    return domainScore + urgencyScore + consequenceScore;
  }

  function reasonsFor(candidate) {
    const reasons = [];
    if (!candidate || typeof candidate !== 'object') return reasons;

    if (candidate.domain) reasons.push(`domain:${candidate.domain}`);

    if (Array.isArray(candidate.urgencySignals)) {
      candidate.urgencySignals.forEach((signal) => reasons.push(signal));
    }

    if (Array.isArray(candidate.consequenceSignals)) {
      candidate.consequenceSignals.forEach((signal) => reasons.push(signal));
    }

    return reasons;
  }

  function rankCandidates(input) {
    const candidates = Array.isArray(input && input.candidates) ? input.candidates : [];

    const ordered = candidates
      .map((candidate, index) => ({
        candidateId: candidate.id,
        score: scoreCandidate(candidate),
        reasons: reasonsFor(candidate),
        truthStatus: 'allowed',
        originalIndex: index
      }))
      .sort((a, b) => {
        if (b.score !== a.score) return b.score - a.score;
        return a.originalIndex - b.originalIndex;
      })
      .map(({ originalIndex, ...item }) => item);

    return {
      ordered,
      top: ordered[0] || null,
      explanation: ordered[0] ? `Top item selected by score ${ordered[0].score}.` : 'No priority candidates.'
    };
  }

  const PerchPriority = Object.freeze({
    scoreCandidate,
    rankCandidates
  });

  global.PerchPriority = PerchPriority;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchPriority;
  }
})(typeof window !== 'undefined' ? window : globalThis);
