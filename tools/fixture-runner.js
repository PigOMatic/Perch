#!/usr/bin/env node
/*
 * Perch Fixture Runner
 * --------------------
 * Minimal validation helper for JSON fixtures.
 *
 * Current scope:
 * - validates fixture shape
 * - executes the first extracted domain behavior: money/bills-before-payday
 */

const fs = require('fs');
const path = require('path');

const PerchMoney = require('../src/domain/money.js');

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

function validateBehavior(fixture, relativePath) {
  validateMoneyFixture(fixture, relativePath);
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
