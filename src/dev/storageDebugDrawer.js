/*
 * Perch Storage Debug Drawer
 * --------------------------
 * Development-only drawer for the read-only Today preview.
 *
 * This module must not write, migrate, delete, or rename storage data.
 */

(function attachPerchStorageDebugDrawer(global) {
  'use strict';

  function el(tag, options = {}) {
    const node = document.createElement(tag);
    if (options.className) node.className = options.className;
    if (options.text) node.textContent = options.text;
    if (options.attrs) {
      Object.entries(options.attrs).forEach(([key, value]) => node.setAttribute(key, value));
    }
    return node;
  }

  function yesNo(value) {
    return value ? 'yes' : 'no';
  }

  function summarizeInput(input) {
    const source = input && input.sourceIndicator;
    const storageRead = input && input.storageRead;
    const details = (source && source.details) || {};

    return [
      ['Source', source && source.label ? source.label : 'Unknown'],
      ['Mode', storageRead && storageRead.mode ? storageRead.mode : 'unknown'],
      ['Money from storage', yesNo(details.moneyFromStorage)],
      ['Captures from storage', yesNo(details.capturesFromStorage)],
      ['Recommendations from storage', yesNo(details.recommendationsFromStorage)],
      ['Wrote data', yesNo(storageRead && storageRead.wroteData)],
      ['Migrated data', yesNo(storageRead && storageRead.migratedData)]
    ];
  }

  function renderStorageDebugDrawer(root, input) {
    if (!root) return null;

    const drawer = el('details', { className: 'storage-debug-drawer' });
    drawer.appendChild(el('summary', { text: 'Storage debug' }));

    const intro = el('p', {
      text: 'Read-only preview details. This panel shows what Perch used and confirms no storage write or migration happened.'
    });
    drawer.appendChild(intro);

    const list = el('dl');
    summarizeInput(input).forEach(([label, value]) => {
      list.appendChild(el('dt', { text: label }));
      list.appendChild(el('dd', { text: value }));
    });
    drawer.appendChild(list);

    root.appendChild(drawer);
    return drawer;
  }

  const PerchStorageDebugDrawer = Object.freeze({
    renderStorageDebugDrawer,
    summarizeInput
  });

  global.PerchStorageDebugDrawer = PerchStorageDebugDrawer;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchStorageDebugDrawer;
  }
})(typeof window !== 'undefined' ? window : globalThis);
