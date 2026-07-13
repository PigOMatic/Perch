import 'dart:async';

import 'package:flutter/widgets.dart';

/// Detects inactivity around the Perch scene and exposes a calm presentation
/// state without owning any of the desk's visual design.
///
/// The scene decides which software affordances fade while physical objects,
/// weather, lighting, steam, and other ambience continue to render.
class AmbientQuietView extends StatefulWidget {
  const AmbientQuietView({
    super.key,
    required this.builder,
    this.settleDelay = const Duration(seconds: 20),
    this.onQuietChanged,
  });

  final Widget Function(BuildContext context, bool quiet) builder;
  final Duration settleDelay;
  final ValueChanged<bool>? onQuietChanged;

  @override
  State<AmbientQuietView> createState() => _AmbientQuietViewState();
}

class _AmbientQuietViewState extends State<AmbientQuietView>
    with WidgetsBindingObserver {
  static const _maxPassiveActivityInterval = Duration(milliseconds: 250);

  Timer? _settleTimer;
  bool _quiet = false;
  DateTime? _lastPassiveActivity;

  Duration get _passiveActivityInterval {
    final quarterDelay = Duration(
      microseconds: widget.settleDelay.inMicroseconds ~/ 4,
    );
    return quarterDelay < _maxPassiveActivityInterval
        ? quarterDelay
        : _maxPassiveActivityInterval;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _armQuietTimer();
  }

  @override
  void didUpdateWidget(covariant AmbientQuietView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settleDelay != widget.settleDelay) {
      _registerActivity();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _registerActivity();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _settleTimer?.cancel();
        break;
    }
  }

  void _armQuietTimer() {
    _settleTimer?.cancel();
    _settleTimer = Timer(widget.settleDelay, _enterQuietMode);
  }

  void _enterQuietMode() {
    if (!mounted || _quiet) return;
    setState(() => _quiet = true);
    widget.onQuietChanged?.call(true);
  }

  void _registerActivity() {
    if (!mounted) return;
    _lastPassiveActivity = DateTime.now();
    _armQuietTimer();
    if (!_quiet) return;
    setState(() => _quiet = false);
    widget.onQuietChanged?.call(false);
  }

  void _registerPassiveActivity() {
    if (!mounted) return;

    // Pointer hover and movement can arrive at display refresh rate. Coalescing
    // those events avoids continuously allocating and cancelling timers while
    // preserving immediate wake-up from Quiet View. The interval scales down
    // with short settle delays so tests and custom configurations cannot enter
    // Quiet View while meaningful pointer movement is still occurring.
    if (_quiet) {
      _registerActivity();
      return;
    }

    final now = DateTime.now();
    final last = _lastPassiveActivity;
    if (last != null && now.difference(last) < _passiveActivityInterval) return;

    _lastPassiveActivity = now;
    _armQuietTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _registerPassiveActivity(),
      onHover: (_) => _registerPassiveActivity(),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _registerActivity(),
        onPointerMove: (_) => _registerPassiveActivity(),
        onPointerSignal: (_) => _registerActivity(),
        child: Focus(
          onFocusChange: (focused) {
            if (focused) _registerActivity();
          },
          onKeyEvent: (_, __) {
            _registerActivity();
            return KeyEventResult.ignored;
          },
          child: widget.builder(context, _quiet),
        ),
      ),
    );
  }
}
