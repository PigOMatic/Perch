/*
 * Perch Today Story Mock Data
 * ---------------------------
 * Rich fake data for evaluating the Today experience.
 *
 * This is not user data and not an integration fixture.
 */

(function attachPerchTodayStoryMockData(global) {
  'use strict';

  const PerchTodayStoryMockData = Object.freeze({
    today: '2026-07-05',
    headline: 'Today is mostly steady.',
    layoutMode: 'money-heavy',
    layoutReason: 'money need is highest and wants are still available',
    money: {
      checkingBalance: 1840,
      nextPayday: '2026-07-12',
      bills: [
        {
          id: 'bill_mortgage_bronze',
          name: 'Bronze mortgage',
          amount: 3191,
          dueDate: '2026-07-08',
          status: 'due'
        },
        {
          id: 'bill_power',
          name: 'Duke Energy',
          amount: 246,
          dueDate: '2026-07-10',
          status: 'due'
        },
        {
          id: 'bill_rv',
          name: 'RV loan',
          amount: 843,
          dueDate: '2026-07-15',
          status: 'scheduled'
        }
      ]
    },
    freedomChoice: {
      leftAfterBills: 800,
      safeToOffer: true,
      prompt: '$800 open after bills',
      note: 'The bills are counted. The choice is what this money should do next.',
      safeAction: 'Keep it safe',
      littleAction: 'Use a little',
      towardAction: 'Put it toward something'
    },
    weekSchedule: [
      { day: 'Sun', number: '5', label: 'Off', detail: 'Reset day', status: 'off' },
      { day: 'Mon', number: '6', label: 'Work', detail: 'ICU · 7p', status: 'work' },
      { day: 'Tue', number: '7', label: 'Recover', detail: 'Sleep after shift', status: 'recover' },
      { day: 'Wed', number: '8', label: 'Off', detail: 'Bill check', status: 'event' },
      { day: 'Thu', number: '9', label: 'Off', detail: 'Open', status: 'off' },
      { day: 'Fri', number: '10', label: 'Off', detail: 'Power due', status: 'event' },
      { day: 'Sat', number: '11', label: 'Off', detail: 'Family', status: 'off' }
    ],
    nextEvent: {
      label: 'Next due',
      title: 'Bronze mortgage · Jul 8',
      detail: 'Check if the payment pulled tomorrow morning.',
      sourceNote: 'Balance typed yesterday'
    },
    captures: [
      {
        text: 'remind me to check if the mortgage payment pulled tomorrow morning',
        createdAt: '2026-07-05T07:35:00-04:00'
      },
      {
        text: 'waiting on Maura to send the insurance card picture',
        createdAt: '2026-07-05T08:12:00-04:00'
      },
      {
        text: 'idea: make the Perch Today page feel like opening a worn field guide',
        createdAt: '2026-07-05T09:02:00-04:00'
      }
    ],
    priorityCandidates: [
      {
        id: 'mortgage_cash_gap',
        title: 'Mortgage is due before payday and the cushion is thin',
        consequence: 'high',
        urgency: 'soon',
        domain: 'money'
      },
      {
        id: 'work_shift_tomorrow',
        title: 'Night shift tomorrow, protect sleep and errands today',
        consequence: 'medium',
        urgency: 'soon',
        domain: 'schedule'
      },
      {
        id: 'barn_cleanup',
        title: 'Clean up barn corner before it gets worse',
        consequence: 'low',
        urgency: 'later',
        domain: 'property'
      }
    ],
    recommendation: {
      id: 'make_one_money_check',
      title: 'Make one money check before noon',
      suppressedIds: []
    },
    trustStatement: {
      id: 'checking_balance_manual',
      text: 'Checking balance was typed in manually yesterday.',
      source: 'manual',
      lastVerifiedAt: '2026-07-04T19:15:00-04:00',
      claimType: 'balance'
    },
    sourceIndicator: {
      source: 'story-mock-data',
      mode: 'demo',
      label: 'Balance typed yesterday'
    },
    people: [
      { id: 'person_maura', name: 'Maura', relationship: 'wife' },
      { id: 'person_sam', name: 'Sam', relationship: 'son', birthday: '2022-04-28' },
      { id: 'person_noah', name: 'Noah', relationship: 'son' }
    ],
    workShifts: [
      {
        id: 'shift_2026_07_06',
        date: '2026-07-06',
        start: '19:00',
        end: '23:59',
        label: 'ICU night shift'
      }
    ],
    schedulePreview: [
      {
        date: '2026-07-05',
        day: 'Sun',
        number: '5',
        status: 'off',
        label: 'Off',
        detail: 'Family / reset day'
      },
      {
        date: '2026-07-06',
        day: 'Mon',
        number: '6',
        status: 'work',
        label: 'Work',
        detail: 'ICU · 7p'
      },
      {
        date: '2026-07-07',
        day: 'Tue',
        number: '7',
        status: 'recover',
        label: 'Recover',
        detail: 'Sleep after shift'
      }
    ],
    storyDetails: {
      firstSecond: 'The page opens smaller now and lets scale, placement, and available choices show what matters.',
      firstFiveSeconds: 'You should see the money options, the bills tab, and the week rhythm without being told what to do first.',
      firstMinute: 'Bill detail stays tucked until pressed.'
    }
  });

  global.PerchTodayStoryMockData = PerchTodayStoryMockData;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryMockData;
  }
})(typeof window !== 'undefined' ? window : globalThis);
