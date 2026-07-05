/*
 * Perch App Shell
 * ---------------
 * First clean shell scaffold for the UI rebuild.
 *
 * This does not replace the restored HTML pages. It creates a safe target
 * shell that can render beside legacy pages until replacements are ready.
 */

(function attachPerchShell(global) {
  'use strict';

  function createElement(tag, options = {}) {
    const element = document.createElement(tag);
    if (options.className) element.className = options.className;
    if (options.text) element.textContent = options.text;
    if (options.html) element.innerHTML = options.html;
    if (options.attrs) {
      Object.entries(options.attrs).forEach(([key, value]) => element.setAttribute(key, value));
    }
    return element;
  }

  function renderNav(routes, activeRouteId) {
    const nav = createElement('nav', { className: 'perch-shell-nav', attrs: { 'aria-label': 'Perch sections' } });

    routes.forEach((route) => {
      const item = createElement('a', {
        className: route.id === activeRouteId ? 'active' : '',
        text: route.label,
        attrs: {
          href: `#${route.id}`,
          'data-route-id': route.id
        }
      });
      nav.appendChild(item);
    });

    return nav;
  }

  function renderLegacyLink(route) {
    if (!route || !route.legacyFile) return null;

    return createElement('a', {
      className: 'perch-legacy-link',
      text: `Open legacy ${route.label}`,
      attrs: {
        href: route.legacyFile
      }
    });
  }

  function renderPagePlaceholder(route) {
    const section = createElement('section', { className: 'perch-page-placeholder' });
    section.appendChild(createElement('p', { className: 'eyebrow', text: 'Rebuild scaffold' }));
    section.appendChild(createElement('h2', { text: route ? route.label : 'Unknown route' }));
    section.appendChild(createElement('p', {
      text: 'This page is not rebuilt yet. The legacy implementation remains available while the new shell is developed.'
    }));

    const legacyLink = renderLegacyLink(route);
    if (legacyLink) section.appendChild(legacyLink);

    return section;
  }

  function renderShell(root, options = {}) {
    if (!root) throw new Error('Perch shell requires a root element.');

    const routesApi = global.PerchRoutes;
    const routes = routesApi ? routesApi.getRoutes() : [];
    const activeRouteId = options.activeRouteId || 'today';
    const activeRoute = routesApi ? routesApi.findRoute(activeRouteId) : routes[0];

    root.innerHTML = '';
    root.className = 'perch-shell-root';

    const header = createElement('header', { className: 'perch-shell-header' });
    header.appendChild(createElement('p', { className: 'eyebrow', text: 'Perch' }));
    header.appendChild(createElement('h1', { text: 'Clarity, beautifully designed.' }));
    header.appendChild(createElement('p', {
      className: 'lede',
      text: 'A clean rebuild shell beside the restored prototype. Nothing legacy is replaced yet.'
    }));

    root.appendChild(header);
    root.appendChild(renderNav(routes, activeRouteId));
    root.appendChild(renderPagePlaceholder(activeRoute));

    return {
      activeRouteId,
      routeCount: routes.length
    };
  }

  const PerchShell = Object.freeze({
    renderShell,
    renderNav,
    renderPagePlaceholder
  });

  global.PerchShell = PerchShell;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchShell;
  }
})(typeof window !== 'undefined' ? window : globalThis);
