import 'package:flutter/widgets.dart';

import '../data/perch_today_models.dart';

class SceneObjectDefinition {
  const SceneObjectDefinition({
    required this.id,
    required this.layout,
    required this.builder,
  });

  final String id;
  final Rect Function(Size sceneSize) layout;
  final Widget Function(BuildContext context, PerchTodayData data) builder;
}
