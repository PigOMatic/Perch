import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../core/brain/perch_brain_scope.dart';
import '../../core/events/perch_event.dart';
import '../../data/perch_today_models.dart';
import '../../widgets/perch_asset_layer.dart';
import '../../world/perch_world_state.dart';
import 'ambient_quiet_view.dart';
import 'desk_functionality_layer.dart';
import 'journal_engine.dart';
import 'journal_workspace_panel.dart';
import 'realistic_desk_overlay.dart';

class HomePerchScene extends StatefulWidget {
  const HomePerchScene({
    super.key,
    required this.data,
    required this.worldState,
  });

  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  State<HomePerchScene> createState() => _HomePerchSceneState();
}

class _HomePerchSceneState extends State<HomePerchScene> {
  static const double _journalAspectRatio = 1.55;

  void _setJournalFocused(bool value) {
    final brain = PerchBrainScope.read(context);
    if (brain.state.journalFocused == value) return;
    brain.publish(
      PerchEvent(
        type: value
            ? PerchEventTypes.journalFocused
            : PerchEventTypes.journalClosed,
        source: 'home_perch.journal',
      ),
    );
  }

  Future<void> _openJournalWorkspace() async {
    final brain = PerchBrainScope.read(context);
    brain.publish(
      const PerchEvent(
        type: PerchEventTypes.deskObjectActivated,
        source: 'home_perch.journal',
        payload: {'id': 'journal'},
      ),
    );
    await showJournalWorkspace(context, data: widget.data);
  }

