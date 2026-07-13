import 'dart:math' as math;

import 'package:flutter/material.dart';

class DeskPropTapTarget extends StatefulWidget {
  const DeskPropTapTarget({
    super.key,
    required this.label,
    required this.onTap,
    required this.child,
    this.rotation = 0,
    this.hitPadding = const EdgeInsets.all(10),
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;
  final double rotation;
  final EdgeInsets hitPadding;

  @override
  State<DeskPropTapTarget> createState() => _DeskPropTapTargetState();
}

class _DeskPropTapTargetState extends State<DeskPropTapTarget> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final lift = _pressed ? 1.0 : (_hovered ? -7.0 : 0.0);
    final scale = _pressed ? 0.97 : (_hovered ? 1.045 : 1.0);

    return Semantics(
      button: true,
      label: widget.label,
      child: Tooltip(
        message: widget.label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: widget.onTap,
            child: Padding(
              padding: widget.hitPadding,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                curve: Curves.easeOutCubic,
                transformAlignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, lift)
                  ..rotateZ(widget.rotation + (_hovered ? -0.015 : 0))
                  ..scale(scale),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeskPenProp extends StatelessWidget {
  const DeskPenProp({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4.8,
      child: CustomPaint(painter: _PenPainter()),
    );
  }
}

class _PenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .07, size.height * .22, size.width * .78, size.height * .56),
      Radius.circular(size.height * .22),
    );
    canvas.drawShadow(Path()..addRRect(body), Colors.black, 7, false);

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1B2A3A), Color(0xFF3D5870), Color(0xFF15202C)],
      ).createShader(body.outerRect);
    canvas.drawRRect(body, bodyPaint);

    final metalPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD9D1BE), Color(0xFF7E7568), Color(0xFFF2EEE6)],
      ).createShader(Rect.fromLTWH(size.width * .79, 0, size.width * .2, size.height));
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .84, size.height * .22)
        ..lineTo(size.width * .99, size.height * .50)
        ..lineTo(size.width * .84, size.height * .78)
        ..close(),
      metalPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .02, size.height * .28, size.width * .12, size.height * .44),
        Radius.circular(size.height * .18),
      ),
      Paint()..color = const Color(0xFF111820),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DeskEnvelopeProp extends StatelessWidget {
  const DeskEnvelopeProp({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.55,
      child: CustomPaint(painter: _EnvelopePainter()),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .04, size.height * .08, size.width * .92, size.height * .84),
      Radius.circular(size.width * .035),
    );
    canvas.drawShadow(Path()..addRRect(rect), Colors.black, 10, false);
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFE8D6B5));

    final seam = Paint()
      ..color = const Color(0xFF9A7D58).withOpacity(.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, size.width * .012);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .06, size.height * .84)
        ..lineTo(size.width * .50, size.height * .48)
        ..lineTo(size.width * .94, size.height * .84),
      seam,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .06, size.height * .14)
        ..lineTo(size.width * .50, size.height * .56)
        ..lineTo(size.width * .94, size.height * .14),
      seam,
    );

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .58),
      size.width * .09,
      Paint()..color = const Color(0xFF7E2F27),
    );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .58),
      size.width * .045,
      Paint()..color = const Color(0xFFB75D45),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DeskStickyProp extends StatelessWidget {
  const DeskStickyProp({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.05,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 13, 12, 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE88F), Color(0xFFE5C95D)],
          ),
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(3, 8)),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 34,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFB88C3A).withOpacity(.45),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Center(
              child: Text(
                text,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF49391F),
                  fontFamily: 'Georgia',
                  fontSize: 12,
                  height: 1.12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeskPlantProp extends StatelessWidget {
  const DeskPlantProp({super.key, required this.stage});

  final int stage;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .82,
      child: CustomPaint(painter: _PlantPainter(stage.clamp(0, 3))),
    );
  }
}

class _PlantPainter extends CustomPainter {
  const _PlantPainter(this.stage);

  final int stage;

  @override
  void paint(Canvas canvas, Size size) {
    final potRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .23, size.height * .62, size.width * .54, size.height * .28),
      Radius.circular(size.width * .08),
    );
    canvas.drawShadow(Path()..addRRect(potRect), Colors.black, 10, false);
    canvas.drawRRect(potRect, Paint()..color = const Color(0xFF8C5538));
    canvas.drawOval(
      Rect.fromLTWH(size.width * .23, size.height * .58, size.width * .54, size.height * .13),
      Paint()..color = const Color(0xFFB97C57),
    );

    final stem = Paint()
      ..color = const Color(0xFF355B32)
      ..strokeWidth = math.max(2, size.width * .045)
      ..strokeCap = StrokeCap.round;
    final leaf = Paint()..color = const Color(0xFF5F8E4C);

    final count = 2 + stage * 2;
    for (var i = 0; i < count; i++) {
      final t = i / math.max(1, count - 1);
      final start = Offset(size.width * .5, size.height * .63);
      final end = Offset(
        size.width * (.5 + (i.isEven ? -.17 : .17) * (0.45 + t)),
        size.height * (.58 - .42 * t),
      );
      canvas.drawLine(start, end, stem);
      canvas.save();
      canvas.translate(end.dx, end.dy);
      canvas.rotate(i.isEven ? -.55 : .55);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * (.25 + stage * .035),
          height: size.height * (.11 + stage * .018),
        ),
        leaf,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PlantPainter oldDelegate) => oldDelegate.stage != stage;
}

class DeskLanternProp extends StatefulWidget {
  const DeskLanternProp({super.key, required this.on});

  final bool on;

  @override
  State<DeskLanternProp> createState() => _DeskLanternPropState();
}

class _DeskLanternPropState extends State<DeskLanternProp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flicker;

  @override
  void initState() {
    super.initState();
    _flicker = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .72,
      child: AnimatedBuilder(
        animation: _flicker,
        builder: (context, _) {
          final glow = widget.on ? .68 + _flicker.value * .22 : 0.0;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: widget.on
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFB347).withOpacity(glow * .45),
                        blurRadius: 34 + _flicker.value * 8,
                        spreadRadius: 9,
                      ),
                    ]
                  : null,
            ),
            child: CustomPaint(painter: _LanternPainter(widget.on, glow)),
          );
        },
      ),
    );
  }
}

class _LanternPainter extends CustomPainter {
  const _LanternPainter(this.on, this.glow);

  final bool on;
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final metal = Paint()
      ..color = const Color(0xFF3C3A35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2, size.width * .045);
    final glassRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * .2, size.height * .24, size.width * .6, size.height * .54),
      Radius.circular(size.width * .16),
    );
    canvas.drawShadow(Path()..addRRect(glassRect), Colors.black, 9, false);
    canvas.drawRRect(
      glassRect,
      Paint()
        ..color = on
            ? const Color(0xFFFFD06A).withOpacity(.34 + glow * .25)
            : const Color(0xFFB9B2A4).withOpacity(.2),
    );
    canvas.drawRRect(glassRect, metal);
    canvas.drawArc(
      Rect.fromLTWH(size.width * .24, size.height * .02, size.width * .52, size.height * .42),
      math.pi,
      math.pi,
      false,
      metal,
    );
    canvas.drawLine(
      Offset(size.width * .18, size.height * .80),
      Offset(size.width * .82, size.height * .80),
      metal,
    );
    if (on) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * .5, size.height * .58),
          width: size.width * .22,
          height: size.height * .24,
        ),
        Paint()..color = const Color(0xFFFFA62B).withOpacity(.88),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LanternPainter oldDelegate) =>
      oldDelegate.on != on || oldDelegate.glow != glow;
}
