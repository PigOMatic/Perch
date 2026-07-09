import 'perch_today_models.dart';

const demoTodayData = PerchTodayData(
  dayStatus: 'Sun 5 · Off',
  resetLine: 'Reset day.',
  nextDue: DueItem(
    title: 'Bronze mortgage · Jul 8',
    actionLabel: 'Check payment',
  ),
  money: MoneySnapshot(
    availableText: r'$800 available',
    safeThroughText: 'Safe through Jul 12 payday',
  ),
  brainNote: 'Check if payment pulled',
  shifts: [
    ShiftTicketData(day: 'Mon 6', unit: 'ICU', time: '7p'),
    ShiftTicketData(day: 'Mon 13', unit: 'ICU', time: '7p'),
    ShiftTicketData(day: 'Tue 14', unit: 'ICU', time: '7p'),
  ],
);
