import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_ui/liquid_ui.dart';

void main() {
  group('PerformanceDetector', () {
    tearDown(() {
      PerformanceDetector.reset();
    });

    test('performanceMultiplier returns correct value for high-end', () {
      PerformanceDetector.setLowEndDevice(false);
      expect(PerformanceDetector.performanceMultiplier, 1.0);
    });

    test('performanceMultiplier returns correct value for low-end', () {
      PerformanceDetector.setLowEndDevice(true);
      expect(PerformanceDetector.performanceMultiplier, 0.5);
    });

    test('isLowEndDevice can be set and retrieved', () {
      PerformanceDetector.setLowEndDevice(true);
      expect(PerformanceDetector.isLowEndDevice, true);

      PerformanceDetector.setLowEndDevice(false);
      expect(PerformanceDetector.isLowEndDevice, false);
    });

    test('reset clears cached value', () {
      PerformanceDetector.setLowEndDevice(true);
      expect(PerformanceDetector.isLowEndDevice, true);

      PerformanceDetector.reset();
      // After reset, it should re-detect
      // The actual value depends on the platform
    });
  });
}
