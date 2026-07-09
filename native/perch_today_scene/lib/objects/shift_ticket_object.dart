import 'package:flutter/material.dart';

import '../data/perch_today_models.dart';

class ShiftTicketCluster extends StatelessWidget {
  const ShiftTicketCluster({super.key, required this.shifts});

  final List<ShiftTicketData> shifts;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < shifts.length; index += 1)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == shifts.length - 1 ? 0 : 12,
                bottom: index == 1 ? 0 : 10,
              ),
              child: ShiftTicketObject(
                shift: shifts[index],
                angle: [-0.035, 0.018, 0.05][index.clamp(0, 2)],
              ),
            ),
          ),
        const SizedBox(width: 12),
        const _CalendarStub(),
      ],
    );
  }
}

class ShiftTicketObject extends StatelessWidget {
  const ShiftTicketObject({super.key, required this.shift, required this.angle});

  final ShiftTicketData shift;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFE7E2D5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.23),
              blurRadius: 18,
              offset: const Offset(7, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                shift.unit,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Color(0xAA1F241D),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                shift.day,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F241D),
                ),
              ),
              Text(
                shift.time,
                style: const TextStyle(fontSize: 22, color: Color(0xFF1F241D)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1F241D), Colors.transparent, Color(0xFF1F241D)],
                    stops: [0.1, 0.13, 0.16],
                    tileMode: TileMode.repeated,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarStub extends StatelessWidget {
  const _CalendarStub();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 94,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFB9AD8E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 16,
              offset: const Offset(6, 12),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('▦', style: TextStyle(fontSize: 28)),
              Text('Calendar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
