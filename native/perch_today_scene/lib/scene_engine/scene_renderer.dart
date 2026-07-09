import 'package:flutter/material.dart';

import '../data/perch_today_models.dart';
import '../world/perch_world_state.dart';
import 'scene_definition.dart';

class PerchSceneRenderer extends StatelessWidget {
  const PerchSceneRenderer({
    super.key,
    required this.scene,
    required this.data,
    required this.worldState,
  });

  final PerchSceneDefinition scene;
  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sceneSize = Size(constraints.maxWidth, constraints.maxHeight);
          return Stack(
            fit: StackFit.expand,
            children: [
              scene.backgroundBuilder(context, sceneSize, worldState),
              for (final object in scene.objects)
                _PlacedSceneObject(
                  rect: object.layout(sceneSize),
                  child: object.builder(context, data),
                ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: _WorldStatusPill(worldState: worldState),
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

class _WorldStatusPill extends StatelessWidget {
  const _WorldStatusPill({required this.worldState});

  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.black.withOpacity(0.28),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            '${worldState.welcomeLine} · ${worldState.ambientLabel}',
            style: const TextStyle(
              color: Color(0xFFF8EEDC),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
