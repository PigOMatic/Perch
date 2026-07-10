import 'package:flutter/material.dart';

import '../../data/perch_today_models.dart';

class LiveJournalContent extends StatelessWidget {
  const LiveJournalContent({
    super.key,
    required this.data,
    required this.focused,
  });

  final PerchTodayData data;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / 852;
          final titleSize = (focused ? 34.0 : 26.0) * scale.clamp(0.72, 1.35);
          final sectionSize = (focused ? 13.0 : 11.0) * scale.clamp(0.72, 1.35);
          final bodySize = (focused ? 15.0 : 12.0) * scale.clamp(0.72, 1.35);

          return Padding(
            padding: EdgeInsets.fromLTRB(
              constraints.maxWidth * 0.105,
              constraints.maxHeight * 0.12,
              constraints.maxWidth * 0.10,
              constraints.maxHeight * 0.10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PageSurface(
                    child: _LeftPage(
                      data: data,
                      focused: focused,
                      titleSize: titleSize,
                      sectionSize: sectionSize,
                      bodySize: bodySize,
                    ),
                  ),
                ),
                SizedBox(width: constraints.maxWidth * 0.065),
                Expanded(
                  child: _PageSurface(
                    child: _RightPage(
                      data: data,
                      focused: focused,
                      titleSize: titleSize,
                      sectionSize: sectionSize,
                      bodySize: bodySize,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PageSurface extends StatelessWidget {
  const _PageSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0DFC0).withOpacity(0.92),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}

class _LeftPage extends StatelessWidget {
  const _LeftPage({
    required this.data,
    required this.focused,
    required this.titleSize,
    required this.sectionSize,
    required this.bodySize,
  });

  final PerchTodayData data;
  final bool focused;
  final double titleSize;
  final double sectionSize;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    final shifts = focused ? data.shifts.take(3) : data.shifts.take(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          maxLines: 1,
          style: _inkStyle(titleSize, FontWeight.w600),
        ),
        Text(
          data.dayStatus,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _inkStyle(bodySize * 0.92, FontWeight.w500),
        ),
        const Spacer(),
        _SectionLabel('NEXT UP', size: sectionSize),
        _LineItem(data.nextDue.title, size: bodySize),
        const Spacer(),
        _SectionLabel('SCHEDULE', size: sectionSize),
        ...shifts.map(
          (shift) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '${shift.day}  ${shift.unit} · ${shift.time}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _inkStyle(bodySize * 0.90, FontWeight.w500),
            ),
          ),
        ),
        if (focused) ...[
          const Spacer(),
          _SectionLabel('MONEY', size: sectionSize),
          Text(
            data.money.availableText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _inkStyle(bodySize * 1.12, FontWeight.w700),
          ),
          Text(
            data.money.safeThroughText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _inkStyle(bodySize * 0.82, FontWeight.w400),
          ),
        ],
        const Spacer(),
      ],
    );
  }
}

class _RightPage extends StatelessWidget {
  const _RightPage({
    required this.data,
    required this.focused,
    required this.titleSize,
    required this.sectionSize,
    required this.bodySize,
  });

  final PerchTodayData data;
  final bool focused;
  final double titleSize;
  final double sectionSize;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('DAILY BRIEF', size: sectionSize),
        Text(
          data.resetLine,
          maxLines: focused ? 3 : 2,
          overflow: TextOverflow.ellipsis,
          style: _inkStyle(bodySize, FontWeight.w500),
        ),
        const Spacer(),
        _SectionLabel('NEEDS ATTENTION', size: sectionSize),
        _LineItem(data.nextDue.title, size: bodySize),
        Text(
          data.nextDue.actionLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _inkStyle(bodySize * 0.82, FontWeight.w400),
        ),
        const Spacer(),
        _SectionLabel('FROM YOUR BRAIN', size: sectionSize),
        Text(
          data.brainNote,
          maxLines: focused ? 4 : 2,
          overflow: TextOverflow.ellipsis,
          style: _inkStyle(bodySize, FontWeight.w500),
        ),
        if (focused) ...[
          const Spacer(),
          _SectionLabel('TODAY', size: sectionSize),
          _LineItem('One thing at a time.', size: bodySize),
        ],
        const Spacer(),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(
        text,
        maxLines: 1,
        style: _inkStyle(size, FontWeight.w800, letterSpacing: 0.7),
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem(this.text, {required this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: size * 0.35, right: size * 0.45),
          child: Container(
            width: size * 0.42,
            height: size * 0.42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A2A1B), width: 1),
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _inkStyle(size, FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

TextStyle _inkStyle(
  double size,
  FontWeight weight, {
  double? letterSpacing,
}) {
  return TextStyle(
    color: const Color(0xFF312317),
    fontSize: size,
    height: 1.18,
    fontWeight: weight,
    letterSpacing: letterSpacing,
  );
}
