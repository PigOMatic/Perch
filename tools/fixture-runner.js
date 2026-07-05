#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const PerchMoney = require('../src/domain/money.js');
const PerchCapture = require('../src/domain/capture.js');
const PerchPriority = require('../src/engines/priority.js');
const PerchRecommendation = require('../src/engines/recommendation.js');
const PerchTruth = require('../src/engines/truth.js');
const PerchRoutes = require('../src/ui/routes.js');
const PerchTodayState = require('../src/state/todayState.js');
const PerchTodayStorageInput = require('../src/state/todayStorageInput.js');

globalThis.PerchMoney = PerchMoney;
globalThis.PerchCapture = PerchCapture;
globalThis.PerchPriority = PerchPriority;
globalThis.PerchRecommendation = PerchRecommendation;
globalThis.PerchTruth = PerchTruth;

const repoRoot = path.resolve(__dirname, '..');
const fixtureRoot = path.join(repoRoot, 'tests', 'fixtures');

function files(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) return files(full);
    if (entry.isFile() && entry.name.endsWith('.json')) return [full];
    return [];
  });
}

function read(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function fail(message) {
  throw new Error(message);
}

function same(actual, expected, label) {
  if (actual !== expected) fail(`${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
}

function sameArray(actual, expected, label) {
  const a = JSON.stringify(actual || []);
  const e = JSON.stringify(expected || []);
  if (a !== e) fail(`${label}: expected ${e}, got ${a}`);
}

function includesAll(actual, expected, label) {
  const haystack = (actual || []).join(' ').toLowerCase();
  const missing = (expected || []).filter((word) => !haystack.includes(String(word).toLowerCase()));
  if (missing.length) fail(`${label}: missing ${JSON.stringify(missing)}`);
}

function shape(f, rel) {
  if (!f || typeof f !== 'object') fail(`${rel}: fixture must be object`);
  ['name', 'status', 'description'].forEach((key) => {
    if (!f[key]) fail(`${rel}: missing ${key}`);
  });
  if (!f.given || typeof f.given !== 'object') fail(`${rel}: missing given`);
  if (!f.expect || typeof f.expect !== 'object') fail(`${rel}: missing expect`);
}

function checkMoney(f, rel) {
  if (!rel.endsWith('tests/fixtures/money/bills-before-payday-basic.json')) return;
  const r = PerchMoney.billsBeforePayday(f.given);
  same(r.billsBeforePayday, f.expect.billsBeforePayday, `${rel} billsBeforePayday`);
  same(r.cushionBeforePayday, f.expect.cushionBeforePayday, `${rel} cushionBeforePayday`);
  same(r.classification, f.expect.classification, `${rel} classification`);
  sameArray(r.excludedBills, f.expect.excludedBills, `${rel} excludedBills`);
}

function checkCapture(f, rel) {
  if (!rel.startsWith('tests/fixtures/capture/')) return;
  const r = PerchCapture.parseCapture(f.given);
  same(r.parsedType, f.expect.parsedType, `${rel} parsedType`);
  same(r.lifecycle, f.expect.lifecycle, `${rel} lifecycle`);
  same(r.classification, f.expect.classification, `${rel} classification`);
  if (f.expect.dueDate) same(r.dueDate, f.expect.dueDate, `${rel} dueDate`);
  if (f.expect.timeHint) same(r.timeHint, f.expect.timeHint, `${rel} timeHint`);
  if (f.expect.personHint) same(r.personHint, f.expect.personHint, `${rel} personHint`);
  if (f.expect.completionAction) same(r.completionAction, f.expect.completionAction, `${rel} completionAction`);
  if (f.expect.titleIncludes) includesAll(r.titleWords, f.expect.titleIncludes, `${rel} titleIncludes`);
}

function checkPriority(f, rel) {
  if (!rel.endsWith('tests/fixtures/priority/urgent-money-before-low-task.json')) return;
  const r = PerchPriority.rankCandidates(f.given);
  same(r.top && r.top.candidateId, f.expect.topCandidateId, `${rel} topCandidateId`);
  sameArray(r.ordered.map((item) => item.candidateId), f.expect.orderedCandidateIds, `${rel} orderedCandidateIds`);
  includesAll(r.top && r.top.reasons, f.expect.requiredReasonIncludes, `${rel} reasons`);
}

function checkRecommendation(f, rel) {
  if (!rel.endsWith('tests/fixtures/recommendations/suppressed-recommendation.json')) return;
  const r = PerchRecommendation.evaluateRecommendation(f.given);
  same(r.shouldShow, f.expect.shouldShow, `${rel} shouldShow`);
  same(r.suppressed, f.expect.suppressed, `${rel} suppressed`);
  same(r.suppressionReason, f.expect.suppressionReason, `${rel} suppressionReason`);
  same(r.userActionRequired, f.expect.userActionRequired, `${rel} userActionRequired`);
}

function checkTruth(f, rel) {
  if (!rel.endsWith('tests/fixtures/trust/manual-stale-balance.json')) return;
  const r = PerchTruth.evaluateStatement(f.given);
  same(r.truthStatus, f.expect.truthStatus, `${rel} truthStatus`);
  same(r.requiredLabel, f.expect.requiredLabel, `${rel} requiredLabel`);
  same(r.shouldShowAsCertain, f.expect.shouldShowAsCertain, `${rel} shouldShowAsCertain`);
  same(r.trustNoticeSeverity, f.expect.trustNoticeSeverity, `${rel} trustNoticeSeverity`);
}

function checkUi(f, rel) {
  if (!rel.endsWith('tests/fixtures/ui/app-shell-routes.json')) return;
  const routes = PerchRoutes.getRoutes();
  const todayRoute = PerchRoutes.findRoute('today');
  const routeIds = routes.map((route) => route.id);
  same(routes.length, f.expect.routeCount, `${rel} routeCount`);
  same(PerchRoutes.findRoute(f.expect.defaultRouteId).id, f.expect.defaultRouteId, `${rel} defaultRouteId`);
  includesAll(routeIds, f.given.requiredRoutes, `${rel} requiredRoutes`);
  same(todayRoute.status, f.expect.todayStatus, `${rel} todayStatus`);
  same(todayRoute.rebuildPolicy, f.expect.todayRebuildPolicy, `${rel} todayRebuildPolicy`);
  same(todayRoute.legacyRole, f.expect.todayLegacyRole, `${rel} todayLegacyRole`);
  if (f.expect.legacyLinksRequired) {
    routes.forEach((route) => {
      if (!route.legacyFile) fail(`${rel}: route ${route.id} missing legacyFile`);
    });
  }
}

function checkTodayState(f, rel) {
  if (!rel.endsWith('tests/fixtures/state/today-state-basic.json')) return;
  const r = PerchTodayState.buildTodayState(f.given);
  same(r.pageId, f.expect.pageId, `${rel} pageId`);
  same(r.mode, f.expect.mode, `${rel} mode`);
  same(r.legacyFallback, f.expect.legacyFallback, `${rel} legacyFallback`);
  sameArray(r.sections.map((section) => section.id), f.expect.sectionIds, `${rel} sectionIds`);
  same(Boolean(r.trustNotice), f.expect.trustNoticeRequired, `${rel} trustNoticeRequired`);
  same(Boolean(r.sourceIndicator), f.expect.sourceIndicatorRequired, `${rel} sourceIndicatorRequired`);
  same(r.sourceIndicator && r.sourceIndicator.source, f.expect.sourceIndicator, `${rel} sourceIndicator`);
}

function checkTodayView(f, rel) {
  if (!rel.endsWith('tests/fixtures/ui/today-view-renderer.json')) return;
  same(f.expect.renderer, 'PerchTodayView.renderTodayView', `${rel} renderer`);
  same(f.expect.requiresHero, true, `${rel} requiresHero`);
  same(f.expect.requiresAttentionCard, true, `${rel} requiresAttentionCard`);
  same(f.expect.requiresTrustNoteSupport, true, `${rel} requiresTrustNoteSupport`);
  same(f.expect.requiresSourceIndicatorSupport, true, `${rel} requiresSourceIndicatorSupport`);
  same(f.expect.requiresLegacyFallback, true, `${rel} requiresLegacyFallback`);
  same(f.expect.legacyIsVisualTarget, false, `${rel} legacyIsVisualTarget`);
}

function checkTodayStorageInput(f, rel) {
  if (!rel.endsWith('tests/fixtures/state/today-storage-input-basic.json')) return;
  const r = PerchTodayStorageInput.buildTodayInputFromStorageSnapshot(f.given.snapshot, f.given.fallbackInput);
  same(r.money.checkingBalance, f.expect.checkingBalance, `${rel} checkingBalance`);
  same(r.money.nextPayday, f.expect.nextPayday, `${rel} nextPayday`);
  sameArray(r.money.bills.map((bill) => bill.id), f.expect.billIds, `${rel} billIds`);
  same(r.captures.length, f.expect.captureCount, `${rel} captureCount`);
  same(r.sourceIndicator.source, f.expect.sourceIndicator, `${rel} sourceIndicator`);
  same(r.sourceIndicator.label, f.expect.sourceLabel, `${rel} sourceLabel`);
  same(r.storageRead.mode, f.expect.storageMode, `${rel} storageMode`);
  same(r.storageRead.wroteData, f.expect.wroteData, `${rel} wroteData`);
  same(r.storageRead.migratedData, f.expect.migratedData, `${rel} migratedData`);
}

const results = files(fixtureRoot).map((file) => {
  const rel = path.relative(repoRoot, file);
  try {
    const fixture = read(file);
    shape(fixture, rel);
    checkMoney(fixture, rel);
    checkCapture(fixture, rel);
    checkPriority(fixture, rel);
    checkRecommendation(fixture, rel);
    checkTruth(fixture, rel);
    checkUi(fixture, rel);
    checkTodayState(fixture, rel);
    checkTodayView(fixture, rel);
    checkTodayStorageInput(fixture, rel);
    return { rel, ok: true };
  } catch (error) {
    return { rel, ok: false, error: error.message };
  }
});

const failed = results.filter((r) => !r.ok);
console.log('Perch fixture runner');
console.log(`Fixtures checked: ${results.length}`);
console.log(`Passed: ${results.length - failed.length}`);
console.log(`Failed: ${failed.length}`);

if (failed.length) {
  failed.forEach((f) => console.log(`- ${f.rel}: ${f.error}`));
  process.exit(1);
}
