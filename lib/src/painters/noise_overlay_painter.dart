import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painter that draws a subtle noise overlay texture.
///
/// This creates the iOS-style micro glass texture effect for
/// added authenticity to liquid glass materials.
///
/// Example:
/// ```dart
/// CustomPaint(
///   painter: NoiseOverlayPainter(
///     opacity: 0.03,
///     borderRadius: 20,
///   ),
///   child: YourWidget(),
/// )
/// ```
class NoiseOverlayPainter extends CustomPainter {
  /// The opacity of the noise effect (0.0 - 1.0).
  final double opacity;

  /// The radius of the rounded corners.
  final double borderRadius;

  /// Random seed for noise generation.
  final int seed;

  /// Creates a [NoiseOverlayPainter].
  NoiseOverlayPainter({
    this.opacity = 0.03,
    required this.borderRadius,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Clip to rounded rectangle
    canvas.save();
    canvas.clipRRect(rrect);

    // Generate noise pattern
    final random = math.Random(seed);
    final paint = Paint();
    
    // Draw sparse noise dots for texture effect
    final dotCount = (size.width * size.height / 100).toInt();
    for (int i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = random.nextDouble() * opacity;
      
      paint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant NoiseOverlayPainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.seed != seed;
  }
}
