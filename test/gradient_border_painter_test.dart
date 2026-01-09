import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_widgets/liquid_widgets.dart';

void main() {
  group('GradientBorderPainter', () {
    test('creates correctly with required parameters', () {
      final painter = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      expect(painter.borderRadius, 20);
      expect(painter.width, 1.5);
      expect(painter.gradient, isNotNull);
    });

    test('shouldRepaint returns true when borderRadius changes', () {
      final painter1 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      final painter2 = GradientBorderPainter(
        borderRadius: 30,
        width: 1.5,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns true when width changes', () {
      final painter1 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      final painter2 = GradientBorderPainter(
        borderRadius: 20,
        width: 2.0,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns true when gradient changes', () {
      final painter1 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
        ),
      );

      final painter2 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: const LinearGradient(colors: [Colors.blue, Colors.red]),
      );

      expect(painter1.shouldRepaint(painter2), true);
    });

    test('shouldRepaint returns false when all values are same', () {
      const gradient = LinearGradient(
        colors: [Colors.white, Colors.transparent],
      );

      final painter1 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: gradient,
      );

      final painter2 = GradientBorderPainter(
        borderRadius: 20,
        width: 1.5,
        gradient: gradient,
      );

      expect(painter1.shouldRepaint(painter2), false);
    });
  });
}
