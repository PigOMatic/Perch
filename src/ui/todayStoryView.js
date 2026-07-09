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

  function renderActionButton(text, className = 'run-action') {
    const button = el('button', { className, text });
    button.setAttribute('type', 'button');
    return button;
  }

  function renderPaperItem(data, className) {
    if (!data) return null;

    const item = el('article', { className: `paper-priority ${className}` });
    item.appendChild(el('p', { className: 'eyebrow', text: data.label }));
    item.appendChild(el('h3', { text: data.title }));
    if (data.detail) item.appendChild(el('p', { className: 'priority-support', text: data.detail }));
    if (data.action) item.appendChild(renderActionButton(data.action));
    return item;
  }

  function renderMainPaper(state, storyInput = {}) {
    const paper = el('section', { className: 'today-main-paper', attrs: { 'aria-label': 'Today relief run sheet' } });

    const header = el('header', { className: 'main-paper-header' });
    header.appendChild(el('p', { className: 'perch-wordmark', text: 'Perch' }));
    header.appendChild(el('h1', { text: state.headline || storyInput.headline || 'Today' }));

    if (storyInput.todayStatus) {
      const meta = el('div', { className: 'today-status-line' });
      meta.appendChild(el('strong', { text: storyInput.todayStatus.title }));
      if (storyInput.todayStatus.detail) meta.appendChild(el('span', { text: storyInput.todayStatus.detail }));
      header.appendChild(meta);
    }

    paper.appendChild(header);

    const priorities = el('div', { className: 'paper-priority-stack' });
    const nextDue = renderPaperItem(storyInput.nextDue, 'next-due-line');
    const dueSoon = renderPaperItem(storyInput.dueSoon, 'due-soon-line');
    if (nextDue) priorities.appendChild(nextDue);
    if (dueSoon) priorities.appendChild(dueSoon);
    paper.appendChild(priorities);

    return paper;
  }

  function renderMoneyObject(choice, money = {}) {
    if (!choice || !choice.safeToOffer) return null;

    const object = el('aside', { className: 'money-object', attrs: { 'aria-label': 'Money relief object' } });
    object.appendChild(el('p', { className: 'money-label', text: 'Money' }));
    object.appendChild(el('h2', { text: choice.prompt || `$${choice.leftAfterBills} open after bills` }));
    if (choice.note) object.appendChild(el('p', { className: 'money-note', text: choice.note }));

    const actions = el('div', { className: 'money-choice-row' });
    actions.appendChild(el('button', { className: 'money-choice safe', attrs: { type: 'button' }, text: choice.safeAction || 'Keep it safe' }));
    actions.appendChild(el('button', { className: 'money-choice little', attrs: { type: 'button' }, text: choice.littleAction || 'Use a little' }));
    actions.appendChild(el('button', { className: 'money-choice toward', attrs: { type: 'button' }, text: choice.towardAction || 'Put it toward something' }));
    object.appendChild(actions);

    const checked = el('details', { className: 'money-bills-checked' });
    const summary = el('summary');
    summary.appendChild(el('span', { text: 'Bills checked' }));
    summary.appendChild(el('small', { text: `${(money.bills || []).length} counted` }));
    checked.appendChild(summary);

    const billList = el('div', { className: 'money-bill-list' });
    (money.bills || []).forEach((bill) => {
      const row = el('div', { className: `money-bill-row ${bill.status || 'due'}` });
      row.appendChild(el('span', { text: bill.status === 'scheduled' ? '✓' : '○' }));
      row.appendChild(el('strong', { text: bill.name }));
      row.appendChild(el('span', { text: formatDate(bill.dueDate) }));
      billList.appendChild(row);
    });
    checked.appendChild(billList);
    object.appendChild(checked);

    return object;
  }

  function renderShiftTickets(shifts = []) {
    const wrap = el('section', { className: 'shift-ticket-cluster', attrs: { 'aria-label': 'Upcoming shifts' } });
    const tickets = el('div', { className: 'shift-ticket-row' });

    shifts.slice(0, 3).forEach((shift) => {
      const ticket = el('article', { className: 'shift-ticket' });
      ticket.appendChild(el('span', { className: 'shift-date', text: `${shift.day} ${shift.number}` }));
      ticket.appendChild(el('strong', { text: shift.label }));
      tickets.appendChild(ticket);
    });

    wrap.appendChild(tickets);
    const calendarButton = renderActionButton('Calendar', 'calendar-ticket-button');
    calendarButton.setAttribute('aria-label', 'Open full schedule');
    wrap.appendChild(calendarButton);
    return wrap;
  }

  function renderBrainNote(notes = []) {
    const note = notes[0];
    if (!note) return null;

    const article = el('article', { className: `posted-brain-note ${note.attachedTo || 'today'}` });
    article.appendChild(el('span', { className: 'pin-dot' }));
    article.appendChild(el('p', { text: note.text }));
    return article;
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

    const page = el('article', { className: 'today-v2-composition' });
    const sceneMat = el('div', { className: 'scene-mat', attrs: { 'aria-hidden': 'true' } });
    const foreground = el('section', { className: 'today-foreground' });

    foreground.appendChild(renderMainPaper(state, storyInput));

    const moneyObject = renderMoneyObject(storyInput.freedomChoice, storyInput.money || {});
    if (moneyObject) foreground.appendChild(moneyObject);

    const shifts = renderShiftTickets(storyInput.nextShifts || []);
    foreground.appendChild(shifts);

    const brainNote = renderBrainNote(storyInput.brainNotes || []);
    if (brainNote) foreground.appendChild(brainNote);

    page.appendChild(sceneMat);
    page.appendChild(foreground);
    page.appendChild(renderSceneSwitcher(scenes, activeSceneId, (sceneId, switcher) => setScene(root, sceneId, switcher)));
    root.appendChild(page);

    return {
      rendered: true,
      mode: 'story-demo',
      structure: 'today-v2-relief-composition',
      hasFirstSecond: true,
      usesFakeData: true,
      hasEnvironmentLayer: Boolean(storyInput.environment),
      sceneCount: scenes.length
    };
  }

  global.PerchTodayStoryView = {
    renderTodayStoryView
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = global.PerchTodayStoryView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
