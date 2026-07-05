/*
 * Perch Recommendation Engine
 * ---------------------------
 * First testable recommendation module extracted for the rebuild.
 *
 * Scope is intentionally small:
 * - suppress recommendations the user has suppressed
 * - do not auto-act
 */

(function attachPerchRecommendation(global) {
  'use strict';

  function suppressedIds(preferences) {
    if (!preferences || typeof preferences !== 'object') return [];
    return Array.isArray(preferences.suppressedRecommendationIds)
      ? preferences.suppressedRecommendationIds
      : [];
  }

  function evaluateRecommendation(input) {
    const recommendation = input && input.candidateRecommendation;
    const preferences = input && input.preferences;
    const suppressed = recommendation && suppressedIds(preferences).includes(recommendation.id);

    if (!recommendation) {
      return {
        shouldShow: false,
        suppressed: false,
        suppressionReason: 'missing_recommendation',
        userActionRequired: true
      };
    }

    if (suppressed) {
      return {
        id: recommendation.id,
        shouldShow: false,
        suppressed: true,
        suppressionReason: 'user_suppressed',
        userActionRequired: true
      };
    }

    return {
      id: recommendation.id,
      shouldShow: true,
      suppressed: false,
      suppressionReason: null,
      userActionRequired: true
    };
  }

  function filterRecommendations(input) {
    const candidates = Array.isArray(input && input.recommendations) ? input.recommendations : [];
    const preferences = input && input.preferences;

    const visible = [];
    const suppressed = [];

    candidates.forEach((candidateRecommendation) => {
      const result = evaluateRecommendation({ candidateRecommendation, preferences });
      if (result.shouldShow) {
        visible.push(candidateRecommendation);
      } else {
        suppressed.push(result);
      }
    });

    return { visible, suppressed };
  }

  const PerchRecommendation = Object.freeze({
    evaluateRecommendation,
    filterRecommendations
  });

  global.PerchRecommendation = PerchRecommendation;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchRecommendation;
  }
})(typeof window !== 'undefined' ? window : globalThis);
