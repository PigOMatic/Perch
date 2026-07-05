/*
 * Perch Today Brief View
 * ----------------------
 * Opinionated visual prototype for the rebuilt Today surface.
 *
 * This view consumes the same Today PageState as todayView.js but renders it as
 * a calm daily brief rather than a dashboard/card grid.
 */

(function attachPerchTodayBriefView(global) {
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

  function attentionLine(section) {
    const top = section && section.data && section.data.top;
    if (!top) return 'Nothing needs your full attention right now.';
    return `${top.candidateId.replaceAll('_', ' ')} is the thing to look at first.`;
  }

  function moneyLine(section) {
    if (!section) return 'Money context is not available yet.';
    return section.summary || 'Money context is available.';
  }

  function brainLine(section) {
    if (!section) return 'Your brain inbox is quiet.';
    return section.summary || 'You have captured items ready to review.';
  }

  function sourceLine(state) {
    const source = state.sourceIndicator;
    if (!source) return 'Source details are not available.';
    return `${source.label || 'Source unknown'} · ${source.mode || 'mode unknown'}`;
  }

  function renderEvidence(label, text) {
    const item = el('li');
    item.appendChild(el('span', { className: 'brief-evidence-label', text: label }));
    item.appendChild(el('span', { text }));
    return item;
  }

  function renderTodayBriefView(root, state) {
    if (!root) throw new Error('Today brief view requires a root element.');
    if (!state) throw new Error('Today brief view requires state.');

    root.innerHTML = '';
    root.className = 'today-brief-root';

    const attention = sectionById(state, 'attention');
    const money = sectionById(state, 'money');
    const brain = sectionById(state, 'brain');
    const recommendation = sectionById(state, 'recommendation');

    const shell = el('article', { className: 'today-brief' });

    const opening = el('section', { className: 'brief-opening' });
    opening.appendChild(el('p', { className: 'eyebrow', text: 'Today' }));
    opening.appendChild(el('h2', { text: state.headline || 'Here is what matters today.' }));
    opening.appendChild(el('p', {
      className: 'brief-primary-line',
      text: attentionLine(attention)
    }));
    shell.appendChild(opening);

    const evidence = el('section', { className: 'brief-evidence' });
    evidence.appendChild(el('p', { className: 'eyebrow', text: 'Why Perch thinks that' }));
    const list = el('ul');
    list.appendChild(renderEvidence('Money', moneyLine(money)));
    list.appendChild(renderEvidence('Brain', brainLine(brain)));
    if (recommendation) list.appendChild(renderEvidence('Suggestion', recommendation.summary));
    evidence.appendChild(list);
    shell.appendChild(evidence);

    const quiet = el('section', { className: 'brief-quiet-notes' });
    quiet.appendChild(el('p', { text: sourceLine(state) }));
    if (state.trustNotice) {
      quiet.appendChild(el('p', { text: state.trustNotice.label || 'Some information may need confirmation.' }));
    }
    shell.appendChild(quiet);

    root.appendChild(shell);

    return {
      rendered: true,
      mode: 'brief',
      dominantDailyAnswer: true,
      sectionCount: state.sections.length
    };
  }

  const PerchTodayBriefView = Object.freeze({
    renderTodayBriefView,
    attentionLine,
    moneyLine,
    brainLine,
    sourceLine
  });

  global.PerchTodayBriefView = PerchTodayBriefView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayBriefView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
