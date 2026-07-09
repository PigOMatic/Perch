import 'package:flutter/material.dart';

import '../data/perch_today_models.dart';
import 'scene_definition.dart';

class PerchSceneRenderer extends StatelessWidget {
  const PerchSceneRenderer({
    super.key,
    required this.scene,
    required this.data,
  });

  final PerchSceneDefinition scene;
  final PerchTodayData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sceneSize = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            fit: StackFit.expand,
            children: [
              scene.backgroundBuilder(context, sceneSize),
              for (final object in scene.objects)
                _PlacedSceneObject(
                  rect: object.layout(sceneSize),
                  child: object.builder(context, data),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PlacedSceneObject extends StatelessWidget {
  const _PlacedSceneObject({required this.rect, required this.child});

  final Rect rect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: child,
    );
  }
}
