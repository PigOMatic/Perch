class PerchTodayData {
  const PerchTodayData({
    required this.dayStatus,
    required this.resetLine,
    required this.nextDue,
    required this.money,
    required this.shifts,
    required this.brainNote,
  });

  final String dayStatus;
  final String resetLine;
  final DueItem nextDue;
  final MoneySnapshot money;
  final List<ShiftTicketData> shifts;
  final String brainNote;
}

class DueItem {
  const DueItem({
    required this.title,
    required this.actionLabel,
  });

  final String title;
  final String actionLabel;
}

class MoneySnapshot {
  const MoneySnapshot({
    required this.availableText,
    required this.safeThroughText,
  });

  final String availableText;
  final String safeThroughText;
}

class ShiftTicketData {
  const ShiftTicketData({
    required this.day,
    required this.unit,
    required this.time,
  });

  final String day;
  final String unit;
  final String time;
}
