import 'package:flutter/material.dart';

@immutable
class DeskObjectSpec {
  const DeskObjectSpec({
    required this.id,
    required this.label,
    required this.position,
    required this.widthFactor,
    this.rotation = 0,
    this.depth = 0,
    this.enabled = true,
    this.hasNotification = false,
  });

  final String id;
  final String label;
  final Offset position;
  final double widthFactor;
  final double rotation;
  final double depth;
  final bool enabled;
  final bool hasNotification;
}

class DeskObject extends StatefulWidget {
  const DeskObject({
    super.key,
    required this.spec,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.focused = false,
  });

  final DeskObjectSpec spec;
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool focused;

  @override
  State<DeskObject> createState() => _DeskObjectState();
}

class _DeskObjectState extends State<DeskObject> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.focused ? 1.06 : (_hovered ? 1.025 : 1.0);

    return Semantics(
      button: true,
      enabled: widget.spec.enabled,
      label: widget.spec.label,
      child: Tooltip(
        message: widget.spec.label,
        child: MouseRegion(
          cursor: widget.spec.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.spec.enabled ? widget.onTap : null,
            onLongPress: widget.spec.enabled ? widget.onLongPress : null,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              scale: scale,
              child: Transform.rotate(
                angle: widget.spec.rotation,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    widget.child,
                    if (widget.spec.hasNotification)
                      const Positioned(
                        right: -4,
                        top: -4,
                        child: _NotificationDot(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationDot extends StatelessWidget {
  const _NotificationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
      ),
    );
  }
}
