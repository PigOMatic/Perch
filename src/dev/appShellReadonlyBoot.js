/*
 * Perch App Shell Read-Only Boot
 * ------------------------------
 * Preview boot that reads existing Perch localStorage through the storage adapter.
 *
 * It falls back to dev sample data when storage is empty or incomplete.
 */

(function bootPerchReadonlyPreview(global) {
  'use strict';

  function boot() {
    const shellRoot = document.getElementById('perch-shell');
    global.PerchShell.renderShell(shellRoot, {
      activeRouteId: 'today'
    });

    const pageHost = shellRoot.querySelector('.perch-page-placeholder');
    const input = global.PerchTodayStorageInput.buildTodayInputFromStorage(
      global.PerchStorage,
      global.PerchTodaySampleData
    );
    const todayState = global.PerchTodayState.buildTodayState(input);
    global.PerchTodayView.renderTodayView(pageHost, todayState);

    if (global.PerchStorageDebugDrawer) {
      global.PerchStorageDebugDrawer.renderStorageDebugDrawer(pageHost, input);
    }
  }

  global.PerchAppShellReadonlyBoot = Object.freeze({ boot });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})(typeof window !== 'undefined' ? window : globalThis);
