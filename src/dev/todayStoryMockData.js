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
    headline: 'You are not behind. You have one real thing to look at first.',
    money: {
      checkingBalance: 1840,
      nextPayday: '2026-07-12',
      bills: [
        {
          id: 'bill_mortgage_bronze',
          name: 'Bronze mortgage',
          amount: 3191,
          dueDate: '2026-07-08',
          status: 'unpaid'
        },
        {
          id: 'bill_power',
          name: 'Duke Energy',
          amount: 246,
          dueDate: '2026-07-10',
          status: 'unpaid'
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
      prompt: 'You should have about $800 left after bills.',
      responsibleAction: 'Transfer $500 to savings',
      funAction: 'Keep $150 for something fun this week',
      irresponsibleAction: 'Show me safe ridiculous ideas under $200'
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
      label: 'Using fake story data'
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
    storyDetails: {
      firstSecond: 'A calm page opens. Your eye should land on the sentence, not the navigation.',
      firstFiveSeconds: 'You should know the day is mostly okay, but money needs the first look.',
      firstMinute: 'You should see why Perch thinks that, what can wait, and what source is uncertain.'
    }
  });

  global.PerchTodayStoryMockData = PerchTodayStoryMockData;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = PerchTodayStoryMockData;
  }
})(typeof window !== 'undefined' ? window : globalThis);
