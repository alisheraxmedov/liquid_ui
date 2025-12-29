import 'package:flutter/material.dart';

/// A custom painter that draws a gradient border around a rounded rectangle.
///
/// This painter is used internally by [GlassWidget] to create the
/// characteristic liquid glass border effect.
///
/// Example:
/// ```dart
/// CustomPaint(
///   painter: GradientBorderPainter(
///     borderRadius: 20,
///     width: 1.5,
///     gradient: LinearGradient(
///       colors: [Colors.white, Colors.transparent],
///     ),
///   ),
///   child: YourWidget(),
/// )
/// ```
class GradientBorderPainter extends CustomPainter {
  /// The radius of the rounded corners.
  final double borderRadius;

  /// The width of the border stroke.
  final double width;

  /// The gradient used to paint the border.
  final Gradient gradient;

  /// Creates a [GradientBorderPainter].
  ///
  /// The [borderRadius], [width], and [gradient] parameters are required.
  GradientBorderPainter({
    required this.borderRadius,
    required this.width,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Inset the rect by half the stroke width so the border stays inside the bounds
    final rect = Rect.fromLTWH(
      width / 2,
      width / 2,
      size.width - width,
      size.height - width,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = gradient.createShader(Offset.zero & size);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.width != width ||
        oldDelegate.gradient != gradient;
  }
}
