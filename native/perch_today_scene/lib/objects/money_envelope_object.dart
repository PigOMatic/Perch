import 'package:flutter/material.dart';

import '../assets/home_perch_assets.dart';
import '../data/perch_today_models.dart';
import '../widgets/perch_asset_layer.dart';

class MoneyEnvelopeObject extends StatelessWidget {
  const MoneyEnvelopeObject({super.key, required this.money});

  final MoneySnapshot money;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.055,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(
            child: PerchAssetLayer(
              assetPath: HomePerchAssets.envelope,
              fit: BoxFit.fill,
              fallback: _MoneyEnvelopeFallbackSurface(),
            ),
          ),
          Positioned.fill(
            top: 92,
            left: 26,
            right: 22,
            bottom: 18,
            child: _MoneyLiveText(money: money),
          ),
        ],
      ),
    );
  }
}

class _MoneyLiveText extends StatelessWidget {
  const _MoneyLiveText({required this.money});

  final MoneySnapshot money;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Money',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 18),
        const Text('Available', style: TextStyle(fontSize: 19)),
        const SizedBox(height: 6),
        Text(
          money.availableText,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            height: 0.95,
            letterSpacing: -1.7,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          money.safeThroughText,
          style: const TextStyle(fontSize: 15, height: 1.2),
        ),
        const Spacer(),
        const Text(
          'Bills checked ✓',
          style: TextStyle(
            fontSize: 15,
            decoration: TextDecoration.overline,
          ),
        ),
      ],
    );
  }
}

class _MoneyEnvelopeFallbackSurface extends StatelessWidget {
  const _MoneyEnvelopeFallbackSurface();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(left: 38, right: 14, top: 0, height: 52, child: _CashBill(label: r'$20')),
        const Positioned(left: 30, right: 22, top: 22, height: 52, child: _CashBill(label: r'$10')),
        const Positioned(left: 46, right: 6, top: 44, height: 52, child: _CashBill(label: r'$5')),
        Positioned.fill(
          top: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFB9965D),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.34),
                  blurRadius: 28,
                  offset: const Offset(10, 22),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CashBill extends StatelessWidget {
  const _CashBill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.025,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xFFE7E3C4),
          border: Border.all(color: const Color(0x66374731)),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xAA213822),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
