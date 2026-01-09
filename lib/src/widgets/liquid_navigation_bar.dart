import 'dart:ui';
import 'package:flutter/material.dart';

import '../types/liquid_material_type.dart';
import '../painters/specular_light_painter.dart';
import '../controllers/scroll_blur_controller.dart';
import '../utils/platform_config.dart';

/// A navigation bar widget with scroll-aware dynamic blur.
///
/// The blur intensity increases as the user scrolls, creating
/// a fluid transition effect similar to iOS navigation bars.
///
/// Example:
/// ```dart
/// LiquidNavigationBar(
///   scrollController: _scrollController,
///   height: 56,
///   blurOnScroll: true,
///   child: Text('My Title'),
/// )
/// ```
class LiquidNavigationBar extends StatefulWidget {
  /// The scroll controller to monitor for blur changes.
  final ScrollController scrollController;

  /// The height of the navigation bar.
  final double height;

  /// The material type for the navigation bar.
  final LiquidMaterialType type;

  /// Whether to enable scroll-aware blur.
  final bool blurOnScroll;

  /// The minimum blur when at top (offset = 0).
  final double minBlur;

  /// The maximum blur when scrolled.
  final double maxBlur;

  /// The scroll offset at which max blur is reached.
  final double scrollThreshold;

  /// The child widget to display inside.
  final Widget? child;

  /// Creates a [LiquidNavigationBar].
  const LiquidNavigationBar({
    super.key,
    required this.scrollController,
    this.height = 56,
    this.type = LiquidMaterialType.regular,
    this.blurOnScroll = true,
    this.minBlur = 5.0,
    this.maxBlur = 25.0,
    this.scrollThreshold = 100.0,
    this.child,
  });

  @override
  State<LiquidNavigationBar> createState() => _LiquidNavigationBarState();
}

class _LiquidNavigationBarState extends State<LiquidNavigationBar> {
  late ScrollBlurController _blurController;

  @override
  void initState() {
    super.initState();
    _blurController = ScrollBlurController(
      scrollController: widget.scrollController,
      minBlur: widget.minBlur,
      maxBlur: widget.maxBlur,
      maxScrollOffset: widget.scrollThreshold,
    );
    _blurController.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _blurController.removeListener(_rebuild);
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blurSigma = widget.blurOnScroll
        ? _blurController.currentBlur * PlatformConfig.blurMultiplier
        : widget.type.blurSigma * PlatformConfig.blurMultiplier;

    final isBlurEnabled = PlatformConfig.isBlurEnabled && blurSigma > 0;

    // Calculate opacity based on scroll
    final scrollProgress = widget.blurOnScroll
        ? (_blurController.currentBlur - widget.minBlur) /
            (widget.maxBlur - widget.minBlur)
        : 1.0;
    final backgroundOpacity = 0.02 + (0.06 * scrollProgress);

    Widget content = Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: backgroundOpacity),
      ),
      child: widget.child ?? const SizedBox(),
    );

    // Add specular light
    content = CustomPaint(
      foregroundPainter: SpecularLightPainter(borderRadius: 0, intensity: 0.15),
      child: content,
    );

    // Add bottom border
    content = CustomPaint(
      foregroundPainter: _BottomBorderPainter(
        opacity: 0.2 + (0.3 * scrollProgress),
      ),
      child: content,
    );

    // Apply blur
    if (isBlurEnabled) {
      return ClipRect(
        child: BackdropFilter(
          // TileMode.mirror prevents blur artifacts during scroll
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
            tileMode: TileMode.mirror,
          ),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Painter for bottom border line
class _BottomBorderPainter extends CustomPainter {
  final double opacity;

  _BottomBorderPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 0.5;

    canvas.drawLine(
      Offset(0, size.height - 0.5),
      Offset(size.width, size.height - 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BottomBorderPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}
