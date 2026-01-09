/// Liquid Widgets - A Flutter package for iOS-style liquid glass UI widgets.
///
/// This package provides true Apple-style liquid material effects with:
/// - Material types (ultraThin, thin, regular, thick)
/// - Colorless guarantee mode
/// - Specular light gradients
/// - Scroll-aware dynamic blur
/// - Platform-optimized performance
///
/// ## Quick Start
///
/// ```dart
/// import 'package:liquid_widgets/liquid_widgets.dart';
///
/// LiquidMaterial(
///   type: LiquidMaterialType.regular,
///   child: Text('Hello Liquid Widgets'),
/// )
/// ```
///
/// ## Legacy Widget
///
/// For backwards compatibility, [GlassWidget] is still available:
///
/// ```dart
/// GlassWidget(
///   width: 200,
///   height: 100,
///   child: YourContent(),
/// )
/// ```
library;

// Types
export 'src/types/liquid_material_type.dart';

// Widgets
export 'src/widgets/glass_widget.dart';
export 'src/widgets/liquid_material.dart';
export 'src/widgets/liquid_navigation_bar.dart';

// Painters
export 'src/painters/gradient_border_painter.dart';
export 'src/painters/specular_light_painter.dart';
export 'src/painters/noise_overlay_painter.dart';

// Controllers
export 'src/controllers/scroll_blur_controller.dart';
export 'src/controllers/motion_parallax_controller.dart';

// Utils
export 'src/utils/platform_config.dart';
export 'src/utils/performance_detector.dart';
