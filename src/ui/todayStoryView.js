/*
 * Perch Today Story View
 * ----------------------
 * A fake-data design prototype for evaluating the first second of Today.
 */

(function attachPerchTodayStoryView(global) {
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

  function topAttention(state) {
    const attention = sectionById(state, 'attention');
    const top = attention && attention.data && attention.data.top;
    return top ? top.candidateId.replaceAll('_', ' ') : 'nothing urgent';
  }

  function moneySummary(state) {
    const money = sectionById(state, 'money');
    return money && money.summary ? money.summary : 'Money details are not ready yet.';
  }

  function brainSummary(state) {
    const brain = sectionById(state, 'brain');
    return brain && brain.summary ? brain.summary : 'No notes are waiting.';
  }

  function renderMiniCard(label, value) {
    const card = el('div', { className: 'story-mini-card' });
    card.appendChild(el('p', { className: 'eyebrow', text: label }));
    card.appendChild(el('p', { text: value }));
    return card;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    root.innerHTML = '';
    root.className = 'today-story-root';

    const story = storyInput.storyDetails || {};
    const people = storyInput.people || [];
    const shift = (storyInput.workShifts || [])[0];

    const page = el('article', { className: 'today-story-page' });

    const opening = el('section', { className: 'story-opening' });
    opening.appendChild(el('p', { className: 'eyebrow', text: 'Today · first glance' }));
    opening.appendChild(el('h2', { text: state.headline || 'You have one real thing to look at first.' }));
    opening.appendChild(el('p', {
      className: 'story-one-line',
      text: `First marker: ${topAttention(state)}.`
    }));
    page.appendChild(opening);

    const second = el('section', { className: 'story-second-row' });
    second.appendChild(renderMiniCard('1 second', story.firstSecond || 'Your eye lands on the page statement.'));
    second.appendChild(renderMiniCard('5 seconds', story.firstFiveSeconds || 'You understand the first pressure point.'));
    second.appendChild(renderMiniCard('1 minute', story.firstMinute || 'You can inspect the evidence without feeling flooded.'));
    page.appendChild(second);

    const map = el('section', { className: 'story-today-map' });
    map.appendChild(el('p', { className: 'eyebrow', text: 'What the page shows' }));
    map.appendChild(renderMiniCard('Money terrain', moneySummary(state)));
    if (shift) {
      map.appendChild(renderMiniCard('Schedule terrain', `${shift.label} · ${shift.date} · ${shift.start}`));
    }
    map.appendChild(renderMiniCard('Brain notes', brainSummary(state)));
    if (people.length) {
      map.appendChild(renderMiniCard('People nearby', people.map((person) => person.name).slice(0, 3).join(', ')));
    }
    page.appendChild(map);

    const lower = el('section', { className: 'story-lower-notes' });
    lower.appendChild(renderMiniCard('What can wait', 'Barn cleanup and low-pressure property chores stay quiet.'));
    lower.appendChild(renderMiniCard('Trust/source', state.sourceIndicator ? state.sourceIndicator.label : 'Source not labeled yet.'));
    page.appendChild(lower);

    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    topAttention,
    moneySummary,
    brainSummary
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
