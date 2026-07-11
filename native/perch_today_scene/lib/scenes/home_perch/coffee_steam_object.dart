import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoffeeSteamObject extends StatefulWidget {
  const CoffeeSteamObject({
    super.key,
    required this.journalFocused,
  });

  final bool journalFocused;

  @override
  State<CoffeeSteamObject> createState() => _CoffeeSteamObjectState();
}

class _CoffeeSteamObjectState extends State<CoffeeSteamObject>
    with SingleTickerProviderStateMixin {
  static const _steamKey = 'perch.coffee.steam';

  late final AnimationController _controller;
  bool _steamOn = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _steamOn = prefs.getBool(_steamKey) ?? true;
      _loaded = true;
    });
  }

  Future<void> _toggle() async {
    setState(() => _steamOn = !_steamOn);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_steamKey, _steamOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    return IgnorePointer(
      ignoring: widget.journalFocused,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: widget.journalFocused ? 0 : 1,
        child: Align(
          alignment: const Alignment(-0.78, 0.63),
          child: FractionallySizedBox(
            widthFactor: 0.17,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: AspectRatio(
                  aspectRatio: 0.78,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 160),
                        scale: _steamOn ? 1 : 0.97,
                        child: const _MugBody(),
                      ),
                      if (_steamOn)
                        Positioned.fill(
                          top: -34,
                          bottom: 36,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final t = _controller.value;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _SteamWisp(
                                    progress: t,
                                    horizontalBias: -0.22,
                                    delay: 0.00,
                                    size: 32,
                                  ),
                                  _SteamWisp(
                                    progress: t,
                                    horizontalBias: 0.02,
                                    delay: 0.28,
                                    size: 38,
                                  ),
                                  _SteamWisp(
                                    progress: t,
                                    horizontalBias: 0.26,
                                    delay: 0.56,
                                    size: 30,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: _steamOn ? 1 : 0.58,
                          child: Text(
                            _steamOn ? 'HOT' : 'COLD',
                            style: const TextStyle(
                              color: Color(0xFFF5E5C7),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                              shadows: [
                                Shadow(color: Colors.black87, blurRadius: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MugBody extends StatelessWidget {
  const _MugBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 34, 8, 14),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 76,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF7E9D0), Color(0xFFB99B75)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: const Color(0xFF5A402C), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            right: -5,
            top: 12,
            child: Container(
              width: 28,
              height: 31,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB99B75), width: 7),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: 2,
            child: Container(
              width: 64,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF4A2D1D),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF72513B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SteamWisp extends StatelessWidget {
  const _SteamWisp({
    required this.progress,
    required this.horizontalBias,
    required this.delay,
    required this.size,
  });

  final double progress;
  final double horizontalBias;
  final double delay;
  final double size;

  @override
  Widget build(BuildContext context) {
    final local = (progress + delay) % 1.0;
    final rise = 58 * local;
    final sway = horizontalBias * 54 + (local - 0.5) * 14;
    final opacity = (1 - local).clamp(0.0, 1.0) * 0.85;

    return Align(
      alignment: Alignment(horizontalBias, 0.78),
      child: Transform.translate(
        offset: Offset(sway, -rise),
        child: Transform.scale(
          scale: 0.72 + (local * 0.48),
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.air_rounded,
              size: size,
              color: const Color(0xFFF8F4EA),
              shadows: const [
                Shadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
