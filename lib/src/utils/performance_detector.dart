import 'package:flutter/foundation.dart';

/// Utility class for detecting device performance level.
///
/// Used to automatically adjust blur quality based on device capabilities.
///
/// Example:
/// ```dart
/// if (PerformanceDetector.isLowEndDevice) {
///   // Use reduced blur
/// }
/// ```
class PerformanceDetector {
  PerformanceDetector._();

  static bool? _isLowEndDevice;

  /// Whether the current device is considered low-end.
  ///
  /// Low-end devices get reduced blur effects for better performance.
  static bool get isLowEndDevice {
    _isLowEndDevice ??= _detectLowEndDevice();
    return _isLowEndDevice!;
  }

  /// The performance multiplier for blur effects.
  ///
  /// Returns 1.0 for high-end devices, 0.5 for low-end devices.
  static double get performanceMultiplier {
    return isLowEndDevice ? 0.5 : 1.0;
  }

  static bool _detectLowEndDevice() {
    // On web, always consider as potentially low-end
    if (kIsWeb) return true;

    // For native platforms, we assume high-end by default
    // In a real implementation, you could check:
    // - RAM size
    // - CPU cores
    // - Device model
    // - GPU capabilities
    return false;
  }

  /// Force set the low-end device flag (for testing).
  static void setLowEndDevice(bool value) {
    _isLowEndDevice = value;
  }

  /// Reset the cached performance detection.
  static void reset() {
    _isLowEndDevice = null;
  }
}
