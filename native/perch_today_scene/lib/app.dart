import 'package:flutter/material.dart';

import 'core/brain/perch_brain.dart';
import 'core/brain/perch_brain_scope.dart';
import 'data/demo_today_data.dart';
import 'scenes/home_perch/home_perch_scene.dart';
import 'theme/perch_theme.dart';
import 'world/perch_world_state.dart';

class PerchTodaySceneApp extends StatefulWidget {
  const PerchTodaySceneApp({super.key});

  @override
  State<PerchTodaySceneApp> createState() => _PerchTodaySceneAppState();
}

class _PerchTodaySceneAppState extends State<PerchTodaySceneApp> {
  late final PerchBrain _brain;

  @override
  void initState() {
    super.initState();
    _brain = PerchBrain();
  }

  @override
  void dispose() {
    _brain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PerchBrainScope(
      brain: _brain,
      child: MaterialApp(
        title: 'Perch Today Scene',
        debugShowCheckedModeBanner: false,
        theme: buildPerchTheme(),
        home: const HomePerchScene(
          data: demoTodayData,
          worldState: demoWorldState,
        ),
      ),
    );
  }
}
