/*
 * Perch Today View
 * ----------------
 * First visible rebuilt Today surface.
 *
 * This renderer consumes Today PageState and renders a calm read-mode surface.
 * It does not replace the legacy Today page.
 */

(function attachPerchTodayView(global) {
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

  function renderTrustNotice(notice) {
    if (!notice) return null;

    const card = el('aside', { className: `today-trust-note ${notice.severity || ''}`.trim() });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Trust note' }));
    card.appendChild(el('p', { text: notice.label || 'Some information may need confirmation.' }));
    return card;
  }

  function renderHero(state) {
    const hero = el('section', { className: 'today-hero' });
    hero.appendChild(el('p', { className: 'eyebrow', text: 'Today' }));
    hero.appendChild(el('h2', { text: state.headline || 'Here is what matters today.' }));

    const trustNotice = renderTrustNotice(state.trustNotice);
    if (trustNotice) hero.appendChild(trustNotice);

    return hero;
  }

  function renderAttention(section) {
    const card = el('section', { className: 'today-card today-attention' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Needs attention' }));

    const top = section && section.data && section.data.top;
    if (top) {
      card.appendChild(el('h3', { text: top.candidateId.replaceAll('_', ' ') }));
      card.appendChild(el('p', { text: 'This rose to the top because of timing, consequence, and context.' }));
    } else {
      card.appendChild(el('h3', { text: 'Nothing urgent right now.' }));
      card.appendChild(el('p', { text: 'Perch does not see anything that needs immediate attention.' }));
    }

    return card;
  }

  function renderMoney(section) {
    const card = el('section', { className: 'today-card' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Money' }));
    card.appendChild(el('h3', { text: section ? section.summary : 'Money check unavailable.' }));
    card.appendChild(el('p', { text: 'Shown as a computed fact, not a live bank balance.' }));
    return card;
  }

  function renderBrain(section) {
    const card = el('section', { className: 'today-card' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Brain' }));
    card.appendChild(el('h3', { text: section ? section.summary : 'No captures ready.' }));

    const list = el('ul', { className: 'today-simple-list' });
    ((section && section.items) || []).slice(0, 3).forEach((item) => {
      list.appendChild(el('li', { text: `${item.parsedType}: ${(item.titleWords || []).join(' ')}` }));
    });

    if (list.children.length) card.appendChild(list);
    return card;
  }

  function renderRecommendation(section) {
    const card = el('section', { className: 'today-card quiet' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Suggestion' }));
    card.appendChild(el('h3', { text: section ? section.summary : 'No suggestion shown.' }));
    card.appendChild(el('p', { text: 'Recommendations stay optional. Perch will never act for you automatically.' }));
    return card;
  }

  function renderLegacyFallback(state) {
    const footer = el('section', { className: 'today-legacy-fallback' });
    footer.appendChild(el('p', { text: 'Legacy Today remains available only as a fallback while this complete rebuild matures.' }));
    footer.appendChild(el('a', {
      text: 'Open legacy Today',
      attrs: { href: state.legacyFallback || 'perch_today_live.html' }
    }));
    return footer;
  }

  function renderTodayView(root, state) {
    if (!root) throw new Error('Today view requires a root element.');
    if (!state) throw new Error('Today view requires state.');

    root.innerHTML = '';
    root.className = 'today-view-root';

    const attention = sectionById(state, 'attention');
    const money = sectionById(state, 'money');
    const brain = sectionById(state, 'brain');
    const recommendation = sectionById(state, 'recommendation');

    root.appendChild(renderHero(state));
    root.appendChild(renderAttention(attention));

    const grid = el('div', { className: 'today-grid' });
    grid.appendChild(renderMoney(money));
    grid.appendChild(renderBrain(brain));
    grid.appendChild(renderRecommendation(recommendation));
    root.appendChild(grid);

    root.appendChild(renderLegacyFallback(state));

    return {
      rendered: true,
      sectionCount: state.sections.length
    };
  }

  const PerchTodayView = Object.freeze({
    renderTodayView
  });

  global.PerchTodayView = PerchTodayView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
