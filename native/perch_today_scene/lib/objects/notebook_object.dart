import 'package:flutter/material.dart';

import '../assets/home_perch_assets.dart';
import '../data/perch_today_models.dart';
import '../widgets/perch_asset_layer.dart';

class NotebookObject extends StatelessWidget {
  const NotebookObject({super.key, required this.data});

  final PerchTodayData data;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.018,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const PerchAssetLayer(
            assetPath: HomePerchAssets.notebook,
            fit: BoxFit.fill,
            fallback: _NotebookFallbackSurface(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(76, 38, 42, 34),
            child: _NotebookLiveText(data: data),
          ),
        ],
      ),
    );
  }
}

class _NotebookLiveText extends StatelessWidget {
  const _NotebookLiveText({required this.data});

  final PerchTodayData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perch.',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 48,
                    color: const Color(0xFF1F241D),
                  ),
            ),
            Text(
              data.dayStatus,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F241D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          data.resetLine,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8B3526),
          ),
        ),
        const SizedBox(height: 46),
        _NotebookRunItem(
          label: 'Next thing',
          title: data.nextDue.title,
          action: data.nextDue.actionLabel,
        ),
        const Spacer(),
        const Text(
          'Your life is organized enough for the next minute.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0x8820241D),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _NotebookRunItem extends StatelessWidget {
  const _NotebookRunItem({required this.label, required this.title, required this.action});

  final String label;
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.1,
            color: Color(0xAA1F241D),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1F241D), width: 2),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.05,
                  color: Color(0xFF1F241D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 20,
              decoration: TextDecoration.underline,
              color: Color(0xFF1F241D),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotebookFallbackSurface extends StatelessWidget {
  const _NotebookFallbackSurface();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF8A653E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.36),
            blurRadius: 32,
            offset: const Offset(14, 24),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 28, top: 10, right: 8, bottom: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFF4EEDF),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _NotebookLinesPainter())),
              Positioned(left: 14, top: 24, bottom: 24, child: _SpiralHoles()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpiralHoles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        9,
        (_) => Container(
          width: 13,
          height: 13,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x886E5236),
          ),
        ),
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0x33354A62)
      ..strokeWidth = 1;
    for (double y = 82; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = const Color(0x44C95A4C)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(size.width * 0.16, 0), Offset(size.width * 0.16, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
