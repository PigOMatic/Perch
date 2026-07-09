/*
 * Perch Today Workspace View
 * --------------------------
 * A v3 demo renderer where the desk is the interface and live data is
 * positioned onto physical-feeling objects.
 */

(function attachPerchTodayWorkspaceView(global) {
  'use strict';

  const DEFAULT_SCENES = Object.freeze([
    { id: 'desk', label: 'Desk', detail: 'wood table' },
    { id: 'patio', label: 'Patio', detail: 'outside table' },
    { id: 'firepit', label: 'Firepit', detail: 'evening table' },
    { id: 'trail', label: 'Trail', detail: 'field notebook' },
    { id: 'breakroom', label: 'Break room', detail: 'work counter' }
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

  function getStoredSceneId(fallback) {
    try {
      return global.localStorage.getItem('perch_today_workspace_scene') || fallback;
    } catch (error) {
      return fallback;
    }
  }

  function storeSceneId(sceneId) {
    try {
      global.localStorage.setItem('perch_today_workspace_scene', sceneId);
    } catch (error) {
      // Demo preference only.
    }
  }

  function setScene(root, sceneId, switcher) {
    const classes = Array.from(root.classList).filter((className) => !className.startsWith('workspace-'));
    root.className = classes.concat(`workspace-${sceneId}`).join(' ');
    if (switcher) {
      switcher.querySelectorAll('[data-scene-id]').forEach((button) => {
        const isActive = button.getAttribute('data-scene-id') === sceneId;
        button.classList.toggle('active', isActive);
        button.setAttribute('aria-pressed', isActive ? 'true' : 'false');
      });
    }
    storeSceneId(sceneId);
  }

  function renderNotebook(state, storyInput = {}) {
    const notebook = el('section', { className: 'workspace-notebook', attrs: { 'aria-label': 'Today notebook' } });
    const holes = el('div', { className: 'notebook-holes', attrs: { 'aria-hidden': 'true' } });
    for (let index = 0; index < 9; index += 1) holes.appendChild(el('span'));
    notebook.appendChild(holes);

    const page = el('div', { className: 'notebook-page' });
    const top = el('header', { className: 'notebook-topline' });
    top.appendChild(el('p', { className: 'workspace-wordmark', text: 'Perch.' }));
    if (storyInput.todayStatus) top.appendChild(el('p', { className: 'workspace-dayline', text: storyInput.todayStatus.title }));
    page.appendChild(top);

    if (storyInput.todayStatus && storyInput.todayStatus.detail) {
      page.appendChild(el('p', { className: 'workspace-reset', text: storyInput.todayStatus.detail }));
    }

    const list = el('div', { className: 'notebook-list' });
    if (storyInput.nextDue) list.appendChild(renderNotebookItem(storyInput.nextDue, 'next-due'));
    if (storyInput.dueSoon) list.appendChild(renderNotebookItem(storyInput.dueSoon, 'due-soon'));
    page.appendChild(list);

    notebook.appendChild(page);
    return notebook;
  }

  function renderNotebookItem(item, type) {
    const row = el('article', { className: `notebook-item ${type}` });
    row.appendChild(el('p', { className: 'notebook-label', text: item.label }));

    const main = el('div', { className: 'notebook-item-main' });
    main.appendChild(el('span', { className: 'checkbox' }));
    main.appendChild(el('strong', { text: item.title.replace(' · ', '   ') }));
    row.appendChild(main);

    const action = el('button', { className: 'notebook-action', text: item.action || 'Review', attrs: { type: 'button' } });
    row.appendChild(action);
    return row;
  }

  function renderMoneyEnvelope(choice) {
    const envelope = el('aside', { className: 'workspace-envelope', attrs: { 'aria-label': 'Money envelope' } });
    envelope.appendChild(el('div', { className: 'cash cash-one', attrs: { 'aria-hidden': 'true' }, text: '$20' }));
    envelope.appendChild(el('div', { className: 'cash cash-two', attrs: { 'aria-hidden': 'true' }, text: '$10' }));
    envelope.appendChild(el('div', { className: 'cash cash-three', attrs: { 'aria-hidden': 'true' }, text: '$5' }));

    const face = el('div', { className: 'envelope-face' });
    face.appendChild(el('p', { className: 'envelope-title', text: 'Money' }));
    face.appendChild(el('p', { className: 'envelope-subtitle', text: 'Available' }));
    face.appendChild(el('strong', { className: 'envelope-amount', text: choice && choice.leftAfterBills ? `$${choice.leftAfterBills}` : '$800' }));
    face.appendChild(el('p', { className: 'envelope-safe', text: choice && choice.note ? choice.note.replace('Counted through', 'Safe through').replace('payday.', '') : 'Safe until payday' }));

    const checks = el('div', { className: 'envelope-checks' });
    [choice && choice.safeAction, choice && choice.littleAction, choice && choice.towardAction]
      .filter(Boolean)
      .forEach((label) => {
        const check = el('button', { attrs: { type: 'button' } });
        check.appendChild(el('span', { text: '☑' }));
        check.appendChild(el('small', { text: label }));
        checks.appendChild(check);
      });
    face.appendChild(checks);
    face.appendChild(el('p', { className: 'bills-checked', text: 'Bills checked ✓' }));
    envelope.appendChild(face);
    return envelope;
  }

  function renderSticky(notes = []) {
    const note = notes[0];
    if (!note) return null;
    const sticky = el('article', { className: 'workspace-sticky' });
    sticky.appendChild(el('span', { className: 'push-pin', attrs: { 'aria-hidden': 'true' } }));
    sticky.appendChild(el('p', { text: note.text }));
    return sticky;
  }

  function renderShiftTickets(shifts = []) {
    const wrap = el('section', { className: 'workspace-shifts', attrs: { 'aria-label': 'Shift tickets' } });
    shifts.slice(0, 3).forEach((shift) => {
      const ticket = el('article', { className: 'workspace-ticket' });
      ticket.appendChild(el('span', { className: 'ticket-unit', text: 'ICU' }));
      ticket.appendChild(el('strong', { text: `${shift.day} ${shift.number}` }));
      ticket.appendChild(el('span', { className: 'ticket-time', text: shift.label.replace('ICU · ', '') }));
      ticket.appendChild(el('span', { className: 'ticket-barcode', attrs: { 'aria-hidden': 'true' } }));
      wrap.appendChild(ticket);
    });

    const calendar = el('button', { className: 'workspace-calendar', attrs: { type: 'button' } });
    calendar.appendChild(el('span', { text: '▦' }));
    calendar.appendChild(el('small', { text: 'Calendar' }));
    wrap.appendChild(calendar);
    return wrap;
  }

  function renderDeskObjects() {
    const objects = el('div', { className: 'workspace-props', attrs: { 'aria-hidden': 'true' } });
    objects.appendChild(el('div', { className: 'coffee-mug', text: 'FOCUS\nFAMILY\nFREEDOM' }));
    objects.appendChild(el('div', { className: 'desk-pen' }));
    objects.appendChild(el('div', { className: 'leather-corner' }));
    objects.appendChild(el('div', { className: 'plant-shadow' }));
    objects.appendChild(el('div', { className: 'coffee-ring' }));
    return objects;
  }

  function renderSceneSwitcher(scenes, activeSceneId, onSelect) {
    const wrap = el('section', { className: 'workspace-scene-switcher' });
    const row = el('div', { className: 'workspace-scene-row' });
    scenes.forEach((scene) => {
      const button = el('button', {
        className: `workspace-scene-chip ${scene.id === activeSceneId ? 'active' : ''}`,
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

  function renderTodayWorkspaceView(root, state, storyInput = {}) {
    if (!root) throw new Error('Today workspace view requires a root element.');
    if (!state) throw new Error('Today workspace view requires state.');

    const scenes = storyInput.environmentScenes || DEFAULT_SCENES;
    const fallbackSceneId = (storyInput.environment && storyInput.environment.id) || 'desk';
    const activeSceneId = getStoredSceneId(fallbackSceneId);

    root.innerHTML = '';
    root.className = `today-workspace-root workspace-${activeSceneId}`;

    const stage = el('article', { className: 'workspace-stage' });
    stage.appendChild(renderDeskObjects());
    stage.appendChild(renderNotebook(state, storyInput));
    stage.appendChild(renderMoneyEnvelope(storyInput.freedomChoice));
    const sticky = renderSticky(storyInput.brainNotes || []);
    if (sticky) stage.appendChild(sticky);
    stage.appendChild(renderShiftTickets(storyInput.nextShifts || []));

    root.appendChild(stage);
    root.appendChild(renderSceneSwitcher(scenes, activeSceneId, (sceneId, switcher) => setScene(root, sceneId, switcher)));

    return {
      rendered: true,
      mode: 'today-workspace-demo',
      structure: 'realistic-desk-objects-with-live-data',
      sceneCount: scenes.length
    };
  }

  global.PerchTodayWorkspaceView = {
    renderTodayWorkspaceView
  };

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = global.PerchTodayWorkspaceView;
  }
})(typeof window !== 'undefined' ? window : globalThis);
