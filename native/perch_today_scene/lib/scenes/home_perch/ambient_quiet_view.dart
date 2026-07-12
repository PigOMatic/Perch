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

class _AmbientQuietViewState extends State<AmbientQuietView> {
  Timer? _settleTimer;
  bool _quiet = false;

  @override
  void initState() {
    super.initState();
    _armQuietTimer();
  }

  @override
  void didUpdateWidget(covariant AmbientQuietView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settleDelay != widget.settleDelay) {
      _registerActivity();
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
    _armQuietTimer();
    if (!_quiet) return;
    setState(() => _quiet = false);
    widget.onQuietChanged?.call(false);
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _registerActivity(),
      onHover: (_) => _registerActivity(),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _registerActivity(),
        onPointerSignal: (_) => _registerActivity(),
        child: Focus(
          onFocusChange: (focused) {
            if (focused) _registerActivity();
          },
          child: widget.builder(context, _quiet),
        ),
      ),
    );
  }
}
