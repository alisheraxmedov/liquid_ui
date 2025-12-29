import 'dart:ui';
import 'package:flutter/material.dart';

import '../types/liquid_material_type.dart';
import '../painters/gradient_border_painter.dart';
import '../painters/specular_light_painter.dart';
import '../painters/noise_overlay_painter.dart';
import '../utils/platform_config.dart';

/// A widget that creates a true iOS-style liquid material effect.
///
/// This widget provides Apple's liquid glass design with customizable
/// material types, colorless mode, specular lighting, and optional
/// noise overlay for authenticity.
///
/// Unlike traditional glassmorphism, [LiquidMaterial] ensures the
/// background colors are never tinted (colorless guarantee mode).
///
/// Example:
/// ```dart
/// LiquidMaterial(
///   type: LiquidMaterialType.regular,
///   colorless: true,
///   specularLight: true,
///   child: Text('Hello Liquid UI'),
/// )
/// ```
class LiquidMaterial extends StatelessWidget {
  /// The material thickness type.
  ///
  /// Defaults to [LiquidMaterialType.regular].
  final LiquidMaterialType type;

  /// Whether to use colorless guarantee mode.
  ///
  /// When true, the background colors are never tinted.
  /// Defaults to true.
  final bool colorless;

  /// Whether to show specular light effect.
  ///
  /// Creates a subtle top-to-bottom light gradient.
  /// Defaults to true.
  final bool specularLight;

  /// Whether to show noise overlay texture.
  ///
  /// Adds a subtle glass texture for iOS authenticity.
  /// Defaults to false.
  final bool noiseOverlay;

  /// The border radius for rounded corners.
  ///
  /// Defaults to 20.
  final double borderRadius;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// The child widget to display inside.
  final Widget? child;

  /// Creates a [LiquidMaterial] widget.
  const LiquidMaterial({
    super.key,
    this.type = LiquidMaterialType.regular,
    this.colorless = true,
    this.specularLight = true,
    this.noiseOverlay = false,
    this.borderRadius = 20,
    this.width,
    this.height,
    this.child,
  });

  /// Creates an adaptive [LiquidMaterial] that adjusts to platform.
  ///
  /// On iOS: Full quality
  /// On Android: Optimized
  /// On Web: Fallback (no blur)
  factory LiquidMaterial.adaptive({
    Key? key,
    LiquidMaterialType type = LiquidMaterialType.regular,
    bool colorless = true,
    bool specularLight = true,
    bool noiseOverlay = false,
    double borderRadius = 20,
    double? width,
    double? height,
    Widget? child,
  }) {
    return LiquidMaterial(
      key: key,
      type: type,
      colorless: colorless,
      specularLight: specularLight,
      noiseOverlay: noiseOverlay,
      borderRadius: borderRadius,
      width: width,
      height: height,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final blurSigma = type.blurSigma * PlatformConfig.blurMultiplier;
    final isBlurEnabled = PlatformConfig.isBlurEnabled && blurSigma > 0;

    // Get opacity multiplier based on material type
    final opacityMultiplier = _getOpacityMultiplier();

    // Fallback for web (solid background)
    final fallbackColor = colorless
        ? Colors.grey.withValues(alpha: PlatformConfig.fallbackOpacity)
        : Colors.white.withValues(alpha: PlatformConfig.fallbackOpacity);

    // Main container with INNER GRADIENT (key liquid effect!)
    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // Base fill color
        color: Colors.white.withValues(alpha: 0.08 * opacityMultiplier),
        borderRadius: BorderRadius.circular(borderRadius),
        // IMPORTANT: Inner gradient for liquid effect (topLeft bright → bottomRight dim)
        gradient: isBlurEnabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(
                    alpha: 0.5 * opacityMultiplier,
                  ), // Top-left highlight
                  Colors.white.withValues(
                    alpha: 0.05 * opacityMultiplier,
                  ), // Bottom-right fade
                ],
              )
            : null,
        // Strong shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child ?? const SizedBox(),
    );

    // Apply fallback color for web
    if (!isBlurEnabled) {
      content = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: fallbackColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child ?? const SizedBox(),
      );
    }

    // Add specular light effect (optional top-to-bottom light)
    if (specularLight && isBlurEnabled) {
      content = CustomPaint(
        foregroundPainter: SpecularLightPainter(
          borderRadius: borderRadius,
          intensity: 0.2 * opacityMultiplier,
        ),
        child: content,
      );
    }

    // Add noise overlay (optional glass texture)
    if (noiseOverlay && isBlurEnabled) {
      content = CustomPaint(
        foregroundPainter: NoiseOverlayPainter(
          borderRadius: borderRadius,
          opacity: 0.03,
        ),
        child: content,
      );
    }

    // Add gradient border (key liquid effect!)
    content = CustomPaint(
      foregroundPainter: GradientBorderPainter(
        borderRadius: borderRadius,
        width: 1.5, // Thicker border like original
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(
              alpha: 0.6 * opacityMultiplier,
            ), // Top-Left: Bright
            Colors.white.withValues(
              alpha: 0.1 * opacityMultiplier,
            ), // Center: Dim
            Colors.white.withValues(
              alpha: 0.6 * opacityMultiplier,
            ), // Bottom-Right: Bright
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: content,
    );

    // Apply blur effect (skip on web)
    if (isBlurEnabled) {
      Widget blurWidget = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: content,
        ),
      );

      // Wrap in RepaintBoundary for performance optimization on Android
      if (PlatformConfig.usePerformanceOptimizations) {
        return RepaintBoundary(child: blurWidget);
      }
      return blurWidget;
    }

    // Fallback without blur
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: content,
    );
  }

  /// Get opacity multiplier based on material type and colorless mode
  double _getOpacityMultiplier() {
    if (!colorless) {
      return 1.2; // Slightly more visible when colorless is off
    }
    switch (type) {
      case LiquidMaterialType.ultraThin:
        return 0.6;
      case LiquidMaterialType.thin:
        return 0.8;
      case LiquidMaterialType.regular:
        return 1.0;
      case LiquidMaterialType.thick:
        return 1.3;
    }
  }
}
