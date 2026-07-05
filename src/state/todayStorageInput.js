/*
 * Perch Today Storage Input
 * -------------------------
 * Read-only adapter from existing Perch localStorage data into TodayState input.
 *
 * This module must not write, migrate, delete, or rename any stored data.
 */

(function attachPerchTodayStorageInput(global) {
  'use strict';

  function asArray(value) {
    return Array.isArray(value) ? value : [];
  }

  function pickNumber(...values) {
    for (const value of values) {
      const numberValue = Number(value);
      if (Number.isFinite(numberValue)) return numberValue;
    }
    return null;
  }

  function pickString(...values) {
    for (const value of values) {
      if (typeof value === 'string' && value.trim()) return value.trim();
    }
    return null;
  }

  function normalizeBill(rawBill) {
    if (!rawBill || typeof rawBill !== 'object') return null;

    const id = pickString(rawBill.id, rawBill.key, rawBill.name, rawBill.title);
    const name = pickString(rawBill.name, rawBill.title, rawBill.label, id);
    const amount = pickNumber(rawBill.amount, rawBill.dueAmount, rawBill.value);
    const dueDate = pickString(rawBill.dueDate, rawBill.date, rawBill.isoDate, rawBill.nextDueDate);
    const paidStatus = pickString(rawBill.paidStatus, rawBill.status) || 'unknown';

    if (!id || !name || amount === null || !dueDate) return null;

    return {
      id,
      name,
      amount,
      dueDate,
      paidStatus
    };
  }

  function normalizeCapture(rawCapture) {
    if (!rawCapture || typeof rawCapture !== 'object') return null;
    const rawText = pickString(rawCapture.rawText, rawCapture.text, rawCapture.title, rawCapture.body);
    if (!rawText) return null;
    return { rawText };
  }

  function extractBills(paydayCard, memory) {
    const candidates = [
      paydayCard && paydayCard.bills,
      paydayCard && paydayCard.billList,
      memory && memory.bills,
      memory && memory.basics && memory.basics.bills
    ];

    return candidates
      .flatMap(asArray)
      .map(normalizeBill)
      .filter(Boolean);
  }

  function extractCaptures(memory, noticed) {
    const candidates = [
      memory && memory.captures,
      memory && memory.inbox,
      memory && memory.brain && memory.brain.captures,
      noticed && noticed.items,
      noticed && noticed.captures
    ];

    return candidates
      .flatMap(asArray)
      .map(normalizeCapture)
      .filter(Boolean);
  }

  function sourceStatus(parts) {
    const usedStorage = parts.some(Boolean);
    const usedFallback = parts.some((used) => !used);

    if (usedStorage && usedFallback) return 'mixed';
    if (usedStorage) return 'browser-storage';
    return 'sample-fallback';
  }

  function buildTodayInputFromStorageSnapshot(snapshot, fallbackInput = {}) {
    const memory = snapshot && snapshot.memory;
    const paydayCard = snapshot && snapshot.paydayCard;
    const recommendationPrefs = snapshot && snapshot.recommendationPrefs;
    const noticed = snapshot && snapshot.noticed;

    const storedCheckingBalance = pickNumber(
      paydayCard && paydayCard.checkingBalance,
      paydayCard && paydayCard.balance,
      memory && memory.checkingBalance,
      memory && memory.basics && memory.basics.checkingBalance
    );

    const storedNextPayday = pickString(
      paydayCard && paydayCard.nextPayday,
      paydayCard && paydayCard.payday,
      memory && memory.nextPayday,
      memory && memory.basics && memory.basics.nextPayday
    );

    const checkingBalance = storedCheckingBalance === null
      ? pickNumber(fallbackInput.money && fallbackInput.money.checkingBalance)
      : storedCheckingBalance;

    const nextPayday = storedNextPayday || pickString(fallbackInput.money && fallbackInput.money.nextPayday);
    const bills = extractBills(paydayCard, memory);
    const captures = extractCaptures(memory, noticed);

    const moneyFromStorage = storedCheckingBalance !== null || Boolean(storedNextPayday) || bills.length > 0;
    const capturesFromStorage = captures.length > 0;
    const recommendationsFromStorage = Boolean(recommendationPrefs);
    const source = sourceStatus([moneyFromStorage, capturesFromStorage, recommendationsFromStorage]);

    const todayInput = {
      ...fallbackInput,
      money: {
        ...(fallbackInput.money || {}),
        checkingBalance: checkingBalance === null ? undefined : checkingBalance,
        nextPayday: nextPayday || undefined,
        bills: bills.length ? bills : asArray(fallbackInput.money && fallbackInput.money.bills)
      },
      captures: captures.length ? captures : asArray(fallbackInput.captures),
      recommendation: {
        ...(fallbackInput.recommendation || {}),
        preferences: recommendationPrefs || (fallbackInput.recommendation && fallbackInput.recommendation.preferences) || {}
      },
      sourceIndicator: {
        source,
        mode: 'read-only',
        label: source === 'browser-storage'
          ? 'Using browser storage'
          : source === 'mixed'
            ? 'Using browser storage with sample fallback'
            : 'Using sample data',
        details: {
          moneyFromStorage,
          capturesFromStorage,
          recommendationsFromStorage
        }
      },
      storageRead: {
        mode: 'read-only',
        source: 'localStorage-adapter',
        wroteData: false,
        migratedData: false
      }
    };

    return todayInput;
  }

  function buildTodayInputFromStorage(storageApi, fallbackInput = {}) {
    const api = storageApi || global.PerchStorage;
    if (!api || typeof api.readKnownJson !== 'function') {
      return buildTodayInputFromStorageSnapshot({}, fallbackInput);
    }

    return buildTodayInputFromStorageSnapshot(api.readKnownJson(), fallbackInput);
  }

  const PerchTodayStorageInput = Object.freeze({
    buildTodayInputFromStorage,
    buildTodayInputFromStorageSnapshot,
    normalizeBill,
    normalizeCapture
  });

  global.PerchTodayStorageInput = PerchTodayStorageInput;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStorageInput;
  }
})(typeof window !== 'undefined' ? window : globalThis);
