import 'package:flutter/material.dart';

import 'data/demo_today_data.dart';
import 'scenes/home_perch/home_perch_scene.dart';
import 'theme/perch_theme.dart';
import 'world/perch_world_state.dart';

class PerchTodaySceneApp extends StatelessWidget {
  const PerchTodaySceneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perch Today Scene',
      debugShowCheckedModeBanner: false,
      theme: buildPerchTheme(),
      home: const HomePerchScene(
        data: demoTodayData,
        worldState: demoWorldState,
      ),
    );
  }
}
