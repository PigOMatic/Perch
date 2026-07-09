import 'package:flutter/material.dart';

/// Renders a photoreal scene asset when present.
///
/// Missing assets intentionally fail soft during development so the app remains
/// runnable while the art pack is being generated and added.
class PerchAssetLayer extends StatelessWidget {
  const PerchAssetLayer({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.opacity = 1,
    this.fallback,
  });

  final String assetPath;
  final BoxFit fit;
  final Alignment alignment;
  final double opacity;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(
        assetPath,
        fit: fit,
        alignment: alignment,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          return fallback ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
