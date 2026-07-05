/*
 * Perch Storage Adapter
 * ---------------------
 * Purpose: provide a safe wrapper around localStorage without changing any
 * existing Perch storage keys.
 *
 * This file is intentionally not wired into the restored HTML pages yet.
 * It is a compatibility layer for the rebuild.
 */

(function attachPerchStorage(global) {
  'use strict';

  const STORAGE_KEYS = Object.freeze({
    memory: 'perch_memory_v1',
    paydayCard: 'perch_payday_card',
    recommendationPrefs: 'perch_rec_prefs',
    behaviorPrefs: 'perch_behavior_prefs',
    quickAnswerPrefs: 'perch_quick_answer_prefs',
    goalQuestions: 'perch_goal_qs',
    noticed: 'perch_noticed_v1',
    changesSnapshot: 'perch_changes_snap',
    goalUpdated: 'perch_goal_updated',
    suggestionPrefs: 'perch_sug_prefs'
  });

  function hasLocalStorage() {
    try {
      return typeof global.localStorage !== 'undefined' && global.localStorage !== null;
    } catch (error) {
      return false;
    }
  }

  function safeParse(raw, fallback) {
    if (raw === null || raw === undefined || raw === '') return fallback;
    try {
      return JSON.parse(raw);
    } catch (error) {
      return fallback;
    }
  }

  function safeStringify(value) {
    try {
      return JSON.stringify(value);
    } catch (error) {
      return null;
    }
  }

  function getRaw(key, fallback = null) {
    if (!hasLocalStorage()) return fallback;
    try {
      const value = global.localStorage.getItem(key);
      return value === null ? fallback : value;
    } catch (error) {
      return fallback;
    }
  }

  function setRaw(key, value) {
    if (!hasLocalStorage()) return false;
    try {
      global.localStorage.setItem(key, String(value));
      return true;
    } catch (error) {
      return false;
    }
  }

  function getJson(key, fallback = null) {
    return safeParse(getRaw(key, null), fallback);
  }

  function setJson(key, value) {
    const serialized = safeStringify(value);
    if (serialized === null) return false;
    return setRaw(key, serialized);
  }

  function remove(key) {
    if (!hasLocalStorage()) return false;
    try {
      global.localStorage.removeItem(key);
      return true;
    } catch (error) {
      return false;
    }
  }

  function exists(key) {
    if (!hasLocalStorage()) return false;
    try {
      return global.localStorage.getItem(key) !== null;
    } catch (error) {
      return false;
    }
  }

  function snapshot(keys = Object.values(STORAGE_KEYS)) {
    const out = {};
    keys.forEach((key) => {
      out[key] = getRaw(key, null);
    });
    return out;
  }

  function readKnownJson() {
    return {
      memory: getJson(STORAGE_KEYS.memory, null),
      paydayCard: getJson(STORAGE_KEYS.paydayCard, null),
      recommendationPrefs: getJson(STORAGE_KEYS.recommendationPrefs, null),
      behaviorPrefs: getJson(STORAGE_KEYS.behaviorPrefs, null),
      quickAnswerPrefs: getJson(STORAGE_KEYS.quickAnswerPrefs, null),
      goalQuestions: getJson(STORAGE_KEYS.goalQuestions, null),
      noticed: getJson(STORAGE_KEYS.noticed, null),
      changesSnapshot: getJson(STORAGE_KEYS.changesSnapshot, null),
      goalUpdated: getRaw(STORAGE_KEYS.goalUpdated, null),
      suggestionPrefs: getJson(STORAGE_KEYS.suggestionPrefs, null)
    };
  }

  const PerchStorage = Object.freeze({
    keys: STORAGE_KEYS,
    hasLocalStorage,
    getRaw,
    setRaw,
    getJson,
    setJson,
    remove,
    exists,
    snapshot,
    readKnownJson,
    safeParse,
    safeStringify
  });

  global.PerchStorage = PerchStorage;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchStorage;
  }
})(typeof window !== 'undefined' ? window : globalThis);
