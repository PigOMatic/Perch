/*
 * Perch Capture Domain
 * --------------------
 * First testable capture module extracted for the rebuild.
 *
 * Scope is intentionally small:
 * - basic reminder parsing
 * - basic waiting-item parsing
 *
 * This module does not touch localStorage and does not change restored pages.
 */

(function attachPerchCapture(global) {
  'use strict';

  function normalizeText(rawText) {
    return String(rawText || '').trim();
  }

  function parseDateHint(rawText, today) {
    const text = normalizeText(rawText).toLowerCase();
    const base = parseDateOnly(today);
    if (!base) return null;

    if (text.includes('tomorrow')) {
      const date = new Date(base.getTime());
      date.setUTCDate(date.getUTCDate() + 1);
      return formatDateOnly(date);
    }

    if (text.includes('today')) {
      return formatDateOnly(base);
    }

    return null;
  }

  function parseDateOnly(value) {
    if (!value || typeof value !== 'string') return null;
    const match = value.match(/^(\d{4})-(\d{2})-(\d{2})/);
    if (!match) return null;

    const year = Number(match[1]);
    const month = Number(match[2]) - 1;
    const day = Number(match[3]);
    const date = new Date(Date.UTC(year, month, day));

    if (Number.isNaN(date.getTime())) return null;
    return date;
  }

  function formatDateOnly(date) {
    const year = date.getUTCFullYear();
    const month = String(date.getUTCMonth() + 1).padStart(2, '0');
    const day = String(date.getUTCDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  function parseTimeHint(rawText) {
    const text = normalizeText(rawText).toLowerCase();
    const match = text.match(/\b(1[0-2]|0?[1-9])(?::([0-5][0-9]))?\s*(am|pm)\b/);
    if (!match) return null;

    let hour = Number(match[1]);
    const minute = match[2] ? Number(match[2]) : 0;
    const meridian = match[3];

    if (meridian === 'pm' && hour !== 12) hour += 12;
    if (meridian === 'am' && hour === 12) hour = 0;

    return `${String(hour).padStart(2, '0')}:${String(minute).padStart(2, '0')}`;
  }

  function parseWaitingPerson(rawText) {
    const text = normalizeText(rawText);
    const match = text.match(/waiting\s+on\s+([A-Z][a-zA-Z'-]*)/);
    return match ? match[1] : null;
  }

  function titleWords(rawText) {
    const text = normalizeText(rawText).toLowerCase();
    return text
      .replace(/^remind me to\s+/, '')
      .replace(/^waiting on\s+[a-zA-Z'-]+\s+to\s+/, '')
      .split(/\s+/)
      .filter(Boolean);
  }

  function parseCapture(input) {
    const rawText = normalizeText(input && input.rawText);
    const text = rawText.toLowerCase();
    const today = input && input.today;

    if (text.startsWith('waiting on ')) {
      return {
        parsedType: 'waiting',
        personHint: parseWaitingPerson(rawText),
        titleWords: titleWords(rawText),
        lifecycle: 'active',
        completionAction: 'arrived_or_done',
        classification: 'stored_record'
      };
    }

    if (text.startsWith('remind me to ') || text.startsWith('remind me ')) {
      return {
        parsedType: 'reminder',
        titleWords: titleWords(rawText),
        dueDate: parseDateHint(rawText, today),
        timeHint: parseTimeHint(rawText),
        lifecycle: 'active',
        classification: 'stored_record'
      };
    }

    return {
      parsedType: 'unknown',
      titleWords: titleWords(rawText),
      lifecycle: 'active',
      classification: 'stored_record'
    };
  }

  const PerchCapture = Object.freeze({
    parseCapture,
    parseDateHint,
    parseTimeHint,
    parseWaitingPerson
  });

  global.PerchCapture = PerchCapture;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchCapture;
  }
})(typeof window !== 'undefined' ? window : globalThis);