  String _backgroundForWorldState() {
    switch (widget.worldState.weather) {
      case PerchWeather.rain:
        return '${HomePerchAssets.backgroundRoot}/background_rain.png';
      case PerchWeather.snow:
        return '${HomePerchAssets.backgroundRoot}/background_snow.png';
      case PerchWeather.fog:
        return '${HomePerchAssets.backgroundRoot}/background_dawn.png';
      case PerchWeather.wind:
        return '${HomePerchAssets.backgroundRoot}/background_storm.png';
      case PerchWeather.clear:
        switch (widget.worldState.timeOfDay) {
          case PerchTimeOfDay.morning:
            return '${HomePerchAssets.backgroundRoot}/background_morning.png';
          case PerchTimeOfDay.midday:
            return '${HomePerchAssets.backgroundRoot}/background_afternoon.png';
          case PerchTimeOfDay.evening:
            return '${HomePerchAssets.backgroundRoot}/background_golden_hour.png';
          case PerchTimeOfDay.night:
            return '${HomePerchAssets.backgroundRoot}/background_night.png';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brain = PerchBrainScope.of(context);
    final journalFocused = brain.state.journalFocused;
    final backgroundAsset = _backgroundForWorldState();
    final lanternOn =
        brain.state.lanternOn || widget.worldState.shouldAutoIlluminateLantern;

    return AmbientQuietView(
      builder: (context, quietRequested) {
        final quiet = quietRequested && !journalFocused;

        return LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final portrait = size.height >= size.width;
            final availableWidth = math.max(0.0, size.width - 24);

            final desiredCompactWidth = math.max(
              300.0,
              size.width * (portrait ? 0.94 : 0.66),
            );
            final compactWidth = math.min(
              availableWidth,
              math.min(980.0, desiredCompactWidth),
            );
            final compactHeight = compactWidth / _journalAspectRatio;
            final compactBottom = math.max(
              portrait ? 26.0 : 18.0,
              size.height * (portrait ? 0.065 : 0.045),
            );
            final compactTop = math.max(
              12.0,
              size.height - compactHeight - compactBottom,
            );

            var focusedWidth = math.min(
              size.width * (portrait ? 0.98 : 0.94),
              1100.0,
            );
            var focusedHeight = focusedWidth / _journalAspectRatio;
            final maxFocusedHeight = size.height * (portrait ? 0.64 : 0.82);
            if (focusedHeight > maxFocusedHeight) {
              focusedHeight = maxFocusedHeight;
              focusedWidth = focusedHeight * _journalAspectRatio;
            }

            final focusedLeft = (size.width - focusedWidth) / 2;
            final focusedTop = portrait
                ? math.max(74.0, (size.height - focusedHeight) / 2)
                : (size.height - focusedHeight) / 2;
            final compactLeft = (size.width - compactWidth) / 2;

            return Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  child: AnimatedScale(
                    key: ValueKey(backgroundAsset),
                    duration: const Duration(milliseconds: 520),
                    curve: Curves.easeInOutCubic,
                    scale: journalFocused ? 1.035 : 1,
                    child: PerchAssetLayer(
                      assetPath: backgroundAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      fallback: PerchAssetLayer(
                        assetPath: HomePerchAssets.deskInteractionBackground,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        fallback: const _BackgroundMissingFallback(
                          assetPath: HomePerchAssets.deskInteractionBackground,
                        ),
                      ),
                    ),
                  ),
                ),
                const _DeskForegroundShade(),
                _AmbientWeatherOverlay(worldState: widget.worldState),
                _LanternRoomGlow(
                  illuminated: lanternOn,
                  portrait: portrait,
                ),
                IgnorePointer(
                  ignoring: quiet,
                  child: AnimatedOpacity(
                    key: const ValueKey('desk-software-affordances'),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    opacity: quiet ? 0 : 1,
                    child: DeskFunctionalityLayer(
                      data: widget.data,
                      journalFocused: journalFocused,
                    ),
                  ),
                ),
                RealisticDeskOverlay(
                  journalFocused: journalFocused,
                  lanternOn: lanternOn,
                  steamOn: brain.state.steamOn,
                  plantStage: brain.state.plantStage,
                  priority: brain.state.priority.isEmpty
                      ? widget.data.nextDue.title
                      : brain.state.priority,
                ),
                IgnorePointer(
                  ignoring: !journalFocused,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 420),
                    opacity: journalFocused ? 1 : 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _setJournalFocused(false),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: journalFocused ? 5 : 0,
                          sigmaY: journalFocused ? 5 : 0,
                        ),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.36),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 560),
                  curve: Curves.easeInOutCubicEmphasized,
                  left: journalFocused ? focusedLeft : compactLeft,
                  top: journalFocused ? focusedTop : compactTop,
                  width: journalFocused ? focusedWidth : compactWidth,
                  height: journalFocused ? focusedHeight : compactHeight,
                  child: Semantics(
                    button: !journalFocused,
                    label: journalFocused
                        ? 'Open journal'
                        : 'Open journal workspace',
                    child: GestureDetector(
                      key: const ValueKey('desk-journal'),
                      behavior: HitTestBehavior.opaque,
                      onTap: journalFocused ? null : _openJournalWorkspace,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 560),
                        curve: Curves.easeInOutCubicEmphasized,
                        transform: journalFocused
                            ? Matrix4.identity()
                            : (Matrix4.identity()..rotateZ(-0.004)),
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            journalFocused ? 18 : 12,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: journalFocused ? 0.55 : 0.52,
                              ),
                              blurRadius: journalFocused ? 46 : 30,
                              spreadRadius: journalFocused ? 6 : 2,
                              offset: Offset(0, journalFocused ? 22 : 18),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            PerchAssetLayer(
                              assetPath: HomePerchAssets.journalOpenToday,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              fallback: const _BackgroundMissingFallback(
                                assetPath: HomePerchAssets.journalOpenToday,
                              ),
                            ),
                            IgnorePointer(
                              ignoring: quiet || !journalFocused,
                              child: AnimatedOpacity(
                                key: const ValueKey('journal-live-content'),
                                duration: const Duration(milliseconds: 420),
                                curve: Curves.easeOutCubic,
                                opacity: journalFocused && !quiet ? 1 : 0,
                                child: JournalEngine(
                                  data: widget.data,
                                  focused: journalFocused,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (journalFocused)
                  Positioned(
                    left: 14,
                    top: 14,
                    child: SafeArea(
                      child: GestureDetector(
                        onTap: () => _setJournalFocused(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17110D).withValues(
                              alpha: 0.86,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Color(0xFFF6E8C8),
                                size: 18,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Back to desk',
                                style: TextStyle(
                                  color: Color(0xFFF6E8C8),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DeskForegroundShade extends StatelessWidget {
  const _DeskForegroundShade();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Color(0x08000000),
              Color(0x24000000),
            ],
            stops: [0.48, 0.72, 1],
          ),
        ),
      ),
    );
  }
}

class _LanternRoomGlow extends StatelessWidget {
  const _LanternRoomGlow({
    required this.illuminated,
    required this.portrait,
  });

  final bool illuminated;
  final bool portrait;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        key: const ValueKey('lantern-room-glow'),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
        opacity: illuminated ? 1 : 0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                portrait ? 0.82 : 0.76,
                portrait ? -0.58 : -0.66,
              ),
              radius: portrait ? 0.72 : 0.64,
              colors: [
                const Color(0xFFFFC66B).withValues(alpha: 0.20),
                const Color(0xFFFFA637).withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0, 0.42, 1],
            ),
          ),
        ),
      ),
    );
  }
}

class _AmbientWeatherOverlay extends StatelessWidget {
  const _AmbientWeatherOverlay({required this.worldState});

  final PerchWorldState worldState;

  @override
  Widget build(BuildContext context) {
    if (!worldState.hasWeatherMotion) return const SizedBox.shrink();

    final color = switch (worldState.weather) {
      PerchWeather.rain => const Color(0x332A4058),
      PerchWeather.fog => const Color(0x44D7D7D0),
      PerchWeather.snow => const Color(0x33E8F1F5),
      PerchWeather.wind => const Color(0x221C2630),
      PerchWeather.clear => Colors.transparent,
    };

    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              Colors.transparent,
              color.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class _BackgroundMissingFallback extends StatelessWidget {
  const _BackgroundMissingFallback({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D140E),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(
        'Perch image missing.\nPlace this file in the project:\n$assetPath',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF6E8C8),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
