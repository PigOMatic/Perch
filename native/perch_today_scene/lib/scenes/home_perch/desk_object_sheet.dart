import 'package:flutter/material.dart';

/// Visual treatments for the physical object that opened a desk workspace.
enum DeskObjectSheetStyle {
  paper,
  stickyNote,
}

/// Opens a phone-first, draggable workspace while leaving the desk visible
/// behind it. The sheet deliberately avoids a full-screen route so opening an
/// object still feels like interacting with the same physical desk.
Future<T?> showDeskObjectSheet<T>({
  required BuildContext context,
  required String semanticsLabel,
  required WidgetBuilder builder,
  DeskObjectSheetStyle style = DeskObjectSheetStyle.paper,
  double initialChildSize = .58,
  double minChildSize = .28,
  double maxChildSize = .92,
}) {
  assert(minChildSize > 0 && minChildSize <= 1);
  assert(initialChildSize >= minChildSize);
  assert(maxChildSize >= initialChildSize && maxChildSize <= 1);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .30),
    builder: (sheetContext) => Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticsLabel,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snap: true,
        snapSizes: <double>{minChildSize, initialChildSize, maxChildSize}.toList()
          ..sort(),
        builder: (context, scrollController) => _DeskObjectSheetSurface(
          style: style,
          scrollController: scrollController,
          child: builder(context),
        ),
      ),
    ),
  );
}

class DeskObjectSheetBody extends StatelessWidget {
  const DeskObjectSheetBody({
    super.key,
    required this.title,
    required this.child,
    this.eyebrow,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(22, 4, 22, 32),
  });

  final String? eyebrow;
  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (eyebrow != null) ...[
                      Text(
                        eyebrow!.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF725D3F),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      title,
                      style: textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF2F2419),
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _DeskObjectSheetSurface extends StatelessWidget {
  const _DeskObjectSheetSurface({
    required this.style,
    required this.scrollController,
    required this.child,
  });

  final DeskObjectSheetStyle style;
  final ScrollController scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final colors = switch (style) {
      DeskObjectSheetStyle.paper => const <Color>[
          Color(0xFFFFFCF5),
          Color(0xFFF4EAD7),
        ],
      DeskObjectSheetStyle.stickyNote => const <Color>[
          Color(0xFFFFE993),
          Color(0xFFF0CF61),
        ],
    };

    return Material(
      key: const ValueKey('desk-object-sheet'),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(compact ? 26 : 34),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: .68),
              width: 1.2,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 34,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PaperTexturePainter(
                    dark: style == DeskObjectSheetStyle.stickyNote,
                  ),
                ),
              ),
            ),
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      key: const ValueKey('desk-object-sheet-handle'),
                      width: 46,
                      height: 5,
                      margin: const EdgeInsets.only(top: 11, bottom: 11),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B3A28).withValues(alpha: .34),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: child),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  const _PaperTexturePainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = .7
      ..color = (dark ? const Color(0xFF725514) : const Color(0xFF7F6B50))
          .withValues(alpha: .055);

    for (double y = 38; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 2), paint);
    }

    final grain = Paint()
      ..color = const Color(0xFF3A2B1D).withValues(alpha: .025);
    for (double x = 12; x < size.width; x += 31) {
      for (double y = 18; y < size.height; y += 47) {
        canvas.drawCircle(Offset(x, y), .75, grain);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PaperTexturePainter oldDelegate) =>
      oldDelegate.dark != dark;
}
