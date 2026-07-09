import 'package:flutter/widgets.dart';

import '../world/perch_world_state.dart';
import 'scene_object.dart';

class PerchSceneDefinition {
  const PerchSceneDefinition({
    required this.id,
    required this.name,
    required this.backgroundBuilder,
    required this.objects,
  });

  final String id;
  final String name;
  final Widget Function(
    BuildContext context,
    Size sceneSize,
    PerchWorldState worldState,
  ) backgroundBuilder;
  final List<SceneObjectDefinition> objects;
}
