import 'package:flutter/widgets.dart';

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
  final Widget Function(BuildContext context, Size sceneSize) backgroundBuilder;
  final List<SceneObjectDefinition> objects;
}
