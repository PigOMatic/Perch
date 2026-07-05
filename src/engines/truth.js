/*
 * Perch Truth Engine
 * ------------------
 * First testable truth module extracted for the rebuild.
 *
 * Scope is intentionally small:
 * - label stale/manual data as limited certainty
 * - prevent stale manual data from being shown as certain
 */

(function attachPerchTruth(global) {
  'use strict';

  const STALE_DAYS = 7;

  function parseDate(value) {
    if (!value || typeof value !== 'string') return null;
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? null : date;
  }

  function daysBetween(later, earlier) {
    if (!later || !earlier) return null;
    const ms = later.getTime() - earlier.getTime();
    return Math.floor(ms / (1000 * 60 * 60 * 24));
  }

  function evaluateStatement(input) {
    const today = parseDate(input && input.today);
    const source = input && input.source;

    if (!source) {
      return {
        truthStatus: 'blocked',
        requiredLabel: 'No source available',
        shouldShowAsCertain: false,
        trustNoticeSeverity: 'blocked'
      };
    }

    const sourceDate = parseDate(source.timestamp);
    const ageDays = daysBetween(today || new Date(), sourceDate);
    const isManual = source.type === 'manual_entry';
    const lowConfidence = typeof source.confidence === 'number' && source.confidence < 0.7;
    const stale = ageDays !== null && ageDays > STALE_DAYS;

    if (isManual && (stale || lowConfidence)) {
      return {
        truthStatus: 'limited',
        requiredLabel: 'Based on your last manual balance',
        shouldShowAsCertain: false,
        trustNoticeSeverity: 'warning'
      };
    }

    return {
      truthStatus: 'allowed',
      requiredLabel: null,
      shouldShowAsCertain: true,
      trustNoticeSeverity: 'info'
    };
  }

  const PerchTruth = Object.freeze({
    evaluateStatement
  });

  global.PerchTruth = PerchTruth;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTruth;
  }
})(typeof window !== 'undefined' ? window : globalThis);
