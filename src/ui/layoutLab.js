/*
 * Perch Layout Lab
 * ----------------
 * Compares the same Today state across multiple surface arrangements.
 *
 * This is a design/anatomy lab, not a production surface.
 */

(function attachPerchLayoutLab(global) {
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

  function sectionById(state, id) {
    return (state.sections || []).find((section) => section.id === id) || null;
  }

  function summarizeState(state) {
    const attention = sectionById(state, 'attention');
    const money = sectionById(state, 'money');
    const brain = sectionById(state, 'brain');
    const top = attention && attention.data && attention.data.top;

    return {
      orientation: state.headline || 'Here is what matters today.',
      primaryMarker: top ? top.candidateId.replaceAll('_', ' ') : 'No urgent marker',
      terrain: money && money.summary ? money.summary : 'Money terrain not mapped yet.',
      marginNotes: brain && brain.summary ? brain.summary : 'No margin notes yet.',
      trustSource: state.sourceIndicator && state.sourceIndicator.label ? state.sourceIndicator.label : 'Source not labeled yet.',
      nextStep: 'Look at the first marker. Everything else is context.',
      canWait: 'Anything not on this page can stay quiet for now.'
    };
  }

  function roleLine(label, value) {
    const row = el('div', { className: 'lab-role-line' });
    row.appendChild(el('span', { className: 'lab-role-label', text: label }));
    row.appendChild(el('span', { className: 'lab-role-value', text: value }));
    return row;
  }

  function renderFieldGuide(data) {
    const surface = el('section', { className: 'layout-surface layout-field-guide' });
    surface.appendChild(el('p', { className: 'eyebrow', text: 'Surface A · Field guide page' }));
    surface.appendChild(el('h3', { text: data.orientation }));
    surface.appendChild(roleLine('First marker', data.primaryMarker));
    surface.appendChild(roleLine('Terrain', data.terrain));
    surface.appendChild(roleLine('Margin', data.marginNotes));
    surface.appendChild(roleLine('Source', data.trustSource));
    surface.appendChild(el('p', { className: 'lab-next-step', text: data.nextStep }));
    return surface;
  }

  function renderFoldedMap(data) {
    const surface = el('section', { className: 'layout-surface layout-folded-map' });
    surface.appendChild(el('p', { className: 'eyebrow', text: 'Surface B · Folded map' }));
    const grid = el('div', { className: 'map-fold-grid' });
    grid.appendChild(roleLine('You are here', data.orientation));
    grid.appendChild(roleLine('Marker', data.primaryMarker));
    grid.appendChild(roleLine('Terrain', data.terrain));
    grid.appendChild(roleLine('Legend', data.trustSource));
    surface.appendChild(grid);
    surface.appendChild(el('p', { className: 'lab-can-wait', text: data.canWait }));
    return surface;
  }

  function renderJournalSpread(data) {
    const surface = el('section', { className: 'layout-surface layout-journal-spread' });
    surface.appendChild(el('p', { className: 'eyebrow', text: 'Surface C · Journal spread' }));
    const spread = el('div', { className: 'journal-spread-grid' });
    const left = el('div', { className: 'journal-page-left' });
    left.appendChild(el('h3', { text: data.orientation }));
    left.appendChild(el('p', { text: data.primaryMarker }));
    const right = el('div', { className: 'journal-page-right' });
    right.appendChild(roleLine('Terrain', data.terrain));
    right.appendChild(roleLine('Margin note', data.marginNotes));
    right.appendChild(roleLine('Can wait', data.canWait));
    spread.appendChild(left);
    spread.appendChild(right);
    surface.appendChild(spread);
    return surface;
  }

  function renderGuidebookEntry(data) {
    const surface = el('section', { className: 'layout-surface layout-guidebook-entry' });
    surface.appendChild(el('p', { className: 'eyebrow', text: 'Surface D · Guidebook entry' }));
    surface.appendChild(el('h3', { text: data.orientation }));
    surface.appendChild(roleLine('Route advice', data.nextStep));
    surface.appendChild(roleLine('Primary field note', data.primaryMarker));
    surface.appendChild(roleLine('Known terrain', data.terrain));
    surface.appendChild(roleLine('Footnote', data.trustSource));
    return surface;
  }

  function renderMobilePocket(data) {
    const surface = el('section', { className: 'layout-surface layout-mobile-pocket' });
    surface.appendChild(el('p', { className: 'eyebrow', text: 'Surface E · Mobile pocket page' }));
    surface.appendChild(el('h3', { text: data.orientation }));
    surface.appendChild(el('p', { className: 'mobile-primary', text: data.primaryMarker }));
    surface.appendChild(roleLine('Context', data.terrain));
    surface.appendChild(roleLine('Source', data.trustSource));
    return surface;
  }

  function renderLayoutLab(root, state) {
    if (!root) throw new Error('Layout lab requires a root element.');
    if (!state) throw new Error('Layout lab requires state.');

    root.innerHTML = '';
    root.className = 'layout-lab-root';

    const data = summarizeState(state);
    const intro = el('section', { className: 'layout-lab-intro' });
    intro.appendChild(el('p', { className: 'eyebrow', text: 'Perch layout lab' }));
    intro.appendChild(el('h2', { text: 'Same meaning, different surfaces.' }));
    intro.appendChild(el('p', { text: 'This lab compares the same Today data across page, map, journal, guidebook, and mobile arrangements.' }));
    root.appendChild(intro);

    const grid = el('div', { className: 'layout-lab-grid' });
    grid.appendChild(renderFieldGuide(data));
    grid.appendChild(renderFoldedMap(data));
    grid.appendChild(renderJournalSpread(data));
    grid.appendChild(renderGuidebookEntry(data));
    grid.appendChild(renderMobilePocket(data));
    root.appendChild(grid);

    return {
      rendered: true,
      surfaceCount: 5,
      sameMeaningDifferentSurface: true
    };
  }

  const PerchLayoutLab = Object.freeze({
    renderLayoutLab,
    summarizeState
  });

  global.PerchLayoutLab = PerchLayoutLab;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchLayoutLab;
  }
})(typeof window !== 'undefined' ? window : globalThis);
