#!/usr/bin/env node
/*
 * Perch Fixture Runner
 * --------------------
 * Minimal validation helper for JSON fixtures.
 *
 * Current scope:
 * - validates fixture shape
 * - executes extracted domain/engine behavior for money, capture, and priority
 */

const fs = require('fs');
const path = require('path');

const PerchMoney = require('../src/domain/money.js');
const PerchCapture = require('../src/domain/capture.js');
const PerchPriority = require('../src/engines/priority.js');

const repoRoot = path.resolve(__dirname, '..');
const fixtureRoot = path.join(repoRoot, 'tests', 'fixtures');

function walkJsonFiles(dir) {
  if (!fs.existsSync(dir)) return [];

  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJsonFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith('.json')) {
      files.push(fullPath);
    }
  }

  return files;
}

function readJson(filePath) {
  const raw = fs.readFileSync(filePath, 'utf8');
  return JSON.parse(raw);
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function assertEqual(actual, expected, message) {
  if (actual !== expected) {
    throw new Error(`${message}. Expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

function assertArrayEqual(actual, expected, message) {
  const actualJson = JSON.stringify(actual || []);
  const expectedJson = JSON.stringify(expected || []);
  if (actualJson !== expectedJson) {
    throw new Error(`${message}. Expected ${expectedJson}, got ${actualJson}`);
  }
}

function assertIncludesAll(actualWords, expectedWords, message) {
  const haystack = (actualWords || []).join(' ').toLowerCase();
  const missing = (expectedWords || []).filter((word) => !haystack.includes(String(word).toLowerCase()));
  if (missing.length) {
    throw new Error(`${message}. Missing ${JSON.stringify(missing)} from ${JSON.stringify(actualWords)}`);
  }
}

function validateFixture(fixture, relativePath) {
  assert(fixture && typeof fixture === 'object', `${relativePath}: fixture must be an object`);
  assert(typeof fixture.name === 'string' && fixture.name.length > 0, `${relativePath}: missing name`);
  assert(typeof fixture.status === 'string' && fixture.status.length > 0, `${relativePath}: missing status`);
  assert(typeof fixture.description === 'string' && fixture.description.length > 0, `${relativePath}: missing description`);
  assert(fixture.given && typeof fixture.given === 'object', `${relativePath}: missing given object`);
  assert(fixture.expect && typeof fixture.expect === 'object', `${relativePath}: missing expect object`);

  return true;
}

function validateMoneyFixture(fixture, relativePath) {
  if (!relativePath.endsWith('tests/fixtures/money/bills-before-payday-basic.json')) return;

  const result = PerchMoney.billsBeforePayday(fixture.given);

  assertEqual(result.billsBeforePayday, fixture.expect.billsBeforePayday, `${relativePath}: billsBeforePayday mismatch`);
  assertEqual(result.cushionBeforePayday, fixture.expect.cushionBeforePayday, `${relativePath}: cushionBeforePayday mismatch`);
  assertEqual(result.classification, fixture.expect.classification, `${relativePath}: classification mismatch`);
  assertArrayEqual(result.excludedBills, fixture.expect.excludedBills, `${relativePath}: excludedBills mismatch`);
}

function validateCaptureFixture(fixture, relativePath) {
  if (!relativePath.startsWith('tests/fixtures/capture/')) return;

  const result = PerchCapture.parseCapture(fixture.given);

  assertEqual(result.parsedType, fixture.expect.parsedType, `${relativePath}: parsedType mismatch`);
  assertEqual(result.lifecycle, fixture.expect.lifecycle, `${relativePath}: lifecycle mismatch`);
  assertEqual(result.classification, fixture.expect.classification, `${relativePath}: classification mismatch`);

  if (fixture.expect.dueDate) {
    assertEqual(result.dueDate, fixture.expect.dueDate, `${relativePath}: dueDate mismatch`);
  }

  if (fixture.expect.timeHint) {
    assertEqual(result.timeHint, fixture.expect.timeHint, `${relativePath}: timeHint mismatch`);
  }

  if (fixture.expect.personHint) {
    assertEqual(result.personHint, fixture.expect.personHint, `${relativePath}: personHint mismatch`);
  }

  if (fixture.expect.completionAction) {
    assertEqual(result.completionAction, fixture.expect.completionAction, `${relativePath}: completionAction mismatch`);
  }

  if (fixture.expect.titleIncludes) {
    assertIncludesAll(result.titleWords, fixture.expect.titleIncludes, `${relativePath}: title words mismatch`);
  }
}

function validatePriorityFixture(fixture, relativePath) {
  if (!relativePath.endsWith('tests/fixtures/priority/urgent-money-before-low-task.json')) return;

  const result = PerchPriority.rankCandidates(fixture.given);
  const orderedCandidateIds = result.ordered.map((item) => item.candidateId);

  assertEqual(result.top && result.top.candidateId, fixture.expect.topCandidateId, `${relativePath}: topCandidateId mismatch`);
  assertArrayEqual(orderedCandidateIds, fixture.expect.orderedCandidateIds, `${relativePath}: orderedCandidateIds mismatch`);

  if (fixture.expect.requiredReasonIncludes) {
    assertIncludesAll(result.top && result.top.reasons, fixture.expect.requiredReasonIncludes, `${relativePath}: priority reasons mismatch`);
  }
}

function validateBehavior(fixture, relativePath) {
  validateMoneyFixture(fixture, relativePath);
  validateCaptureFixture(fixture, relativePath);
  validatePriorityFixture(fixture, relativePath);
}

function main() {
  const files = walkJsonFiles(fixtureRoot);
  const results = [];

  for (const file of files) {
    const relativePath = path.relative(repoRoot, file);
    try {
      const fixture = readJson(file);
      validateFixture(fixture, relativePath);
      validateBehavior(fixture, relativePath);
      results.push({ file: relativePath, ok: true });
    } catch (error) {
      results.push({ file: relativePath, ok: false, error: error.message });
    }
  }

  const failed = results.filter((result) => !result.ok);

  console.log(`Perch fixture runner`);
  console.log(`Fixtures checked: ${results.length}`);
  console.log(`Passed: ${results.length - failed.length}`);
  console.log(`Failed: ${failed.length}`);

  if (failed.length) {
    console.log('\nFailures:');
    failed.forEach((failure) => {
      console.log(`- ${failure.file}: ${failure.error}`);
    });
    process.exit(1);
  }

  process.exit(0);
}

main();
