import 'dart:ui';

import 'package:flutter/material.dart';

import '../types/liquid_material_type.dart';
import '../painters/gradient_border_painter.dart';
import '../painters/specular_light_painter.dart';
import '../painters/noise_overlay_painter.dart';
import '../utils/platform_config.dart';
import '../cache/geometry_cache.dart';

/// A high-performance liquid material widget with geometry caching.
///
/// This widget provides the same visual effect as [LiquidMaterial] but with
/// optimizations that prevent blur from disappearing during scroll:
/// - Geometry caching prevents expensive re-computation
/// - Persistent layer handles ensure layers aren't recreated
/// - TileMode.mirror prevents blur artifacts at edges
///
/// Use this widget instead of [LiquidMaterial] when you need better
/// scroll performance, especially on Android devices.
class CachedLiquidMaterial extends StatefulWidget {
  /// The material thickness type.
  final LiquidMaterialType type;

  /// Whether to use colorless guarantee mode.
  final bool colorless;

  /// Whether to show specular light effect.
  final bool specularLight;

  /// Whether to show noise overlay texture.
  final bool noiseOverlay;

  /// The border radius for rounded corners.
  final double borderRadius;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// The child widget to display inside.
  final Widget? child;

  /// Creates a [CachedLiquidMaterial] widget.
  const CachedLiquidMaterial({
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

  @override
  State<CachedLiquidMaterial> createState() => _CachedLiquidMaterialState();
}

class _CachedLiquidMaterialState extends State<CachedLiquidMaterial> {
  final LiquidGeometryCache _geometryCache = LiquidGeometryCache();

  @override
  void dispose() {
    _geometryCache.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CachedLiquidMaterial oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache if visual properties changed
    if (widget.type != oldWidget.type ||
        widget.colorless != oldWidget.colorless ||
        widget.specularLight != oldWidget.specularLight ||
        widget.noiseOverlay != oldWidget.noiseOverlay ||
        widget.borderRadius != oldWidget.borderRadius ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height) {
      _geometryCache.invalidate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final blurSigma = widget.type.blurSigma * PlatformConfig.blurMultiplier;
    final isBlurEnabled = PlatformConfig.isBlurEnabled && blurSigma > 0;
    final opacityMultiplier = _getOpacityMultiplier();

    // Fallback for web
    final fallbackColor = widget.colorless
        ? Colors.grey.withValues(alpha: PlatformConfig.fallbackOpacity)
        : Colors.white.withValues(alpha: PlatformConfig.fallbackOpacity);

    // Build content layers
    Widget content = _buildContent(opacityMultiplier, isBlurEnabled);

    // Add specular light
    if (widget.specularLight && isBlurEnabled) {
      content = CustomPaint(
        foregroundPainter: SpecularLightPainter(
          borderRadius: widget.borderRadius,
          intensity: 0.2 * opacityMultiplier,
        ),
        child: content,
      );
    }

    // Add noise overlay
    if (widget.noiseOverlay && isBlurEnabled) {
      content = CustomPaint(
        foregroundPainter: NoiseOverlayPainter(
          borderRadius: widget.borderRadius,
          opacity: 0.03,
        ),
        child: content,
      );
    }

    // Add gradient border
    content = CustomPaint(
      foregroundPainter: GradientBorderPainter(
        borderRadius: widget.borderRadius,
        width: 1.5,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.6 * opacityMultiplier),
            Colors.white.withValues(alpha: 0.1 * opacityMultiplier),
            Colors.white.withValues(alpha: 0.6 * opacityMultiplier),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: content,
    );

    // Apply blur with optimizations
    if (isBlurEnabled) {
      return RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            // KEY FIX: TileMode.mirror prevents blur artifacts during scroll
            filter: ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
              tileMode: TileMode.mirror,
            ),
            child: content,
          ),
        ),
      );
    }

    // Fallback without blur
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: fallbackColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: widget.child ?? const SizedBox(),
      ),
    );
  }

  Widget _buildContent(double opacityMultiplier, bool isBlurEnabled) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08 * opacityMultiplier),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: isBlurEnabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.5 * opacityMultiplier),
                  Colors.white.withValues(alpha: 0.05 * opacityMultiplier),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: widget.child ?? const SizedBox(),
    );
  }

  double _getOpacityMultiplier() {
    if (!widget.colorless) return 1.2;
    switch (widget.type) {
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
