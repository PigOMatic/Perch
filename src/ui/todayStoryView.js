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

  function renderMoneyBranch(choice) {
    if (!choice || !choice.safeToOffer) return null;

    const card = el('section', { className: 'story-money-branch' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Money marker' }));
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

  function renderTimeLeaf(className, label, title, detail) {
    const leaf = el('div', { className: `time-leaf ${className}` });
    leaf.appendChild(el('p', { className: 'eyebrow', text: label }));
    leaf.appendChild(el('strong', { text: title }));
    leaf.appendChild(el('span', { text: detail }));
    return leaf;
  }

  function renderTimeBranch(storyInput = {}) {
    const schedule = storyInput.schedulePreview || [];
    const today = schedule[0] || { label: 'Today', detail: 'Ready' };
    const work = schedule.find((day) => day.status === 'work') || schedule[1] || { label: 'Work', detail: 'No shift found' };
    const event = storyInput.nextEvent || { title: 'No event', detail: 'Nothing dated yet.' };

    const wrap = el('section', { className: 'story-time-branch' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'Day shape' }));

    const hub = el('div', { className: 'time-branch-hub' });
    hub.appendChild(el('span', { className: 'time-hub-kicker', text: 'Today' }));
    hub.appendChild(el('strong', { text: 'What surrounds the money marker' }));
    wrap.appendChild(hub);

    const leaves = el('div', { className: 'time-branch-leaves' });
    leaves.appendChild(renderTimeLeaf('today-leaf', 'Today', `${today.day || ''} ${today.number || ''}`.trim() || today.label, `${today.label || ''} · ${today.detail || ''}`.replace(/^ · /, '')));
    leaves.appendChild(renderTimeLeaf('work-leaf', 'Work this week', `${work.day || ''} ${work.number || ''}`.trim() || work.label, `${work.label || ''} · ${work.detail || ''}`.replace(/^ · /, '')));
    leaves.appendChild(renderTimeLeaf('event-leaf', event.label || 'Next event', event.title, event.detail));
    wrap.appendChild(leaves);

    if (event.sourceNote || storyInput.sourceIndicator) {
      wrap.appendChild(el('small', {
        className: 'story-source-stamp',
        text: event.sourceNote || storyInput.sourceIndicator.label
      }));
    }

    return wrap;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    root.innerHTML = '';
    root.className = 'today-story-root';

    const page = el('article', { className: 'today-story-page today-path-page' });

    const opening = el('section', { className: 'story-opening' });
    opening.appendChild(el('p', { className: 'eyebrow', text: 'Today · first glance' }));
    opening.appendChild(el('h2', { text: state.headline || 'Most of today can stay quiet. Money gets the first mark.' }));
    opening.appendChild(el('p', {
      className: 'story-one-line',
      text: `First marker: ${topAttention(state)}.`
    }));
    page.appendChild(opening);

    const path = el('section', { className: 'story-flow-path reverse-time-layout' });

    const moneyBranch = renderMoneyBranch(storyInput.freedomChoice);
    if (moneyBranch) path.appendChild(moneyBranch);

    const timeBranch = renderTimeBranch({
      schedulePreview: storyInput.schedulePreview,
      nextEvent: storyInput.nextEvent,
      sourceIndicator: state.sourceIndicator
    });
    path.appendChild(timeBranch);

    page.appendChild(path);
    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true,
      hasMoneyBranch: Boolean(moneyBranch),
      hasFreedomChoice: Boolean(moneyBranch),
      hasTimeBranch: Boolean(timeBranch),
      hasScheduleSquares: false,
      hasTodayPath: true,
      hasNextEvent: Boolean(storyInput.nextEvent)
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    renderMoneyBranch,
    renderTimeBranch,
    renderTimeLeaf,
    renderFreedomChoice: renderMoneyBranch,
    topAttention
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
