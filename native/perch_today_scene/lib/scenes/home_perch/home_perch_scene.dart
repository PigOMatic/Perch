import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../data/perch_today_models.dart';
import '../../widgets/perch_asset_layer.dart';
import '../../world/perch_world_state.dart';

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

  bool _journalFocused = false;

  void _setJournalFocused(bool value) {
    if (_journalFocused == value) return;
    setState(() => _journalFocused = value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final availableWidth = math.max(0.0, size.width - 24);

        // Keep the journal visually substantial on small and large windows.
        final desiredCompactWidth = math.max(280.0, size.width * 0.78);
        final compactWidth = math.min(
          availableWidth,
          math.min(720.0, desiredCompactWidth),
        );
        final compactHeight = compactWidth / _journalAspectRatio;

        // Anchor the journal near the lower desk surface instead of mid-screen.
        final compactBottom = math.max(18.0, size.height * 0.055);
        final compactTop = math.max(
          12.0,
          size.height - compactHeight - compactBottom,
        );

        var focusedWidth = math.min(size.width * 0.94, 1100.0);
        var focusedHeight = focusedWidth / _journalAspectRatio;
        final maxFocusedHeight = size.height * 0.82;
        if (focusedHeight > maxFocusedHeight) {
          focusedHeight = maxFocusedHeight;
          focusedWidth = focusedHeight * _journalAspectRatio;
        }

        final focusedLeft = (size.width - focusedWidth) / 2;
        final focusedTop = (size.height - focusedHeight) / 2;
        final compactLeft = (size.width - compactWidth) / 2;

        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeInOutCubic,
              scale: _journalFocused ? 1.035 : 1,
              child: PerchAssetLayer(
                assetPath: HomePerchAssets.deskInteractionBackground,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                fallback: const _BackgroundMissingFallback(
                  assetPath: HomePerchAssets.deskInteractionBackground,
                ),
              ),
            ),
            IgnorePointer(
              ignoring: !_journalFocused,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 420),
                opacity: _journalFocused ? 1 : 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _setJournalFocused(false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _journalFocused ? 5 : 0,
                      sigmaY: _journalFocused ? 5 : 0,
                    ),
                    child: Container(color: Colors.black.withOpacity(0.36)),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 560),
              curve: Curves.easeInOutCubicEmphasized,
              left: _journalFocused ? focusedLeft : compactLeft,
              top: _journalFocused ? focusedTop : compactTop,
              width: _journalFocused ? focusedWidth : compactWidth,
              height: _journalFocused ? focusedHeight : compactHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _setJournalFocused(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 560),
                  curve: Curves.easeInOutCubicEmphasized,
                  transform: _journalFocused
                      ? Matrix4.identity()
                      : (Matrix4.identity()..rotateZ(-0.008)),
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      _journalFocused ? 18 : 12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          _journalFocused ? 0.55 : 0.42,
                        ),
                        blurRadius: _journalFocused ? 46 : 24,
                        spreadRadius: _journalFocused ? 6 : 1,
                        offset: Offset(0, _journalFocused ? 22 : 12),
                      ),
                    ],
                  ),
                  child: PerchAssetLayer(
                    assetPath: HomePerchAssets.journalOpenToday,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    fallback: const _BackgroundMissingFallback(
                      assetPath: HomePerchAssets.journalOpenToday,
                    ),
                  ),
                ),
              ),
            ),
            if (_journalFocused)
              Positioned(
                left: 18,
                top: 18,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () => _setJournalFocused(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF17110D).withOpacity(0.84),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
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
