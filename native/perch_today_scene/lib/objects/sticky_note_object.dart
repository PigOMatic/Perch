import 'package:flutter/material.dart';

class StickyNoteObject extends StatelessWidget {
  const StickyNoteObject({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.065,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFDFC95D),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.26),
              blurRadius: 24,
              offset: const Offset(8, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(top: -8, left: 0, right: 0, child: Center(child: _PushPin())),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.04,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F241D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PushPin extends StatelessWidget {
  const _PushPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFF9D69A), Color(0xFF9C6A31)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.26),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
    );
  }
}
