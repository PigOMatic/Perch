import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../data/perch_today_models.dart';
import '../../scene_engine/perch_performance.dart';
import '../../widgets/perch_asset_layer.dart';
import '../../world/perch_world_state.dart';

class HomePerchScene extends StatelessWidget {
  const HomePerchScene({
    super.key,
    required this.data,
    required this.worldState,
  });

  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: PerchPerformance.isolateStaticLayer(
        PerchAssetLayer(
          assetPath: HomePerchAssets.background,
          fit: BoxFit.cover,
          fallback: const _BackgroundMissingFallback(),
        ),
      ),
    );
  }
}

class _BackgroundMissingFallback extends StatelessWidget {
  const _BackgroundMissingFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D140E),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: const Text(
        'Home Perch background image missing.\nPlace background_cabin_desk.webp in assets/scenes/home_perch/.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFF6E8C8),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
