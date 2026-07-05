/*
 * Perch Today Field Guide View
 * ----------------------------
 * A page/journal/map/guidebook prototype for the rebuilt Today surface.
 *
 * This view treats Today as an orientation page, not a dashboard.
 */

(function attachPerchTodayFieldGuideView(global) {
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

  function getAttention(section) {
    const top = section && section.data && section.data.top;
    if (!top) return 'No urgent trail marker yet.';
    return top.candidateId.replaceAll('_', ' ');
  }

  function getMoney(section) {
    return section && section.summary ? section.summary : 'Money trail not mapped yet.';
  }

  function getBrain(section) {
    return section && section.summary ? section.summary : 'No notes waiting in the margins.';
  }

  function renderGuideRow(label, value) {
    const row = el('div', { className: 'field-guide-row' });
    row.appendChild(el('span', { className: 'field-guide-label', text: label }));
    row.appendChild(el('span', { className: 'field-guide-value', text: value }));
    return row;
  }

  function renderMarginNote(state) {
    const note = el('aside', { className: 'field-guide-margin-note' });
    note.appendChild(el('p', { className: 'eyebrow', text: 'Margin note' }));

    const source = state.sourceIndicator;
    const sourceText = source && source.label ? source.label : 'Source not labeled yet.';
    note.appendChild(el('p', { text: sourceText }));

    if (state.trustNotice) {
      note.appendChild(el('p', { text: state.trustNotice.label || 'Some details need confirmation.' }));
    }

    return note;
  }

  function renderTodayFieldGuideView(root, state) {
    if (!root) throw new Error('Today field guide view requires a root element.');
    if (!state) throw new Error('Today field guide view requires state.');

    root.innerHTML = '';
    root.className = 'today-field-guide-root';

    const attention = sectionById(state, 'attention');
    const money = sectionById(state, 'money');
    const brain = sectionById(state, 'brain');

    const page = el('article', { className: 'today-field-guide-page' });

    const header = el('header', { className: 'field-guide-header' });
    header.appendChild(el('p', { className: 'eyebrow', text: 'Perch field guide · Today' }));
    header.appendChild(el('h2', { text: state.headline || 'Here is what matters today.' }));
    header.appendChild(el('p', {
      className: 'field-guide-date-line',
      text: 'A page for orienting, not managing everything at once.'
    }));
    page.appendChild(header);

    const map = el('section', { className: 'field-guide-map' });
    map.appendChild(el('p', { className: 'eyebrow', text: 'Today map' }));
    map.appendChild(renderGuideRow('You are here', state.headline || 'Today'));
    map.appendChild(renderGuideRow('First marker', getAttention(attention)));
    map.appendChild(renderGuideRow('Money terrain', getMoney(money)));
    map.appendChild(renderGuideRow('Notes in margin', getBrain(brain)));
    page.appendChild(map);

    const compass = el('section', { className: 'field-guide-compass' });
    compass.appendChild(el('p', { className: 'eyebrow', text: 'Compass' }));
    compass.appendChild(el('p', {
      text: 'Look at the first marker. Everything else is context, not pressure.'
    }));
    page.appendChild(compass);

    page.appendChild(renderMarginNote(state));
    root.appendChild(page);

    return {
      rendered: true,
      mode: 'field-guide',
      metaphor: 'page-journal-map-guidebook',
      dominantOrientationPage: true
    };
  }

  const PerchTodayFieldGuideView = Object.freeze({
    renderTodayFieldGuideView,
    getAttention,
    getMoney,
    getBrain
  });

  global.PerchTodayFieldGuideView = PerchTodayFieldGuideView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayFieldGuideView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
