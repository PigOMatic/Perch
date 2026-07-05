/*
 * Perch Money Domain
 * ------------------
 * First testable domain module extracted for the rebuild.
 *
 * Scope is intentionally small:
 * - calculate bills due before payday
 * - calculate cushion before payday
 *
 * This module does not touch localStorage and does not change restored pages.
 */

(function attachPerchMoney(global) {
  'use strict';

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

  function isOnOrAfter(date, floor) {
    return date && floor && date.getTime() >= floor.getTime();
  }

  function isBefore(date, ceiling) {
    return date && ceiling && date.getTime() < ceiling.getTime();
  }

  function isBillUnpaid(bill) {
    return !bill || bill.paidStatus === undefined || bill.paidStatus === null || bill.paidStatus === 'unpaid' || bill.paidStatus === 'unknown';
  }

  function normalizeAmount(value) {
    const numberValue = Number(value);
    return Number.isFinite(numberValue) ? numberValue : 0;
  }

  function billsBeforePayday(input) {
    const today = parseDateOnly(input && input.today);
    const nextPayday = parseDateOnly(input && input.nextPayday);
    const checkingBalance = normalizeAmount(input && input.checkingBalance);
    const bills = Array.isArray(input && input.bills) ? input.bills : [];

    const includedBills = [];
    const excludedBills = [];

    for (const bill of bills) {
      const dueDate = parseDateOnly(bill && bill.dueDate);
      const include = dueDate && isOnOrAfter(dueDate, today) && isBefore(dueDate, nextPayday) && isBillUnpaid(bill);

      if (include) {
        includedBills.push(bill);
      } else if (bill && bill.id) {
        excludedBills.push(bill.id);
      }
    }

    const billsBeforePaydayTotal = includedBills.reduce((sum, bill) => sum + normalizeAmount(bill.amount), 0);

    return {
      billsBeforePayday: billsBeforePaydayTotal,
      includedBills: includedBills.map((bill) => bill.id).filter(Boolean),
      excludedBills,
      cushionBeforePayday: checkingBalance - billsBeforePaydayTotal,
      classification: 'derived_fact'
    };
  }

  const PerchMoney = Object.freeze({
    parseDateOnly,
    billsBeforePayday
  });

  global.PerchMoney = PerchMoney;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchMoney;
  }
})(typeof window !== 'undefined' ? window : globalThis);
