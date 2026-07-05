/*
 * Perch Today State
 * -----------------
 * First PageState builder for the rebuilt Today surface.
 *
 * This module does not touch the DOM and does not replace the legacy Today page.
 */

(function attachPerchTodayState(global) {
  'use strict';

  function asArray(value) {
    return Array.isArray(value) ? value : [];
  }

  function buildMoneySection(input) {
    const money = global.PerchMoney;
    if (!money || !input || !input.money) return null;

    const result = money.billsBeforePayday({
      today: input.today,
      checkingBalance: input.money.checkingBalance,
      nextPayday: input.money.nextPayday,
      bills: input.money.bills
    });

    return {
      id: 'money',
      title: 'Money before payday',
      classification: result.classification,
      summary: `$${result.billsBeforePayday} due before payday. Cushion: $${result.cushionBeforePayday}.`,
      data: result,
      trust: input.money.trust || null
    };
  }

  function buildCaptureSection(input) {
    const capture = global.PerchCapture;
    const captures = asArray(input && input.captures);
    if (!capture || captures.length === 0) return null;

    const parsed = captures.map((item) => capture.parseCapture({
      today: input.today,
      rawText: item.rawText || item.text || ''
    }));

    return {
      id: 'brain',
      title: 'From your brain',
      summary: `${parsed.length} captured item${parsed.length === 1 ? '' : 's'} ready to review.`,
      items: parsed
    };
  }

  function buildPrioritySection(input) {
    const priority = global.PerchPriority;
    const candidates = asArray(input && input.priorityCandidates);
    if (!priority || candidates.length === 0) return null;

    const result = priority.rankCandidates({ candidates });

    return {
      id: 'attention',
      title: 'Needs attention',
      summary: result.top ? result.top.candidateId : 'Nothing needs attention.',
      data: result
    };
  }

  function buildRecommendationSection(input) {
    const recommendation = global.PerchRecommendation;
    if (!recommendation || !input || !input.recommendation) return null;

    const result = recommendation.evaluateRecommendation({
      candidateRecommendation: input.recommendation.candidateRecommendation,
      preferences: input.recommendation.preferences
    });

    return {
      id: 'recommendation',
      title: 'Suggestion',
      summary: result.shouldShow ? 'A suggestion is available.' : 'No suggestion is shown.',
      data: result
    };
  }

  function buildTrustNotice(input) {
    const truth = global.PerchTruth;
    if (!truth || !input || !input.trustStatement) return null;

    const result = truth.evaluateStatement({
      today: input.today,
      statement: input.trustStatement.statement,
      source: input.trustStatement.source
    });

    if (result.truthStatus === 'allowed') return null;

    return {
      id: 'trust-notice',
      title: 'Trust note',
      label: result.requiredLabel,
      severity: result.trustNoticeSeverity,
      truthStatus: result.truthStatus
    };
  }

  function buildTodayState(input = {}) {
    const sections = [
      buildPrioritySection(input),
      buildMoneySection(input),
      buildCaptureSection(input),
      buildRecommendationSection(input)
    ].filter(Boolean);

    const trustNotice = buildTrustNotice(input);

    return {
      pageId: 'today',
      mode: 'read',
      headline: input.headline || 'Here is what matters today.',
      generatedAt: input.generatedAt || new Date().toISOString(),
      sourceIndicator: input.sourceIndicator || null,
      sections,
      trustNotice,
      legacyFallback: 'perch_today_live.html'
    };
  }

  const PerchTodayState = Object.freeze({
    buildTodayState
  });

  global.PerchTodayState = PerchTodayState;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayState;
  }
})(typeof window !== 'undefined' ? window : globalThis);
