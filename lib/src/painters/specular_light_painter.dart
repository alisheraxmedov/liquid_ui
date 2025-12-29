import 'package:flutter/material.dart';

/// A custom painter that draws a specular light gradient effect.
///
/// This creates the iOS-style top-to-bottom light reflection effect
/// that appears on liquid glass materials.
///
/// Example:
/// ```dart
/// CustomPaint(
///   painter: SpecularLightPainter(
///     borderRadius: 20,
///     intensity: 0.3,
///   ),
///   child: YourWidget(),
/// )
/// ```
class SpecularLightPainter extends CustomPainter {
  /// The radius of the rounded corners.
  final double borderRadius;

  /// The intensity of the light effect (0.0 - 1.0).
  final double intensity;

  /// Creates a [SpecularLightPainter].
  SpecularLightPainter({required this.borderRadius, this.intensity = 0.3});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Create top-to-bottom specular light gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white.withValues(alpha: intensity * 0.4),
        Colors.white.withValues(alpha: intensity * 0.1),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.3, 0.6],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant SpecularLightPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.intensity != intensity;
  }
}
