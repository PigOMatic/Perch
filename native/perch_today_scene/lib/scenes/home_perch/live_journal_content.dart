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
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 852).clamp(0.72, 1.35);
        final pageGap = constraints.maxWidth * 0.052;

        final leftPage = _LeftPage(
          data: data,
          focused: focused,
          scale: scale,
        );
        final rightPage = _RightPage(
          data: data,
          focused: focused,
          scale: scale,
        );

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
                  scrollable: focused,
                  storageKey: const PageStorageKey('perch-left-page'),
                  child: leftPage,
                ),
              ),
              SizedBox(width: pageGap),
              Expanded(
                child: _PaperPage(
                  scale: scale,
                  scrollable: focused,
                  storageKey: const PageStorageKey('perch-right-page'),
                  child: rightPage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaperPage extends StatefulWidget {
  const _PaperPage({
    required this.scale,
    required this.scrollable,
    required this.storageKey,
    required this.child,
  });

  final double scale;
  final bool scrollable;
  final PageStorageKey<String> storageKey;
  final Widget child;

  @override
  State<_PaperPage> createState() => _PaperPageState();
}

class _PaperPageState extends State<_PaperPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageBody = Padding(
      padding: EdgeInsets.fromLTRB(
        15 * widget.scale,
        13 * widget.scale,
        13 * widget.scale,
        20 * widget.scale,
      ),
      child: widget.child,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(7 * widget.scale),
      child: CustomPaint(
        painter: _PaperPainter(widget.scale),
        child: widget.scrollable
            ? Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                thickness: 3 * widget.scale,
                radius: Radius.circular(4 * widget.scale),
                child: SingleChildScrollView(
                  key: widget.storageKey,
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(right: 5 * widget.scale),
                  child: pageBody,
                ),
              )
            : IgnorePointer(child: pageBody),
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
      canvas.drawLine(
        Offset(10 * scale, y),
        Offset(size.width - 9 * scale, y),
        linePaint,
      );
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
    final shifts = focused ? data.shifts : data.shifts.take(2);

    return Column(
      mainAxisSize: MainAxisSize.min,
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
          maxLines: focused ? 4 : 1,
          overflow: TextOverflow.ellipsis,
          style: _accentStyle(15 * scale),
        ),
        SizedBox(height: 18 * scale),
        _Section('Next thing', scale: scale),
        _CheckLine(data.nextDue.title, scale: scale),
        SizedBox(height: 16 * scale),
        _Section('Schedule', scale: scale),
        ...shifts.map(
          (shift) => Padding(
            padding: EdgeInsets.only(bottom: 6 * scale),
            child: Text(
              '${shift.day}  ${shift.unit} · ${shift.time}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _bodyStyle(10.5 * scale, weight: FontWeight.w600),
            ),
          ),
        ),
        if (focused) ...[
          SizedBox(height: 18 * scale),
          _Section('Money', scale: scale),
          Text(
            data.money.availableText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(13 * scale, weight: FontWeight.w800),
          ),
          SizedBox(height: 3 * scale),
          Text(
            data.money.safeThroughText,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(9.5 * scale),
          ),
          SizedBox(height: 22 * scale),
          _Section('Action', scale: scale),
          Text(
            data.nextDue.actionLabel,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(10.5 * scale, weight: FontWeight.w600),
          ),
        ],
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section('Needs attention', scale: scale),
        _CheckLine(data.nextDue.title, scale: scale),
        Padding(
          padding: EdgeInsets.only(left: 20 * scale, top: 3 * scale),
          child: Text(
            data.nextDue.actionLabel,
            maxLines: focused ? 3 : 1,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(9.5 * scale).copyWith(
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF7A4F36),
            ),
          ),
        ),
        SizedBox(height: 18 * scale),
        _Section('From your brain', scale: scale),
        Text(
          data.brainNote,
          maxLines: focused ? 8 : 2,
          overflow: TextOverflow.ellipsis,
          style: _bodyStyle(11 * scale, weight: FontWeight.w500),
        ),
        SizedBox(height: 20 * scale),
        if (focused) ...[
          _Section('Daily brief', scale: scale),
          Text(
            data.resetLine,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(11 * scale),
          ),
          SizedBox(height: 20 * scale),
          _Section('Quiet thought', scale: scale),
          Text(
            'One thing at a time.',
            maxLines: 2,
            style: _accentStyle(13 * scale),
          ),
          SizedBox(height: 22 * scale),
          _Section('Money note', scale: scale),
          Text(
            '${data.money.availableText}\n${data.money.safeThroughText}',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(10 * scale),
          ),
          SizedBox(height: 28 * scale),
        ],
        Text(
          'Your life is organized enough for the next minute.',
          maxLines: 3,
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
            maxLines: 3,
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
