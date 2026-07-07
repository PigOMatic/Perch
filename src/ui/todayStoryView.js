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

  function formatAmount(amount) {
    return `$${Number(amount || 0).toLocaleString()}`;
  }

  function formatDate(date) {
    if (!date) return 'No date';
    const parsed = new Date(`${date}T12:00:00`);
    return parsed.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  }

  function renderBillsTab(bills = []) {
    const details = el('details', { className: 'story-bills-tab' });
    const summary = el('summary');
    summary.appendChild(el('span', { text: 'Bills checked' }));
    summary.appendChild(el('small', { text: `${bills.length} counted` }));
    details.appendChild(summary);

    const list = el('div', { className: 'story-bill-list' });
    bills.forEach((bill) => {
      const row = el('div', { className: `story-bill-row ${bill.status || 'due'}` });
      row.appendChild(el('span', { className: 'bill-check', text: bill.status === 'scheduled' ? '✓' : '○' }));
      row.appendChild(el('strong', { text: bill.name }));
      row.appendChild(el('span', { text: formatDate(bill.dueDate) }));
      row.appendChild(el('span', { text: formatAmount(bill.amount) }));
      list.appendChild(row);
    });
    details.appendChild(list);
    return details;
  }

  function renderMoneyBranch(choice, money = {}) {
    if (!choice || !choice.safeToOffer) return null;

    const card = el('section', { className: 'story-money-branch' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Money first' }));
    card.appendChild(el('h3', { text: choice.prompt }));
    if (choice.note) card.appendChild(el('p', { className: 'story-branch-note', text: choice.note }));
    card.appendChild(renderBillsTab(money.bills || []));

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

  function renderWeekBranch(storyInput = {}) {
    const week = storyInput.weekSchedule || [];
    const event = storyInput.nextEvent || { title: 'Nothing due', detail: 'No next event set.' };

    const wrap = el('section', { className: 'story-week-branch' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'Week shape' }));

    const eventCard = el('div', { className: 'week-next-due' });
    eventCard.appendChild(el('p', { className: 'eyebrow', text: event.label || 'Next due' }));
    eventCard.appendChild(el('strong', { text: event.title }));
    eventCard.appendChild(el('span', { text: event.detail }));
    wrap.appendChild(eventCard);

    const rail = el('div', { className: 'week-rail' });
    week.slice().reverse().forEach((day) => {
      const chip = el('div', { className: `week-day ${day.status || 'off'}` });
      chip.appendChild(el('span', { className: 'week-day-name', text: day.day }));
      chip.appendChild(el('strong', { text: day.number }));
      chip.appendChild(el('span', { className: 'week-day-label', text: day.label }));
      chip.appendChild(el('small', { text: day.detail }));
      rail.appendChild(chip);
    });
    wrap.appendChild(rail);

    return wrap;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    root.innerHTML = '';
    root.className = 'today-story-root';

    const page = el('article', { className: 'today-story-page today-path-page' });

    const opening = el('section', { className: 'story-opening compact-opening' });
    opening.appendChild(el('p', { className: 'eyebrow', text: 'Today' }));
    opening.appendChild(el('h2', { text: state.headline || 'Today is mostly steady. Money gets the first look.' }));
    opening.appendChild(el('p', {
      className: 'story-one-line',
      text: `First look: ${topAttention(state)}.`
    }));
    page.appendChild(opening);

    const path = el('section', { className: 'story-flow-path s-flow-layout' });

    const moneyBranch = renderMoneyBranch(storyInput.freedomChoice, storyInput.money || {});
    if (moneyBranch) path.appendChild(moneyBranch);

    const weekBranch = renderWeekBranch({
      weekSchedule: storyInput.weekSchedule,
      nextEvent: storyInput.nextEvent
    });
    path.appendChild(weekBranch);

    page.appendChild(path);
    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true,
      hasMoneyBranch: Boolean(moneyBranch),
      hasBillsTab: Boolean(storyInput.money && storyInput.money.bills),
      hasWeekBranch: Boolean(weekBranch),
      hasScheduleSquares: false,
      hasNextEvent: Boolean(storyInput.nextEvent)
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    renderMoneyBranch,
    renderWeekBranch,
    renderBillsTab,
    renderFreedomChoice: renderMoneyBranch,
    topAttention
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
