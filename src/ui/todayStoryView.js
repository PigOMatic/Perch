/*
 * Perch Today Story View
 * ----------------------
 * A fake-data design prototype for evaluating the first second of Today.
 */

(function attachPerchTodayStoryView(global) {
  'use strict';

  const DEFAULT_SCENES = Object.freeze([
    { id: 'desk', label: 'Desk', detail: 'coffee morning' },
    { id: 'patio', label: 'Patio', detail: 'warm outside' },
    { id: 'firepit', label: 'Firepit', detail: 'evening glow' },
    { id: 'trail', label: 'Trail', detail: 'field guide' },
    { id: 'breakroom', label: 'Break room', detail: 'work night' }
  ]);

  function el(tag, options = {}) {
    const node = document.createElement(tag);
    if (options.className) node.className = options.className;
    if (options.text) node.textContent = options.text;
    if (options.attrs) {
      Object.entries(options.attrs).forEach(([key, value]) => node.setAttribute(key, value));
    }
    return node;
  }

  function formatAmount(amount) {
    return `$${Number(amount || 0).toLocaleString()}`;
  }

  function formatDate(date) {
    if (!date) return 'No date';
    const parsed = new Date(`${date}T12:00:00`);
    return parsed.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  }

  function getStoredSceneId(fallback) {
    try {
      return global.localStorage.getItem('perch_today_scene_preview') || fallback;
    } catch (error) {
      return fallback;
    }
  }

  function storeSceneId(sceneId) {
    try {
      global.localStorage.setItem('perch_today_scene_preview', sceneId);
    } catch (error) {
      // Demo preference only; safe to ignore if storage is unavailable.
    }
  }

  function setScene(root, sceneId, switcher) {
    const classes = Array.from(root.classList).filter((className) => !className.startsWith('env-'));
    root.className = classes.concat(`env-${sceneId}`).join(' ');
    if (switcher) {
      switcher.querySelectorAll('[data-scene-id]').forEach((button) => {
        const isActive = button.getAttribute('data-scene-id') === sceneId;
        button.classList.toggle('active', isActive);
        button.setAttribute('aria-pressed', isActive ? 'true' : 'false');
      });
    }
    storeSceneId(sceneId);
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

  function renderAlwaysShow(items = []) {
    const wrap = el('details', { className: 'story-always-show' });
    const summary = el('summary');
    summary.appendChild(el('span', { text: 'Always show' }));
    summary.appendChild(el('small', { text: 'adjust later' }));
    wrap.appendChild(summary);

    const chips = el('div', { className: 'always-show-chips' });
    (items.length ? items : ['Bills', 'Work', 'Brain notes']).forEach((item) => {
      chips.appendChild(el('button', { className: 'always-show-chip', text: item }));
    });
    wrap.appendChild(chips);
    return wrap;
  }

  function renderActionButton(text, className = 'run-action') {
    const button = el('button', { className, text });
    button.setAttribute('type', 'button');
    return button;
  }

  function renderInfoBlock(className, data, extra) {
    if (!data) return null;
    const block = el('section', { className: `run-sheet-card ${className}` });
    block.appendChild(el('p', { className: 'eyebrow', text: data.label }));
    block.appendChild(el('h3', { text: data.title }));
    if (data.detail) block.appendChild(el('p', { text: data.detail }));
    if (data.action) block.appendChild(renderActionButton(data.action));
    if (extra) block.appendChild(extra);
    return block;
  }

  function renderMoneyBranch(choice, money = {}) {
    if (!choice || !choice.safeToOffer) return null;

    const card = el('section', { className: 'run-sheet-card story-money-branch' });
    card.appendChild(el('p', { className: 'eyebrow', text: 'Money' }));
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
    card.appendChild(renderBillsTab(money.bills || []));
    return card;
  }

  function renderCalendarButton() {
    const button = el('button', { className: 'week-calendar-button', text: 'Calendar' });
    button.setAttribute('type', 'button');
    button.setAttribute('aria-label', 'Open full schedule');
    return button;
  }

  function renderNextShifts(shifts = []) {
    const wrap = el('section', { className: 'run-sheet-card next-shifts-block' });
    const header = el('div', { className: 'next-shifts-header' });
    header.appendChild(el('p', { className: 'eyebrow', text: 'Next shifts' }));
    header.appendChild(renderCalendarButton());
    wrap.appendChild(header);

    const tickets = el('div', { className: 'shift-ticket-row' });
    shifts.slice(0, 3).forEach((shift) => {
      const ticket = el('div', { className: 'shift-ticket' });
      ticket.appendChild(el('span', { className: 'shift-day', text: shift.day }));
      ticket.appendChild(el('strong', { text: shift.number }));
      ticket.appendChild(el('span', { className: 'shift-label', text: shift.label }));
      tickets.appendChild(ticket);
    });
    wrap.appendChild(tickets);
    return wrap;
  }

  function renderBrainNotes(notes = []) {
    if (!notes.length) return null;
    const wrap = el('section', { className: 'brain-note-strip' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'From your brain' }));
    const notesWrap = el('div', { className: 'brain-note-row' });
    notes.slice(0, 2).forEach((note) => {
      const noteEl = el('article', { className: `posted-note ${note.attachedTo || 'today'}` });
      noteEl.appendChild(el('span', { className: 'pin-dot' }));
      noteEl.appendChild(el('p', { text: note.text }));
      notesWrap.appendChild(noteEl);
    });
    wrap.appendChild(notesWrap);
    return wrap;
  }

  function renderSceneSwitcher(scenes, activeSceneId, onSelect) {
    const wrap = el('section', { className: 'scene-switcher' });
    wrap.appendChild(el('p', { className: 'eyebrow', text: 'View scene' }));
    const row = el('div', { className: 'scene-switcher-row' });
    scenes.forEach((scene) => {
      const button = el('button', {
        className: `scene-chip ${scene.id === activeSceneId ? 'active' : ''}`,
        attrs: {
          type: 'button',
          'data-scene-id': scene.id,
          'aria-pressed': scene.id === activeSceneId ? 'true' : 'false'
        }
      });
      button.appendChild(el('span', { text: scene.label }));
      button.appendChild(el('small', { text: scene.detail }));
      button.addEventListener('click', () => onSelect(scene.id, wrap));
      row.appendChild(button);
    });
    wrap.appendChild(row);
    return wrap;
  }

  function renderTodayStoryView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today story view requires a root element.');
    if (!state) throw new Error('Today story view requires state.');

    const scenes = storyInput.environmentScenes || DEFAULT_SCENES;
    const fallbackSceneId = (storyInput.environment && storyInput.environment.id) || 'desk';
    const activeSceneId = getStoredSceneId(fallbackSceneId);

    root.innerHTML = '';
    root.className = `today-story-root run-sheet-environment env-${activeSceneId}`;

    const page = el('article', {
      className: `today-story-page today-run-sheet ${storyInput.layoutMode || 'balanced'}`
    });

    const opening = el('section', { className: 'story-opening compact-opening' });
    const brand = el('div', { className: 'run-sheet-brand' });
    brand.appendChild(el('p', { className: 'perch-wordmark', text: 'Perch' }));
    brand.appendChild(renderAlwaysShow(storyInput.alwaysShow));
    opening.appendChild(brand);
    opening.appendChild(el('h2', { text: state.headline || 'Today' }));
    if (storyInput.todayStatus) {
      opening.appendChild(el('p', { className: 'today-date-line', text: storyInput.todayStatus.title }));
      opening.appendChild(el('p', { className: 'today-soft-note', text: storyInput.todayStatus.detail }));
    }
    page.appendChild(opening);

    const path = el('section', { className: 'story-flow-path mobile-run-sheet-flow' });

    const nextDueBlock = renderInfoBlock('next-due-block pinned-paper', storyInput.nextDue);
    if (nextDueBlock) path.appendChild(nextDueBlock);

    const moneyBranch = renderMoneyBranch(storyInput.freedomChoice, storyInput.money || {});
    if (moneyBranch) path.appendChild(moneyBranch);

    const shifts = renderNextShifts(storyInput.nextShifts || []);
    if (shifts) path.appendChild(shifts);

    const dueSoonBlock = renderInfoBlock('due-soon-block torn-paper', storyInput.dueSoon);
    if (dueSoonBlock) path.appendChild(dueSoonBlock);

    const brainNotes = renderBrainNotes(storyInput.brainNotes || []);
    if (brainNotes) path.appendChild(brainNotes);

    page.appendChild(path);
    page.appendChild(renderSceneSwitcher(scenes, activeSceneId, (sceneId, switcher) => setScene(root, sceneId, switcher)));
    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      hasFirstSecond: true,
      usesFakeData: true,
      hasEnvironmentLayer: Boolean(storyInput.environment),
      hasSceneSwitcher: true,
      activeSceneId,
      hasMoneyBranch: Boolean(moneyBranch),
      hasBillsTab: Boolean(storyInput.money && storyInput.money.bills),
      hasNextShifts: Boolean(storyInput.nextShifts),
      hasNextDue: Boolean(nextDueBlock),
      hasDueSoon: Boolean(dueSoonBlock),
      hasBrainNotes: Boolean(brainNotes),
      hasAlwaysShow: Boolean(storyInput.alwaysShow),
      hasCalendarButton: true,
      hasScheduleSquares: false
    };
  }

  const PerchTodayStoryView = Object.freeze({
    renderTodayStoryView,
    renderMoneyBranch,
    renderInfoBlock,
    renderNextShifts,
    renderBillsTab,
    renderAlwaysShow,
    renderBrainNotes,
    renderSceneSwitcher,
    renderCalendarButton,
    renderFreedomChoice: renderMoneyBranch
  });

  global.PerchTodayStoryView = PerchTodayStoryView;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
