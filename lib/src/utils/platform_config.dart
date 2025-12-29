import 'dart:io';
import 'package:flutter/foundation.dart';

/// Platform-specific configuration for blur effects.
///
/// Automatically detects the platform and adjusts blur quality accordingly:
/// - iOS: Full quality blur (sigma multiplier: 1.0)
/// - Linux: Full quality blur (sigma multiplier: 1.0)
/// - macOS: Full quality blur (sigma multiplier: 1.0)
/// - Windows: Full quality blur (sigma multiplier: 1.0)
/// - Android: Reduced blur for performance (sigma multiplier: 0.5)
/// - Web: Fallback mode (blur disabled)
class PlatformConfig {
  PlatformConfig._();

  /// Whether blur effects are enabled on this platform.
  static bool get isBlurEnabled {
    if (kIsWeb) return false;
    return true;
  }

  /// Whether this is a web platform.
  static bool get isWeb => kIsWeb;

  /// Whether this is iOS platform.
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Whether this is Android platform.
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Whether this is Linux platform.
  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }

  /// Whether this is macOS platform.
  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  /// Whether this is Windows platform.
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Whether this is a desktop platform (Linux, macOS, Windows).
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  /// Returns the blur multiplier for the current platform.
  ///
  /// iOS/Desktop: 1.0 (full quality)
  /// Android: 0.5 (reduced for performance - BackdropFilter is expensive)
  /// Web: 0.0 (disabled)
  static double get blurMultiplier {
    if (kIsWeb) return 0.0;
    if (!kIsWeb && Platform.isIOS) return 1.0;
    if (!kIsWeb && Platform.isMacOS) return 1.0;
    if (!kIsWeb && Platform.isLinux) return 1.0;
    if (!kIsWeb && Platform.isWindows) return 1.0;
    if (!kIsWeb && Platform.isAndroid) {
      return 0.5; // Reduced for Android performance
    }
    return 1.0;
  }

  /// Returns the fallback background opacity when blur is disabled.
  static double get fallbackOpacity => 0.85;

  /// Whether to use performance optimizations (RepaintBoundary, etc.)
  static bool get usePerformanceOptimizations {
    if (kIsWeb) return true;
    return Platform.isAndroid; // Enable optimizations on Android
  }
}
