import 'dart:async';
import 'package:flutter/foundation.dart';

/// A controller that provides motion parallax data from device sensors.
///
/// This controller uses gyroscope data to create subtle light
/// movement effects on liquid materials.
///
/// Note: This is a simplified version. For full gyroscope support,
/// add `sensors_plus` package to your dependencies.
///
/// Example:
/// ```dart
/// final controller = MotionParallaxController();
/// controller.addListener(() {
///   print('X: ${controller.offsetX}, Y: ${controller.offsetY}');
/// });
/// controller.start();
/// ```
class MotionParallaxController extends ChangeNotifier {
  /// The maximum offset range for parallax effect.
  final double maxOffset;

  /// The damping factor for smooth motion.
  final double damping;

  double _offsetX = 0.0;
  double _offsetY = 0.0;
  Timer? _simulationTimer;

  /// Creates a [MotionParallaxController].
  MotionParallaxController({this.maxOffset = 10.0, this.damping = 0.1});

  /// The current X offset for parallax effect.
  double get offsetX => _offsetX;

  /// The current Y offset for parallax effect.
  double get offsetY => _offsetY;

  /// Start listening to motion events.
  ///
  /// Note: In a real implementation, this would use `sensors_plus`
  /// package to get gyroscope data.
  void start() {
    // Placeholder: In production, use sensors_plus package
    // gyroscopeEvents.listen((event) {
    //   _offsetX = (event.x * maxOffset).clamp(-maxOffset, maxOffset);
    //   _offsetY = (event.y * maxOffset).clamp(-maxOffset, maxOffset);
    //   notifyListeners();
    // });

    // For now, we'll just keep offsets at 0
    _offsetX = 0.0;
    _offsetY = 0.0;
  }

  /// Stop listening to motion events.
  void stop() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  /// Reset offsets to zero.
  void reset() {
    _offsetX = 0.0;
    _offsetY = 0.0;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
