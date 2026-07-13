import 'package:flutter/material.dart';

import '../../data/perch_today_models.dart';
import 'desk_object_sheet.dart';

Future<void> showJournalWorkspace(
  BuildContext context, {
  required PerchTodayData data,
}) {
  return showDeskObjectSheet<void>(
    context: context,
    semanticsLabel: 'Journal workspace',
    initialChildSize: .78,
    minChildSize: .40,
    maxChildSize: .96,
    builder: (sheetContext) => DeskObjectSheetBody(
      eyebrow: 'Journal',
      title: 'Today',
      trailing: IconButton(
        tooltip: 'Return journal to desk',
        onPressed: () => Navigator.pop(sheetContext),
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 34),
      child: _RuledJournalPage(data: data),
    ),
  );
}

class _RuledJournalPage extends StatelessWidget {
  const _RuledJournalPage({required this.data});

  final PerchTodayData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('ruled-journal-page'),
      constraints: const BoxConstraints(minHeight: 560),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD7C8AA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _JournalRulePainter())),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(42, 26, 20, 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.dayStatus,
                  style: const TextStyle(
                    color: Color(0xFF2F2419),
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                _JournalSection(
                  title: 'What matters next',
                  children: [
                    _JournalLine(
                      leading: Icons.radio_button_unchecked,
                      title: data.nextDue.title,
                      subtitle: data.nextDue.actionLabel,
                    ),
                  ],
                ),
                _JournalSection(
                  title: 'Money',
                  children: [
                    _JournalLine(
                      leading: Icons.account_balance_wallet_outlined,
                      title: data.money.availableText,
                      subtitle: data.money.safeThroughText,
                    ),
                  ],
                ),
                if (data.shifts.isNotEmpty)
                  _JournalSection(
                    title: 'Coming up',
                    children: data.shifts
                        .map(
                          (shift) => _JournalLine(
                            leading: Icons.calendar_today_outlined,
                            title: '${shift.day} · ${shift.unit}',
                            subtitle: shift.time,
                          ),
                        )
                        .toList(),
                  ),
                _JournalSection(
                  title: 'A note from your brain',
                  children: [
                    _JournalLine(
                      leading: Icons.lightbulb_outline,
                      title: data.brainNote,
                      subtitle: data.resetLine,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalSection extends StatelessWidget {
  const _JournalSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF915548),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 9),
          ...children,
        ],
      ),
    );
  }
}

class _JournalLine extends StatelessWidget {
  const _JournalLine({
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final IconData leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(leading, size: 18, color: const Color(0xFF5B4938)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF32271E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.28,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6F604E),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JournalRulePainter extends CustomPainter {
  const _JournalRulePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF7E9AB5).withValues(alpha: .22)
      ..strokeWidth = 1;
    for (double y = 52; y < size.height; y += 31) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = const Color(0xFFB95F58).withValues(alpha: .36)
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(30, 0), Offset(30, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
