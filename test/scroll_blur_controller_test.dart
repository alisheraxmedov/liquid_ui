import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_ui/liquid_ui.dart';

void main() {
  group('ScrollBlurController', () {
    test('initial blur is minBlur', () {
      final scrollController = ScrollController();
      final blurController = ScrollBlurController(
        scrollController: scrollController,
        minBlur: 5.0,
        maxBlur: 25.0,
      );

      expect(blurController.currentBlur, 0.0);
      blurController.dispose();
    });

    test('getBlurForOffset returns minBlur for offset 0', () {
      final scrollController = ScrollController();
      final blurController = ScrollBlurController(
        scrollController: scrollController,
        minBlur: 5.0,
        maxBlur: 25.0,
      );

      expect(blurController.getBlurForOffset(0), 5.0);
      blurController.dispose();
    });

    test('getBlurForOffset returns maxBlur for offset >= threshold', () {
      final scrollController = ScrollController();
      final blurController = ScrollBlurController(
        scrollController: scrollController,
        minBlur: 5.0,
        maxBlur: 25.0,
        maxScrollOffset: 100.0,
      );

      expect(blurController.getBlurForOffset(100), 25.0);
      expect(blurController.getBlurForOffset(150), 25.0);
      blurController.dispose();
    });

    test('getBlurForOffset interpolates for middle offset', () {
      final scrollController = ScrollController();
      final blurController = ScrollBlurController(
        scrollController: scrollController,
        minBlur: 0.0,
        maxBlur: 20.0,
        maxScrollOffset: 100.0,
      );

      // At 50% scroll, blur should be 50% of max
      expect(blurController.getBlurForOffset(50), 10.0);
      blurController.dispose();
    });

    test('getBlurForOffset returns minBlur for negative offset', () {
      final scrollController = ScrollController();
      final blurController = ScrollBlurController(
        scrollController: scrollController,
        minBlur: 5.0,
        maxBlur: 25.0,
      );

      expect(blurController.getBlurForOffset(-10), 5.0);
      blurController.dispose();
    });
  });
}
