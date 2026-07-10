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

    return Stack(
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
          left: 10,
          right: 10,
          bottom: 12,
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 6.0;
                final columns = constraints.maxWidth >= 680 ? 8 : 4;
                final itemWidth = (constraints.maxWidth - 16 - (spacing * (columns - 1))) / columns;

                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17110D).withOpacity(0.80),
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
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(HomePerchAssets.backgrounds.length, (index) {
                      final option = HomePerchAssets.backgrounds[index];
                      final isSelected = index == _selectedBackground;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedBackground = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: itemWidth,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE8C891) : const Color(0xFF3B2A20),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(isSelected ? 0.22 : 0.08)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                option.label,
                                maxLines: 1,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFF2A1B11) : const Color(0xFFF5E9D1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
