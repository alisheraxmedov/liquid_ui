import 'package:flutter/material.dart';

/// A controller that manages blur intensity based on scroll position.
///
/// This controller is used by [LiquidNavigationBar] to create
/// scroll-aware dynamic blur effects.
///
/// Example:
/// ```dart
/// final scrollController = ScrollController();
/// final blurController = ScrollBlurController(scrollController);
///
/// // Get current blur value
/// double blur = blurController.getBlurForOffset(100);
/// ```
class ScrollBlurController extends ChangeNotifier {
  /// The scroll controller to monitor.
  final ScrollController scrollController;

  /// The minimum blur sigma value.
  final double minBlur;

  /// The maximum blur sigma value.
  final double maxBlur;

  /// The scroll offset at which max blur is reached.
  final double maxScrollOffset;

  /// Creates a [ScrollBlurController].
  ScrollBlurController({
    required this.scrollController,
    this.minBlur = 0.0,
    this.maxBlur = 20.0,
    this.maxScrollOffset = 100.0,
  }) {
    scrollController.addListener(_onScroll);
  }

  double _currentBlur = 0.0;

  /// The current blur value based on scroll position.
  double get currentBlur => _currentBlur;

  void _onScroll() {
    final offset = scrollController.offset;
    _currentBlur = getBlurForOffset(offset);
    notifyListeners();
  }

  /// Calculate blur value for a given scroll offset.
  double getBlurForOffset(double offset) {
    if (offset <= 0) return minBlur;
    if (offset >= maxScrollOffset) return maxBlur;

    // Linear interpolation
    final progress = offset / maxScrollOffset;
    return minBlur + (maxBlur - minBlur) * progress;
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
