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
          final scale = (constraints.maxWidth / 852).clamp(0.72, 1.35);
          final pageGap = constraints.maxWidth * 0.052;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              constraints.maxWidth * 0.095,
              constraints.maxHeight * 0.085,
              constraints.maxWidth * 0.095,
              constraints.maxHeight * 0.085,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _PaperPage(
                    scale: scale,
                    child: _LeftPage(
                      data: data,
                      focused: focused,
                      scale: scale,
                    ),
                  ),
                ),
                SizedBox(width: pageGap),
                Expanded(
                  child: _PaperPage(
                    scale: scale,
                    child: _RightPage(
                      data: data,
                      focused: focused,
                      scale: scale,
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

class _PaperPage extends StatelessWidget {
  const _PaperPage({required this.scale, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7 * scale),
      child: CustomPaint(
        painter: _PaperPainter(scale),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            15 * scale,
            13 * scale,
            13 * scale,
            12 * scale,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  const _PaperPainter(this.scale);

  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paperPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF7EFD9), Color(0xFFEAD8B6)],
      ).createShader(rect);
    canvas.drawRect(rect, paperPaint);

    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFF765435).withOpacity(0.12),
          Colors.transparent,
          const Color(0xFF765435).withOpacity(0.08),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, edgePaint);

    final linePaint = Paint()
      ..color = const Color(0xFF7E8A78).withOpacity(0.16)
      ..strokeWidth = 0.75 * scale;
    final spacing = 22 * scale;
    for (double y = 48 * scale; y < size.height - 8; y += spacing) {
      canvas.drawLine(Offset(10 * scale, y), Offset(size.width - 9 * scale, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = const Color(0xFFB45D4E).withOpacity(0.18)
      ..strokeWidth = 0.9 * scale;
    canvas.drawLine(
      Offset(28 * scale, 8),
      Offset(28 * scale, size.height - 8),
      marginPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PaperPainter oldDelegate) =>
      oldDelegate.scale != scale;
}

class _LeftPage extends StatelessWidget {
  const _LeftPage({
    required this.data,
    required this.focused,
    required this.scale,
  });

  final PerchTodayData data;
  final bool focused;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final shifts = focused ? data.shifts.take(3) : data.shifts.take(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perch', style: _titleStyle(30 * scale)),
        SizedBox(height: 2 * scale),
        Text(
          data.dayStatus,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _bodyStyle(11.5 * scale, weight: FontWeight.w600),
        ),
        SizedBox(height: 11 * scale),
        Text(
          data.resetLine,
          maxLines: focused ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: _accentStyle(15 * scale),
        ),
        const Spacer(),
        _Section('Next thing', scale: scale),
        _CheckLine(data.nextDue.title, scale: scale),
        SizedBox(height: 8 * scale),
        _Section('Schedule', scale: scale),
        ...shifts.map(
          (shift) => Padding(
            padding: EdgeInsets.only(bottom: 3 * scale),
            child: Text(
              '${shift.day}  ${shift.unit} · ${shift.time}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _bodyStyle(10.5 * scale, weight: FontWeight.w600),
            ),
          ),
        ),
        if (focused) ...[
          SizedBox(height: 8 * scale),
          _Section('Money', scale: scale),
          Text(
            data.money.availableText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(13 * scale, weight: FontWeight.w800),
          ),
          Text(
            data.money.safeThroughText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(9.5 * scale),
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
    required this.scale,
  });

  final PerchTodayData data;
  final bool focused;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section('Needs attention', scale: scale),
        _CheckLine(data.nextDue.title, scale: scale),
        Padding(
          padding: EdgeInsets.only(left: 20 * scale, top: 2 * scale),
          child: Text(
            data.nextDue.actionLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(9.5 * scale).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF7A4F36),
            ),
          ),
        ),
        SizedBox(height: 13 * scale),
        _Section('From your brain', scale: scale),
        Text(
          data.brainNote,
          maxLines: focused ? 5 : 2,
          overflow: TextOverflow.ellipsis,
          style: _bodyStyle(11 * scale, weight: FontWeight.w500),
        ),
        const Spacer(),
        if (focused) ...[
          _Section('Quiet thought', scale: scale),
          Text(
            'One thing at a time.',
            maxLines: 2,
            style: _accentStyle(13 * scale),
          ),
          SizedBox(height: 10 * scale),
        ],
        Text(
          'Your life is organized enough for the next minute.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: _bodyStyle(8.5 * scale).copyWith(
            fontStyle: FontStyle.italic,
            color: const Color(0xFF725F4D),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.text, {required this.scale});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4 * scale),
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _bodyStyle(8.5 * scale, weight: FontWeight.w800).copyWith(
          letterSpacing: 1.2 * scale,
          color: const Color(0xFF6A4A35),
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine(this.text, {required this.scale});

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 11 * scale,
          height: 11 * scale,
          margin: EdgeInsets.only(top: 2 * scale, right: 7 * scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2 * scale),
            border: Border.all(
              color: const Color(0xFF503A29),
              width: 1.1 * scale,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(11 * scale, weight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

TextStyle _titleStyle(double size) => TextStyle(
      color: const Color(0xFF2E2118),
      fontSize: size,
      height: 0.94,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.1,
      fontFamily: 'Georgia',
    );

TextStyle _accentStyle(double size) => TextStyle(
      color: const Color(0xFF8A4934),
      fontSize: size,
      height: 1.05,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      fontFamily: 'Georgia',
    );

TextStyle _bodyStyle(
  double size, {
  FontWeight weight = FontWeight.w400,
}) =>
    TextStyle(
      color: const Color(0xFF34261B),
      fontSize: size,
      height: 1.18,
      fontWeight: weight,
      fontFamily: 'Georgia',
    );
