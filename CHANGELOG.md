# Changelog

## 1.0.2 - 2026-01-09

### Fixed
- Added `TileMode.mirror` to BackdropFilter for scroll-safe blur on Android
- Added `BouncingScrollPhysics` tip for better scroll performance
- Updated platform support: full blur quality on all native platforms

### Changed
- Removed experimental shader rendering code
- Simplified codebase for better maintainability
- Updated README with Android scroll tip

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-12-29

### Added

- **LiquidMaterial** - Main widget for iOS-style liquid glass effects
  - Material types: `ultraThin`, `thin`, `regular`, `thick`
  - Colorless guarantee mode
  - Specular light gradient
  - Noise overlay option
  - Platform-adaptive performance

- **LiquidNavigationBar** - Scroll-aware navigation bar with dynamic blur
  - Blur intensity changes with scroll position
  - Customizable min/max blur values
  - Scroll threshold configuration

- **GlassWidget** - Legacy widget for simple glass effects
  - Backdrop blur filter
  - Gradient border
  - Inner gradient highlight
  - Shadow effects

- **Utility Classes**
  - `LiquidMaterialType` enum for material thickness
  - `GradientBorderPainter` for custom gradient borders
  - `SpecularLightPainter` for light reflection effects
  - `NoiseOverlayPainter` for glass texture
  - `ScrollBlurController` for scroll-based blur
  - `MotionParallaxController` for gyroscope effects
  - `PlatformConfig` for platform-specific settings
  - `PerformanceDetector` for device performance detection

### Platform Support

- iOS: Full blur quality
- Android: Full blur quality (use BouncingScrollPhysics)
- Web: Fallback mode (no blur)
