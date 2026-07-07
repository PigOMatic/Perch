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

  function renderAnchorMarker(anchor) {
    const marker = el('section', { className: `story-anchor-marker ${anchor.id || ''}` });
    marker.appendChild(el('p', { className: 'eyebrow', text: anchor.label }));
    marker.appendChild(el('h3', { text: anchor.title }));
    marker.appendChild(el('p', { text: anchor.detail }));
    return marker;
  }

  function renderScheduleSquares(days) {
    if (!Array.isArray(days) || !days.length) return null;

    const wrap = el('section', { className: 'story-schedule-strip' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'Next work shifts' }));

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

  function renderMoneyBranch(choice) {
    if (!choice || !choice.safeToOffer) return null;

    const card = el('section', { className: 'story-money-branch' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Today' }));
    card.appendChild(el('h3', { text: choice.prompt }));
    if (choice.note) card.appendChild(el('p', { className: 'story-branch-note', text: choice.note }));

    const branch = el('div', { className: 'story-branch-flow' });
    const trunk = el('div', { className: 'story-branch-trunk' });
    trunk.appendChild(el('span', { className: 'branch-amount', text: `$${choice.leftAfterBills}` }));
    trunk.appendChild(el('span', { className: 'branch-label', text: 'open after bills' }));
    branch.appendChild(trunk);

    const arms = el('div', { className: 'story-branch-arms' });
    arms.appendChild(el('button', { className: 'branch-option safe', text: choice.safeAction || 'Keep it safe' }));
    arms.appendChild(el('button', { className: 'branch-option little', text: choice.littleAction || 'Use a little' }));
    arms.appendChild(el('button', { className: 'branch-option toward', text: choice.towardAction || 'Put it toward something' }));
    branch.appendChild(arms);

    card.appendChild(branch);
    return card;
  }

  function renderNextEvent(event, sourceIndicator) {
    if (!event) return null;

    const wrap = el('section', { className: 'story-next-event' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: event.label || 'Next event' }));
    wrap.appendChild(el('h3', { text: event.title }));
    wrap.appendChild(el('p', { text: event.detail }));
    wrap.appendChild(el('small', {
      className: 'story-source-stamp',
      text: event.sourceNote || (sourceIndicator ? sourceIndicator.label : 'Source not labeled yet')
    }));
    return wrap;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    root.innerHTML = '';
    root.className = 'today-story-root';

    const scheduleSquares = storyInput.schedulePreview || [];
    const anchors = storyInput.timelineAnchors || [];

    const page = el('article', { className: 'today-story-page today-path-page' });

    const opening = el('section', { className: 'story-opening' });
    opening.appendChild(el('p', { className: 'eyebrow', text: 'Today · first glance' }));
    opening.appendChild(el('h2', { text: state.headline || 'Most of today can stay quiet. Money gets the first mark.' }));
    opening.appendChild(el('p', {
      className: 'story-one-line',
      text: `First marker: ${topAttention(state)}.`
    }));
    page.appendChild(opening);

    const path = el('section', { className: 'story-flow-path' });

    if (anchors[0]) path.appendChild(renderAnchorMarker(anchors[0]));

    const moneyBranch = renderMoneyBranch(storyInput.freedomChoice);
    if (moneyBranch) path.appendChild(moneyBranch);

    if (anchors[1]) path.appendChild(renderAnchorMarker(anchors[1]));

    const schedule = renderScheduleSquares(scheduleSquares);
    if (schedule) path.appendChild(schedule);

    const nextEvent = renderNextEvent(storyInput.nextEvent, state.sourceIndicator);
    if (nextEvent) path.appendChild(nextEvent);

    page.appendChild(path);

    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true,
      hasMoneyBranch: Boolean(moneyBranch),
      hasFreedomChoice: Boolean(moneyBranch),
      hasScheduleSquares: Boolean(schedule),
      hasTodayPath: true,
      hasNextEvent: Boolean(nextEvent)
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    renderAnchorMarker,
    renderScheduleSquares,
    renderMoneyBranch,
    renderNextEvent,
    renderFreedomChoice: renderMoneyBranch,
    topAttention,
    moneySummary,
    brainSummary
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
