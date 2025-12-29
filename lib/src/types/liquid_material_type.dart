// No imports needed for this file

/// Defines the material thickness types for liquid glass effects.
///
/// Each type corresponds to different blur intensity and opacity levels,
/// matching Apple's iOS liquid material system.
///
/// Example:
/// ```dart
/// LiquidMaterial(
///   type: LiquidMaterialType.regular,
///   child: YourWidget(),
/// )
/// ```
enum LiquidMaterialType {
  /// Ultra thin material with minimal blur.
  /// sigmaX/Y: 10, opacity: 0.02
  ultraThin,

  /// Thin material with light blur.
  /// sigmaX/Y: 15, opacity: 0.04
  thin,

  /// Regular material with standard blur (default).
  /// sigmaX/Y: 20, opacity: 0.06
  regular,

  /// Thick material with heavy blur.
  /// sigmaX/Y: 30, opacity: 0.08
  thick,
}

/// Extension to get blur and opacity values for each material type.
extension LiquidMaterialTypeExtension on LiquidMaterialType {
  /// Returns the blur sigma value for this material type.
  double get blurSigma {
    switch (this) {
      case LiquidMaterialType.ultraThin:
        return 10.0;
      case LiquidMaterialType.thin:
        return 15.0;
      case LiquidMaterialType.regular:
        return 20.0;
      case LiquidMaterialType.thick:
        return 30.0;
    }
  }

  /// Returns the background opacity for this material type.
  double get backgroundOpacity {
    switch (this) {
      case LiquidMaterialType.ultraThin:
        return 0.02;
      case LiquidMaterialType.thin:
        return 0.04;
      case LiquidMaterialType.regular:
        return 0.06;
      case LiquidMaterialType.thick:
        return 0.08;
    }
  }

  /// Returns the border opacity for this material type.
  double get borderOpacity {
    switch (this) {
      case LiquidMaterialType.ultraThin:
        return 0.3;
      case LiquidMaterialType.thin:
        return 0.4;
      case LiquidMaterialType.regular:
        return 0.5;
      case LiquidMaterialType.thick:
        return 0.6;
    }
  }
}
