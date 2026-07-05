/*
 * Perch Daily Intro
 * -----------------
 * A once-per-day opening moment for Perch surfaces.
 *
 * It is intentionally light: show briefly, fade away, remember today's date.
 */

(function attachPerchDailyIntro(global) {
  'use strict';

  const STORAGE_KEY = 'perch_daily_intro_seen_date';

  function todayKey(date = new Date()) {
    return date.toISOString().slice(0, 10);
  }

  function shouldShow(storage = global.localStorage, date = new Date()) {
    if (!storage) return true;
    try {
      return storage.getItem(STORAGE_KEY) !== todayKey(date);
    } catch (error) {
      return true;
    }
  }

  function markSeen(storage = global.localStorage, date = new Date()) {
    if (!storage) return false;
    try {
      storage.setItem(STORAGE_KEY, todayKey(date));
      return true;
    } catch (error) {
      return false;
    }
  }

  function el(tag, options = {}) {
    const node = document.createElement(tag);
    if (options.className) node.className = options.className;
    if (options.text) node.textContent = options.text;
    if (options.attrs) {
      Object.entries(options.attrs).forEach(([key, value]) => node.setAttribute(key, value));
    }
    return node;
  }

  function removeOverlay(overlay) {
    if (!overlay || !overlay.parentNode) return;
    overlay.classList.add('perch-daily-intro-leaving');
    setTimeout(() => {
      if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
    }, 520);
  }

  function show(options = {}) {
    const storage = options.storage || global.localStorage;
    const date = options.date || new Date();
    const force = Boolean(options.force);
    const durationMs = Number.isFinite(options.durationMs) ? options.durationMs : 2200;

    if (!force && !shouldShow(storage, date)) {
      return { shown: false, reason: 'already-seen-today' };
    }

    const overlay = el('div', {
      className: 'perch-daily-intro',
      attrs: {
        role: 'status',
        'aria-live': 'polite'
      }
    });

    const panel = el('div', { className: 'perch-daily-intro-panel' });
    panel.appendChild(el('p', { className: 'perch-daily-intro-kicker', text: 'Perch' }));
    panel.appendChild(el('h2', { text: 'Beautifully designed.' }));
    panel.appendChild(el('p', {
      className: 'perch-daily-intro-line',
      text: 'Opening today\'s page.'
    }));
    overlay.appendChild(panel);

    document.body.appendChild(overlay);
    markSeen(storage, date);

    setTimeout(() => removeOverlay(overlay), durationMs);

    return {
      shown: true,
      storageKey: STORAGE_KEY,
      date: todayKey(date)
    };
  }

  const PerchDailyIntro = Object.freeze({
    STORAGE_KEY,
    todayKey,
    shouldShow,
    markSeen,
    show
  });

  global.PerchDailyIntro = PerchDailyIntro;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchDailyIntro;
  }
})(typeof window !== 'undefined' ? window : globalThis);
