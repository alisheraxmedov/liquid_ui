import 'dart:ui';
import 'package:flutter/material.dart';

import '../painters/gradient_border_painter.dart';
import '../utils/platform_config.dart';

/// A widget that creates a frosted glass effect with a gradient border.
///
/// This widget is designed to create iOS-style liquid glass UI elements
/// with blur effects, gradient borders, and subtle shadows.
///
/// The [GlassWidget] uses [BackdropFilter] to create the blur effect
/// and [CustomPaint] with [GradientBorderPainter] for the border.
///
/// Note: This is the legacy widget. Consider using [LiquidMaterial] for
/// more customization options and better performance on Android.
class GlassWidget extends StatelessWidget {
  /// The width of the glass widget.
  ///
  /// If null, the widget will size itself to its child.
  final double? width;

  /// The height of the glass widget.
  ///
  /// If null, the widget will size itself to its child.
  final double? height;

  /// The border radius for the rounded corners.
  ///
  /// Defaults to 30, which matches the standard iOS rounded rectangle style.
  final double borderRadius;

  /// The child widget to display inside the glass container.
  ///
  /// If null, an empty [SizedBox] will be used.
  final Widget? child;

  /// Creates a [GlassWidget].
  ///
  /// The [borderRadius] defaults to 30 for iOS-style rounded corners.
  const GlassWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 30,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Apply platform-specific blur multiplier for performance
    final blurSigma = 20.0 * PlatformConfig.blurMultiplier;
    final isBlurEnabled = PlatformConfig.isBlurEnabled && blurSigma > 0;

    // Fallback for web (no blur)
    if (!isBlurEnabled) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color:
                Colors.grey.withValues(alpha: PlatformConfig.fallbackOpacity),
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
        ),
      );
    }

    Widget glassWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: CustomPaint(
          foregroundPainter: GradientBorderPainter(
            borderRadius: borderRadius,
            width: 1.5,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.6), // Top-Left: Bright
                Colors.white.withValues(alpha: 0.1), // Center: Dim
                Colors.white.withValues(alpha: 0.6), // Bottom-Right: Bright
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.5), // Stronger highlight
                  Colors.white.withValues(alpha: 0.05), // Faded bottom
                ],
              ),
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
          ),
        ),
      ),
    );

    // Wrap in RepaintBoundary for performance optimization on Android
    if (PlatformConfig.usePerformanceOptimizations) {
      return RepaintBoundary(child: glassWidget);
    }

    return glassWidget;
  }
}
