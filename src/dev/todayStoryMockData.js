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
    headline: 'Today',
    environment: {
      id: 'desk',
      label: 'Desk morning',
      note: 'Same run sheet. Different place.'
    },
    environmentScenes: [
      { id: 'desk', label: 'Desk', detail: 'coffee morning' },
      { id: 'patio', label: 'Patio', detail: 'warm outside' },
      { id: 'firepit', label: 'Firepit', detail: 'evening glow' },
      { id: 'trail', label: 'Trail', detail: 'field guide' },
      { id: 'breakroom', label: 'Break room', detail: 'work night' }
    ],
    layoutMode: 'money-heavy',
    alwaysShow: ['Bills', 'Work', 'Brain notes'],
    todayStatus: {
      label: 'Today',
      title: 'Sun 5 · Off',
      detail: 'Reset day.'
    },
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
      note: 'Counted through Jul 12 payday.',
      safeAction: 'Keep it safe',
      littleAction: 'Use a little',
      towardAction: 'Put it toward something'
    },
    nextDue: {
      label: 'Next due',
      title: 'Bronze mortgage · Jul 8',
      detail: 'Affects the $800 number.',
      action: 'Check payment'
    },
    nextShifts: [
      { day: 'Mon', number: '6', label: 'ICU · 7p', detail: 'Night shift' },
      { day: 'Mon', number: '13', label: 'ICU · 7p', detail: 'Night shift' },
      { day: 'Tue', number: '14', label: 'ICU · 7p', detail: 'Night shift' }
    ],
    dueSoon: {
      label: 'Due soon',
      title: 'Duke Energy · Jul 10',
      detail: '$246 after mortgage.',
      action: 'Review bills'
    },
    brainNotes: [
      {
        id: 'note_payment_pulled',
        text: 'Check if payment pulled',
        attachedTo: 'nextDue'
      },
      {
        id: 'note_noah_birthday',
        text: 'Don\'t forget Noah\'s game Sat 10am',
        attachedTo: 'today'
      }
    ],
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
      firstSecond: 'The run sheet sits in a calm place and shows useful information without explaining itself.',
      firstFiveSeconds: 'You should see next due, money, next shifts, due soon, and a small brain note if it matters.',
      firstMinute: 'The same run sheet can be viewed in different environments without changing the core information.'
    }
  });

  global.PerchTodayStoryMockData = PerchTodayStoryMockData;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryMockData;
  }
})(typeof window !== 'undefined' ? window : globalThis);
