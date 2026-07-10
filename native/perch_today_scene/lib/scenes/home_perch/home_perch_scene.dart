import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../data/perch_today_models.dart';
import '../../scene_engine/perch_performance.dart';
import '../../widgets/perch_asset_layer.dart';
import '../../world/perch_world_state.dart';

class HomePerchScene extends StatefulWidget {
  const HomePerchScene({
    super.key,
    required this.data,
    required this.worldState,
  });

  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  State<HomePerchScene> createState() => _HomePerchSceneState();
}

class _HomePerchSceneState extends State<HomePerchScene> {
  int _selectedBackground = 1;

  @override
  Widget build(BuildContext context) {
    final selected = HomePerchAssets.backgrounds[_selectedBackground];

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: PerchPerformance.isolateStaticLayer(
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: PerchAssetLayer(
                  key: ValueKey(selected.assetPath),
                  assetPath: selected.assetPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  fallback: _BackgroundMissingFallback(assetPath: selected.assetPath),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 18,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17110D).withOpacity(0.78),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: HomePerchAssets.backgrounds.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      final option = HomePerchAssets.backgrounds[index];
                      final selectedOption = index == _selectedBackground;

                      return ChoiceChip(
                        label: Text(option.label),
                        selected: selectedOption,
                        onSelected: (_) => setState(() => _selectedBackground = index),
                        labelStyle: TextStyle(
                          color: selectedOption ? const Color(0xFF2A1B11) : const Color(0xFFF5E9D1),
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: const Color(0xFFE8C891),
                        backgroundColor: const Color(0xFF3B2A20),
                        side: BorderSide(color: Colors.white.withOpacity(0.08)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundMissingFallback extends StatelessWidget {
  const _BackgroundMissingFallback({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D140E),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(
        'Home Perch background image missing.\nPlace this file in the project:\n$assetPath',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF6E8C8),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
