import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../world/ambient_motion_driver.dart';
import '../../world/ambient_motion_profile.dart';

class RealisticDeskOverlay extends StatelessWidget {
  const RealisticDeskOverlay({
    super.key,
    required this.journalFocused,
    required this.lanternOn,
    required this.steamOn,
    required this.plantStage,
    required this.priority,
    this.motionProfile,
  });

  final bool journalFocused;
  final bool lanternOn;
  final bool steamOn;
  final int plantStage;
  final String priority;
  final AmbientMotionProfile? motionProfile;

  AmbientMotionProfile _profileFor(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!reduced && motionProfile != null) return motionProfile!;

    return AmbientMotionProfile(
      weather: 0,
      plantSway: reduced ? 0 : .08,
      steamDrift: steamOn ? (reduced ? .12 : .20) : 0,
      lanternPulse: lanternOn ? (reduced ? .08 : .18) : 0,
      plantPeriod:
          reduced ? Duration.zero : const Duration(milliseconds: 7600),
      steamPeriod:
          reduced ? Duration.zero : const Duration(milliseconds: 3600),
      lanternPeriod:
          reduced ? Duration.zero : const Duration(milliseconds: 6200),
      continuousMotionEnabled: !reduced,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profileFor(context);
    return AmbientMotionDriver(
      profile: profile,
      builder: (context, frame) => IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 260),
          opacity: journalFocused ? 0 : 1,
          child: LayoutBuilder(
            builder: (context, box) {
              final portrait = box.maxHeight >= box.maxWidth;
              return Stack(
                fit: StackFit.expand,
                children: [
                  _place(
                    box,
                    portrait ? .035 : .03,
                    portrait ? .62 : .58,
                    portrait ? .23 : .145,
                    _Coffee(
                      steamOn: steamOn,
                      animation: frame.steam,
                      drift: profile.steamDrift,
                    ),
                  ),
                  _place(
                    box,
                    portrait ? .76 : .83,
                    portrait ? .67 : .63,
                    portrait ? .18 : .105,
                    const _Asset(
                      asset: HomePerchAssets.pen,
                      rotation: -.22,
                      shadowOffset: Offset(6, 12),
                    ),
                  ),
                  _place(
                    box,
                    portrait ? .69 : .755,
                    portrait ? .46 : .42,
                    portrait ? .27 : .17,
                    const _Asset(
                      asset: HomePerchAssets.envelope,
                      rotation: .025,
                      shadowOffset: Offset(4, 12),
                    ),
                  ),
                  _place(
                    box,
                    portrait ? .035 : .045,
                    portrait ? .44 : .405,
                    portrait ? .31 : .20,
                    _Sticky(text: priority),
                  ),
                  _place(
                    box,
                    portrait ? .075 : .085,
                    portrait ? .19 : .125,
                    portrait ? .21 : .13,
                    _Plant(
                      stage: plantStage,
                      animation: frame.plant,
                      sway: profile.plantSway,
                    ),
                  ),
                  _place(
                    box,
                    portrait ? .765 : .82,
                    portrait ? .17 : .115,
                    portrait ? .20 : .125,
                    _Lantern(
                      on: lanternOn,
                      animation: frame.lantern,
                      pulse: profile.lanternPulse,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _place(
    BoxConstraints box,
    double x,
    double y,
    double widthFactor,
    Widget child,
  ) {
    return Positioned(
      left: box.maxWidth * x,
      top: box.maxHeight * y,
      width: box.maxWidth * widthFactor,
      child: child,
    );
  }
}

class _Asset extends StatelessWidget {
  const _Asset({
    required this.asset,
    this.rotation = 0,
    this.shadowOffset = const Offset(0, 10),
  });

  final String asset;
  final double rotation;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .38),
              blurRadius: 18,
              offset: shadowOffset,
            ),
          ],
        ),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _Coffee extends StatelessWidget {
  const _Coffee({
    required this.steamOn,
    required this.animation,
    required this.drift,
  });

  final bool steamOn;
  final Animation<double> animation;
  final double drift;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .9,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          const _Asset(asset: HomePerchAssets.coffeeMug, rotation: -.025),
          if (steamOn)
            Positioned.fill(
              top: -38,
              left: 20,
              right: 20,
              bottom: 40,
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) => CustomPaint(
                  painter: _SteamPainter(animation.value, drift: drift),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SteamPainter extends CustomPainter {
  const _SteamPainter(this.progress, {required this.drift});

  final double progress;
  final double drift;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.2, size.width * .018);

    for (var i = 0; i < 3; i++) {
      final phase = (progress + i * .29) % 1;
      final x = size.width * (.28 + i * .22);
      final y = size.height * (1 - phase * .86);
      final horizontalDrift = size.width * (.04 + drift * .18);
      final path = Path()
        ..moveTo(x, y)
        ..cubicTo(
          x - horizontalDrift,
          y - size.height * .16,
          x + horizontalDrift * 1.2,
          y - size.height * .30,
          x + math.sin(phase * math.pi * 2) * horizontalDrift,
          y - size.height * .47,
        );
      paint.color = Colors.white.withValues(alpha: (1 - phase) * .32);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.drift != drift;
}

class _Sticky extends StatelessWidget {
  const _Sticky({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.035,
      child: AspectRatio(
        aspectRatio: 1.18,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              HomePerchAssets.sticky,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFF2D77D)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
              child: Center(
                child: Text(
                  text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF423222),
                    fontSize: MediaQuery.sizeOf(context).width < 700 ? 10 : 13,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    shadows: const [
                      Shadow(color: Colors.white54, offset: Offset(0, 1)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Plant extends StatelessWidget {
  const _Plant({
    required this.stage,
    required this.animation,
    required this.sway,
  });

  final int stage;
  final Animation<double> animation;
  final double sway;

  @override
  Widget build(BuildContext context) {
    final normalizedStage = stage.clamp(0, 3).toInt();
    final scale = switch (normalizedStage) {
      0 => .56,
      1 => .72,
      2 => .88,
      _ => 1.0,
    };

    return Semantics(
      label: 'Plant growth stage $normalizedStage',
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Transform.rotate(
          angle: (animation.value - .5) * (.012 + sway * .08),
          alignment: Alignment.bottomCenter,
          child: child,
        ),
        child: AspectRatio(
          aspectRatio: .9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                key: const ValueKey('plant-pot'),
                width: 58,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B7661), Color(0xFF47392F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6),
                    bottom: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 14,
                      offset: Offset(0, 9),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                key: ValueKey('plant-stage-$normalizedStage'),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 96,
                  height: 105,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        bottom: 30,
                        child: Icon(
                          Icons.eco,
                          size: normalizedStage == 0 ? 44 : 76,
                          color: const Color(0xFF496D38),
                        ),
                      ),
                      if (normalizedStage >= 1)
                        const Positioned(
                          left: 8,
                          bottom: 40,
                          child: Icon(
                            Icons.eco,
                            size: 48,
                            color: Color(0xFF6F914E),
                          ),
                        ),
                      if (normalizedStage >= 2)
                        const Positioned(
                          right: 4,
                          bottom: 50,
                          child: Icon(
                            Icons.eco,
                            size: 52,
                            color: Color(0xFF587D42),
                          ),
                        ),
                      if (normalizedStage >= 3)
                        const Positioned(
                          top: 0,
                          child: Icon(
                            Icons.local_florist,
                            size: 36,
                            color: Color(0xFFD79A5A),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lantern extends StatelessWidget {
  const _Lantern({
    required this.on,
    required this.animation,
    required this.pulse,
  });

  final bool on;
  final Animation<double> animation;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final normalizedPulse = math.max(0.0, math.min(1.0, pulse));
        final glow = on
            ? .82 + (animation.value - .5) * normalizedPulse
            : 0.0;
        final glowAlpha = math.max(0.0, math.min(1.0, .42 * glow));
        return AspectRatio(
          aspectRatio: .78,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (on)
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB64A).withValues(
                          alpha: glowAlpha,
                        ),
                        blurRadius: 48,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              Container(
                width: 74,
                height: 108,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D332A), Color(0xFF0E0C0A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF7D6A55),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 36,
                    height: 56,
                    decoration: BoxDecoration(
                      color: on
                          ? const Color(0xFFFFD070).withValues(alpha: .82)
                          : const Color(0xFF3A342E),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: on
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFB13B).withValues(
                                  alpha: .65,
                                ),
                                blurRadius: 22,
                                spreadRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
