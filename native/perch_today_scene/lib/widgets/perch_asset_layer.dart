import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../assets/home_perch_embedded_assets.dart';

/// Renders a photoreal scene asset when present.
///
/// Physical asset files are preferred. During the current visual slice, several
/// raster WebP assets are embedded as base64 so the app visibly changes even
/// before binary asset upload is available in the coding workflow.
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
    final embeddedAsset = homePerchEmbeddedAssets[assetPath];

    return Opacity(
      opacity: opacity,
      child: embeddedAsset != null
          ? Image.memory(
              Uint8List.fromList(base64Decode(embeddedAsset)),
              fit: fit,
              alignment: alignment,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
            )
          : Image.asset(
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
