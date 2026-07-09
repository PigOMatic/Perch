import 'package:flutter/material.dart';

import '../../data/perch_today_models.dart';
import '../../objects/money_envelope_object.dart';
import '../../objects/notebook_object.dart';
import '../../objects/shift_ticket_object.dart';
import '../../objects/sticky_note_object.dart';
import '../../scene_engine/scene_definition.dart';
import '../../scene_engine/scene_object.dart';
import '../../scene_engine/scene_renderer.dart';
import '../../world/perch_world_state.dart';

class HomePerchScene extends StatelessWidget {
  const HomePerchScene({
    super.key,
    required this.data,
    required this.worldState,
  });

  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    return PerchSceneRenderer(
      scene: homePerchSceneDefinition,
      data: data,
      worldState: worldState,
    );
  }
}

final homePerchSceneDefinition = PerchSceneDefinition(
  id: 'home_perch',
  name: 'Home Perch',
  backgroundBuilder: (context, size, worldState) => HomePerchBackground(worldState: worldState),
  objects: [
    SceneObjectDefinition(
      id: 'notebook',
      layout: (size) => Rect.fromLTWH(
        size.width * 0.08,
        size.height * 0.10,
        size.width * 0.58,
        size.height * 0.58,
      ),
      builder: (context, data) => NotebookObject(data: data),
    ),
    SceneObjectDefinition(
      id: 'money_envelope',
      layout: (size) => Rect.fromLTWH(
        size.width * 0.61,
        size.height * 0.08,
        size.width * 0.32,
        size.height * 0.43,
      ),
      builder: (context, data) => MoneyEnvelopeObject(money: data.money),
    ),
    SceneObjectDefinition(
      id: 'sticky_note',
      layout: (size) => Rect.fromLTWH(
        size.width * 0.66,
        size.height * 0.53,
        size.width * 0.24,
        size.height * 0.21,
      ),
      builder: (context, data) => StickyNoteObject(text: data.brainNote),
    ),
    SceneObjectDefinition(
      id: 'shift_tickets',
      layout: (size) => Rect.fromLTWH(
        size.width * 0.12,
        size.height * 0.72,
        size.width * 0.74,
        size.height * 0.20,
      ),
      builder: (context, data) => ShiftTicketCluster(shifts: data.shifts),
    ),
  ],
);

class HomePerchBackground extends StatelessWidget {
  const HomePerchBackground({super.key, required this.worldState});

  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _deskGradientFor(worldState),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: -64,
            top: 28,
            child: _CoffeeMugProp(),
          ),
          const Positioned(
            right: -48,
            bottom: -36,
            child: _LeatherCornerProp(),
          ),
          const Positioned(
            left: 42,
            bottom: 146,
            child: _PenProp(),
          ),
          Positioned.fill(child: _LightAndGrainOverlay(worldState: worldState)),
          if (worldState.weather == PerchWeather.rain) const Positioned.fill(child: _RainOverlay()),
          if (worldState.weather == PerchWeather.fog) const Positioned.fill(child: _FogOverlay()),
          if (worldState.timeOfDay == PerchTimeOfDay.night) const Positioned.fill(child: _NightOverlay()),
        ],
      ),
    );
  }

  List<Color> _deskGradientFor(PerchWorldState state) {
    if (state.timeOfDay == PerchTimeOfDay.night) {
      return const [
        Color(0xFF111417),
        Color(0xFF2C2118),
        Color(0xFF5C3820),
        Color(0xFF101114),
      ];
    }

    if (state.season == PerchSeason.fall) {
      return const [
        Color(0xFF2D1A10),
        Color(0xFF7A4322),
        Color(0xFFB06431),
        Color(0xFF2B160D),
      ];
    }

    return const [
      Color(0xFF2D1C12),
      Color(0xFF704624),
      Color(0xFFA56B39),
      Color(0xFF2B1A10),
    ];
  }
}

class _LightAndGrainOverlay extends StatelessWidget {
  const _LightAndGrainOverlay({required this.worldState});

  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    final opacity = switch (worldState.timeOfDay) {
      PerchTimeOfDay.morning => 0.24,
      PerchTimeOfDay.midday => 0.18,
      PerchTimeOfDay.evening => 0.16,
      PerchTimeOfDay.night => 0.06,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.36, -0.72),
          radius: 0.94,
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _RainOverlay extends StatelessWidget {
  const _RainOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF2D3C48).withOpacity(0.16),
      ),
    );
  }
}

class _FogOverlay extends StatelessWidget {
  const _FogOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFD7D4C8).withOpacity(0.18),
      ),
    );
  }
}

class _NightOverlay extends StatelessWidget {
  const _NightOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF030509).withOpacity(0.22),
      ),
    );
  }
}

class _CoffeeMugProp extends StatelessWidget {
  const _CoffeeMugProp();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 168,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEEE0C3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 24,
            offset: const Offset(8, 14),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 94,
          height: 94,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF22150E),
          ),
        ),
      ),
    );
  }
}

class _PenProp extends StatelessWidget {
  const _PenProp();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.72,
      child: Container(
        width: 18,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF111315), Color(0xFF2B2F34), Color(0xFF9A8A67)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 18,
              offset: const Offset(8, 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeatherCornerProp extends StatelessWidget {
  const _LeatherCornerProp();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.16,
      child: Container(
        width: 260,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF6A371D), Color(0xFF2D170E)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.24),
              blurRadius: 28,
              offset: const Offset(-6, 18),
            ),
          ],
        ),
      ),
    );
  }
}
