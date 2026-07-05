/*
 * Perch App Shell Preview Boot
 * ----------------------------
 * Keeps app_shell_preview.html thin while the rebuilt Today surface matures.
 */

(function bootPerchAppShellPreview(global) {
  'use strict';

  function boot() {
    const shellRoot = document.getElementById('perch-shell');
    global.PerchShell.renderShell(shellRoot, {
      activeRouteId: 'today'
    });

    const pageHost = shellRoot.querySelector('.perch-page-placeholder');
    const todayState = global.PerchTodayState.buildTodayState(global.PerchTodaySampleData);
    global.PerchTodayView.renderTodayView(pageHost, todayState);
  }

  global.PerchAppShellPreviewBoot = Object.freeze({ boot });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})(typeof window !== 'undefined' ? window : globalThis);
