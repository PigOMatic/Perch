/*
 * Perch Today Sample Data
 * -----------------------
 * Development-only sample data for the rebuilt Today preview.
 *
 * This is not user data and not live integration data.
 */

(function attachPerchTodaySampleData(global) {
  'use strict';

  const todaySampleData = Object.freeze({
    today: '2026-07-05',
    headline: 'You are clear enough to move with intention.',
    money: {
      checkingBalance: 1200,
      nextPayday: '2026-07-12',
      bills: [
        {
          id: 'bill_mortgage',
          name: 'Mortgage',
          amount: 800,
          dueDate: '2026-07-08',
          paidStatus: 'unpaid'
        }
      ]
    },
    captures: [
      {
        rawText: 'remind me to call the dentist tomorrow at 10am'
      },
      {
        rawText: 'waiting on Maura to send the insurance card'
      }
    ],
    priorityCandidates: [
      {
        id: 'money_low_cushion',
        domain: 'money',
        urgencySignals: ['due_before_payday', 'low_cushion'],
        consequenceSignals: ['missed_bill_risk']
      },
      {
        id: 'task_clean_barn',
        domain: 'project',
        urgencySignals: [],
        consequenceSignals: ['low']
      }
    ],
    recommendation: {
      candidateRecommendation: {
        id: 'rec_add_more_detail_to_goal',
        title: 'Add more detail to your goal'
      },
      preferences: {
        suppressedRecommendationIds: ['rec_add_more_detail_to_goal']
      }
    },
    trustStatement: {
      statement: 'You have $1,200 available before payday.',
      source: {
        id: 'checkingBalance',
        type: 'manual_entry',
        value: 1200,
        timestamp: '2026-06-20T08:00:00-04:00',
        confidence: 0.55
      }
    }
  });

  global.PerchTodaySampleData = todaySampleData;

  if (typeof module !== 'undefined' && module.exports) {
    module.exports = todaySampleData;
  }
})(typeof window !== 'undefined' ? window : globalThis);
