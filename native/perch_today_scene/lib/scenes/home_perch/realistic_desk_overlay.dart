import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';

class RealisticDeskOverlay extends StatefulWidget {
  const RealisticDeskOverlay({
    super.key,
    required this.journalFocused,
    required this.lanternOn,
    required this.steamOn,
    required this.priority,
  });

  final bool journalFocused;
  final bool lanternOn;
  final bool steamOn;
  final String priority;

  @override
  State<RealisticDeskOverlay> createState() => _RealisticDeskOverlayState();
}

class _RealisticDeskOverlayState extends State<RealisticDeskOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _steamController;
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _steamController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 260),
        opacity: widget.journalFocused ? 0 : 1,
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
                  _CoffeeObject(
                    steamOn: widget.steamOn,
                    steamController: _steamController,
                  ),
                ),
                _place(
                  box,
                  portrait ? .76 : .83,
                  portrait ? .67 : .63,
                  portrait ? .18 : .105,
                  _AssetObject(
                    asset: HomePerchAssets.pen,
                    rotation: -.22,
                    shadowOffset: const Offset(6, 12),
                  ),
                ),
                _place(
                  box,
                  portrait ? .69 : .755,
                  portrait ? .46 : .42,
                  portrait ? .27 : .17,
                  _AssetObject(
                    asset: HomePerchAssets.envelope,
                    rotation: .025,
                    shadowOffset: const Offset(4, 12),
                  ),
                ),
                _place(
                  box,
                  portrait ? .035 : .045,
                  portrait ? .44 : .405,
                  portrait ? .31 : .20,
                  _StickyObject(text: widget.priority),
                ),
                _place(
                  box,
                  portrait ? .075 : .085,
                  portrait ? .19 : .125,
                  portrait ? .21 : .13,
                  _PlantObject(animation: _ambientController),
                ),
                _place(
                  box,
                  portrait ? .765 : .82,
                  portrait ? .17 : .115,
                  portrait ? .20 : .125,
                  _LanternObject(
                    on: widget.lanternOn,
                    animation: _ambientController,
                  ),
                ),
              ],
            );
          },
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

class _AssetObject extends StatelessWidget {
  const _AssetObject({
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
              color: Colors.black.withOpacity(.38),
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

class _CoffeeObject extends StatelessWidget {
  const _CoffeeObject({
    required this.steamOn,
    required this.steamController,
  });

  final bool steamOn;
  final AnimationController steamController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .9,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          _AssetObject(
            asset: HomePerchAssets.coffeeMug,
            rotation: -.025,
          ),
          if (steamOn)
            Positioned.fill(
              top: -38,
              left: 20,
              right: 20,
              bottom: 40,
              child: AnimatedBuilder(
                animation: steamController,
                builder: (context, child) {
                  final t = steamController.value;
                  return CustomPaint(painter: _SteamPainter(t));
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SteamPainter extends CustomPainter {
  const _SteamPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.2, size.width * .018)
      ..color = Colors.white.withOpacity(.34);

    for (var i = 0; i < 3; i++) {
      final phase = (progress + i * .29) % 1;
      final path = Path();
      final x = size.width * (.28 + i * .22);
      final y = size.height * (1 - phase * .86);
      path.moveTo(x, y);
      path.cubicTo(
        x - size.width * .12,
        y - size.height * .16,
        x + size.width * .15,
        y - size.height * .30,
        x + math.sin(phase * math.pi * 2) * size.width * .07,
        y - size.height * .47,
      );
      paint.color = Colors.white.withOpacity((1 - phase) * .32);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StickyObject extends StatelessWidget {
  const _StickyObject({required this.text});

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
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF2D77D),
              ),
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

class _PlantObject extends StatelessWidget {
  const _PlantObject({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.rotate(
        angle: (animation.value - .5) * .018,
        alignment: Alignment.bottomCenter,
        child: child,
      ),
      child: AspectRatio(
        aspectRatio: .9,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 58,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B7661), Color(0xFF47392F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                  bottom: Radius.circular(16),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 14, offset: Offset(0, 9)),
                ],
              ),
            ),
            const Positioned(
              bottom: 34,
              child: Icon(Icons.eco, size: 76, color: Color(0xFF496D38)),
            ),
            const Positioned(
              left: 17,
              bottom: 45,
              child: Icon(Icons.eco, size: 54, color: Color(0xFF6F914E)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanternObject extends StatelessWidget {
  const _LanternObject({required this.on, required this.animation});

  final bool on;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulse = on ? .75 + animation.value * .25 : 0.0;
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
                        color: const Color(0xFFFFB64A).withOpacity(.42 * pulse),
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
                  border: Border.all(color: const Color(0xFF7D6A55), width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 12)),
                  ],
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    width: 36,
                    height: 56,
                    decoration: BoxDecoration(
                      color: on
                          ? const Color(0xFFFFD070).withOpacity(.82)
                          : const Color(0xFF3A342E),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: on
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFB13B).withOpacity(.65),
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
