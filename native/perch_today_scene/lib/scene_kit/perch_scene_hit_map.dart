import 'package:flutter/material.dart';

import 'perch_scene_set.dart';

class PerchSceneHitMap extends StatelessWidget {
  const PerchSceneHitMap({
    super.key,
    required this.scene,
    required this.enabled,
    required this.onAction,
  });

  final PerchSceneSet scene;
  final bool enabled;
  final ValueChanged<PerchSceneHitbox> onAction;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              for (final hitbox in scene.hitboxes)
                _HitRegion(
                  hitbox: hitbox,
                  canvasSize: constraints.biggest,
                  onTap: () => onAction(hitbox),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _HitRegion extends StatelessWidget {
  const _HitRegion({
    required this.hitbox,
    required this.canvasSize,
    required this.onTap,
  });

  final PerchSceneHitbox hitbox;
  final Size canvasSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rect = hitbox.rect;
    final rawWidth = canvasSize.width * rect.width;
    final rawHeight = canvasSize.height * rect.height;
    final width = rawWidth < hitbox.minTouch ? hitbox.minTouch : rawWidth;
    final height = rawHeight < hitbox.minTouch ? hitbox.minTouch : rawHeight;
    final centerX = canvasSize.width * (rect.x + rect.width / 2);
    final centerY = canvasSize.height * (rect.y + rect.height / 2);

    return Positioned(
      left: (centerX - width / 2).clamp(0.0, canvasSize.width - width),
      top: (centerY - height / 2).clamp(0.0, canvasSize.height - height),
      width: width,
      height: height,
      child: Semantics(
        button: true,
        label: hitbox.label,
        child: Tooltip(
          message: hitbox.label,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
