import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/perch_asset_layer.dart';
import 'perch_scene_hit_map.dart';
import 'perch_scene_set.dart';

class PerchSceneViewport extends StatelessWidget {
  const PerchSceneViewport({
    super.key,
    required this.scene,
    required this.assetPath,
    required this.enabled,
    required this.onAction,
    this.fallback,
    this.scale = 1,
  });

  final PerchSceneSet scene;
  final String assetPath;
  final bool enabled;
  final ValueChanged<PerchSceneHitbox> onAction;
  final Widget? fallback;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.biggest;
        final designAspect = scene.designWidth / scene.designHeight;
        final availableAspect = available.width / available.height;

        late final double sceneWidth;
        late final double sceneHeight;

        if (availableAspect > designAspect) {
          sceneHeight = available.height;
          sceneWidth = sceneHeight * designAspect;
        } else {
          sceneWidth = available.width;
          sceneHeight = sceneWidth / designAspect;
        }

        final safeWidth = math.max(1.0, sceneWidth);
        final safeHeight = math.max(1.0, sceneHeight);

        return ColoredBox(
          color: const Color(0xFF120D09),
          child: Center(
            child: AnimatedScale(
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeInOutCubic,
              scale: scale,
              child: SizedBox(
                width: safeWidth,
                height: safeHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PerchAssetLayer(
                      assetPath: assetPath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      fallback: fallback,
                    ),
                    PerchSceneHitMap(
                      scene: scene,
                      enabled: enabled,
                      onAction: onAction,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
