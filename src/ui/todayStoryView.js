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

  function renderScheduleSquares(days) {
    if (!Array.isArray(days) || !days.length) return null;

    const wrap = el('section', { className: 'story-schedule-strip' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'Next 3 days' }));

    const squares = el('div', { className: 'story-calendar-squares' });
    days.slice(0, 3).forEach((day) => {
      const square = el('div', { className: `story-calendar-square ${day.status || 'unknown'}` });
      square.appendChild(el('span', { className: 'cal-day', text: day.day }));
      square.appendChild(el('strong', { className: 'cal-number', text: day.number }));
      square.appendChild(el('span', { className: 'cal-label', text: day.label }));
      square.appendChild(el('small', { className: 'cal-detail', text: day.detail }));
      squares.appendChild(square);
    });

    wrap.appendChild(squares);
    return wrap;
  }

  function renderFreedomChoice(choice) {
    if (!choice || !choice.safeToOffer) return null;

    const card = el('section', { className: 'story-freedom-choice' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Freedom choice' }));
    card.appendChild(el('h3', { text: choice.prompt }));

    const actions = el('div', { className: 'story-choice-actions' });
    actions.appendChild(el('button', { className: 'responsible', text: choice.responsibleAction }));
    actions.appendChild(el('button', { className: 'fun', text: choice.funAction }));
    actions.appendChild(el('button', { className: 'irresponsible', text: choice.irresponsibleAction }));
    card.appendChild(actions);

    card.appendChild(el('p', {
      className: 'story-choice-note',
      text: 'Perch only shows this after bills and cushion are accounted for.'
    }));

    return card;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    root.innerHTML = '';
    root.className = 'today-story-root';

    const story = storyInput.storyDetails || {};
    const people = storyInput.people || [];
    const scheduleSquares = storyInput.schedulePreview || [];

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

    const schedule = renderScheduleSquares(scheduleSquares);
    if (schedule) page.appendChild(schedule);

    const map = el('section', { className: 'story-today-map' });
    map.appendChild(el('p', { className: 'eyebrow', text: 'What the page shows' }));
    map.appendChild(renderMiniCard('Money terrain', moneySummary(state)));
    map.appendChild(renderMiniCard('Brain notes', brainSummary(state)));
    if (people.length) {
      map.appendChild(renderMiniCard('People nearby', people.map((person) => person.name).slice(0, 3).join(', ')));
    }
    page.appendChild(map);

    const freedomChoice = renderFreedomChoice(storyInput.freedomChoice);
    if (freedomChoice) page.appendChild(freedomChoice);

    const lower = el('section', { className: 'story-lower-notes' });
    lower.appendChild(renderMiniCard('What can wait', 'Barn cleanup and low-pressure property chores stay quiet.'));
    lower.appendChild(renderMiniCard('Trust/source', state.sourceIndicator ? state.sourceIndicator.label : 'Source not labeled yet.'));
    page.appendChild(lower);

    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true,
      hasFreedomChoice: Boolean(freedomChoice),
      hasScheduleSquares: Boolean(schedule)
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    renderScheduleSquares,
    renderFreedomChoice,
    topAttention,
    moneySummary,
    brainSummary
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
