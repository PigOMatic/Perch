/*
 * Perch Routes
 * ------------
 * Target route registry for the rebuilt app shell.
 *
 * This file does not replace the restored HTML pages yet.
 */

(function attachPerchRoutes(global) {
  'use strict';

  const routes = Object.freeze([
    {
      id: 'today',
      label: 'Today',
      path: '/today',
      legacyFile: 'perch_today_live.html',
      chapterIds: ['01-today'],
      status: 'planned-rebuild'
    },
    {
      id: 'week',
      label: 'Week',
      path: '/week',
      legacyFile: 'perch_week_live.html',
      chapterIds: ['03-calendar-obligations'],
      status: 'planned-rebuild'
    },
    {
      id: 'month',
      label: 'Month',
      path: '/month',
      legacyFile: 'perch_month_live.html',
      chapterIds: ['03-calendar-obligations', '02-money'],
      status: 'planned-rebuild'
    },
    {
      id: 'capture',
      label: 'Capture',
      path: '/capture',
      legacyFile: 'perch_capture.html',
      chapterIds: ['06-brain'],
      status: 'planned-rebuild'
    },
    {
      id: 'life',
      label: 'Life',
      path: '/life',
      legacyFile: 'perch_life.html',
      chapterIds: ['04-goals', '05-projects'],
      status: 'planned-rebuild'
    },
    {
      id: 'knowledge',
      label: 'Knowledge',
      path: '/knowledge',
      legacyFile: 'perch_memory_explorer.html',
      chapterIds: ['12-knowledge-search', '17-people'],
      status: 'planned-rebuild'
    },
    {
      id: 'settings',
      label: 'Settings',
      path: '/settings',
      legacyFile: 'perch_settings.html',
      chapterIds: ['settings', '07-truth-engine'],
      status: 'planned-rebuild'
    }
  ]);

  function getRoutes() {
    return routes.slice();
  }

  function findRoute(id) {
    return routes.find((route) => route.id === id) || null;
  }

  const PerchRoutes = Object.freeze({
    getRoutes,
    findRoute
  });

  global.PerchRoutes = PerchRoutes;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchRoutes;
  }
})(typeof window !== 'undefined' ? window : globalThis);
