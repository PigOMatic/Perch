/*
 * Perch Layout Roles
 * ------------------
 * Canonical layout anatomy shared across Perch surfaces.
 *
 * These are product/layout roles, not visual components.
 */

(function attachPerchLayoutRoles(global) {
  'use strict';

  const ROLES = Object.freeze({
    ORIENTATION: 'orientation',
    PRIMARY_MARKER: 'primary-marker',
    TERRAIN_CONTEXT: 'terrain-context',
    MARGIN_NOTES: 'margin-notes',
    TRUST_SOURCE: 'trust-source',
    NEXT_STEP: 'next-step',
    CAN_WAIT: 'can-wait'
  });

  const ROLE_ORDER = Object.freeze([
    ROLES.ORIENTATION,
    ROLES.PRIMARY_MARKER,
    ROLES.TERRAIN_CONTEXT,
    ROLES.MARGIN_NOTES,
    ROLES.TRUST_SOURCE,
    ROLES.NEXT_STEP,
    ROLES.CAN_WAIT
  ]);

  const ROLE_LABELS = Object.freeze({
    [ROLES.ORIENTATION]: 'Orientation',
    [ROLES.PRIMARY_MARKER]: 'Primary marker',
    [ROLES.TERRAIN_CONTEXT]: 'Terrain context',
    [ROLES.MARGIN_NOTES]: 'Margin notes',
    [ROLES.TRUST_SOURCE]: 'Trust and source',
    [ROLES.NEXT_STEP]: 'Next step',
    [ROLES.CAN_WAIT]: 'Can wait'
  });

  function getRoles() {
    return ROLE_ORDER.map((id) => ({
      id,
      label: ROLE_LABELS[id]
    }));
  }

  function hasRole(id) {
    return ROLE_ORDER.includes(id);
  }

  const PerchLayoutRoles = Object.freeze({
    ROLES,
    ROLE_ORDER,
    ROLE_LABELS,
    getRoles,
    hasRole
  });

  global.PerchLayoutRoles = PerchLayoutRoles;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchLayoutRoles;
  }
})(typeof window !== 'undefined' ? window : globalThis);
