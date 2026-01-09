import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../types/liquid_material_type.dart';
import '../utils/platform_config.dart';
import '../painters/gradient_border_painter.dart';
import '../painters/specular_light_painter.dart';
import 'shader_manager.dart';

/// A liquid glass widget that uses Fragment Shaders for rendering.
///
/// This widget provides scroll-safe liquid glass effects by using
/// GPU shaders instead of BackdropFilter. It automatically falls back
/// to BackdropFilter on unsupported platforms.
///
/// Use this for the best liquid glass experience on iOS and Android.
class ShaderLiquidGlass extends StatefulWidget {
  /// The material thickness type.
  final LiquidMaterialType type;

  /// Whether to use colorless guarantee mode.
  final bool colorless;

  /// Whether to show specular light effect.
  final bool specularLight;

  /// The border radius for rounded corners.
  final double borderRadius;

  /// The width of the widget.
  final double? width;

  /// The height of the widget.
  final double? height;

  /// The child widget to display inside.
  final Widget? child;

  /// Creates a [ShaderLiquidGlass] widget.
  const ShaderLiquidGlass({
    super.key,
    this.type = LiquidMaterialType.regular,
    this.colorless = true,
    this.specularLight = true,
    this.borderRadius = 20,
    this.width,
    this.height,
    this.child,
  });

  @override
  State<ShaderLiquidGlass> createState() => _ShaderLiquidGlassState();
}

class _ShaderLiquidGlassState extends State<ShaderLiquidGlass> {
  @override
  Widget build(BuildContext context) {
    final blurSigma = widget.type.blurSigma * PlatformConfig.blurMultiplier;
    final isBlurEnabled = PlatformConfig.isBlurEnabled && blurSigma > 0;

    // Check if shaders are supported
    if (!LiquidShaderManager.isSupported || !isBlurEnabled) {
      return _buildFallback(blurSigma, isBlurEnabled);
    }

    // Use shader-based rendering
    return ShaderBuilder(
      assetKey: LiquidShaderManager.shaderPath,
      fallback: _buildFallback(blurSigma, isBlurEnabled),
      builder: (context, shader, child) {
        return _ShaderLiquidGlassRenderWidget(
          shader: shader,
          type: widget.type,
          colorless: widget.colorless,
          specularLight: widget.specularLight,
          borderRadius: widget.borderRadius,
          blurSigma: blurSigma,
          width: widget.width,
          height: widget.height,
          child: widget.child,
        );
      },
    );
  }

  /// Fallback to BackdropFilter-based rendering.
  Widget _buildFallback(double blurSigma, bool isBlurEnabled) {
    final opacityMultiplier = _getOpacityMultiplier();

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08 * opacityMultiplier),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: isBlurEnabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.5 * opacityMultiplier),
                  Colors.white.withValues(alpha: 0.05 * opacityMultiplier),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: widget.child ?? const SizedBox(),
    );

    // Add specular light
    if (widget.specularLight && isBlurEnabled) {
      content = CustomPaint(
        foregroundPainter: SpecularLightPainter(
          borderRadius: widget.borderRadius,
          intensity: 0.2 * opacityMultiplier,
        ),
        child: content,
      );
    }

    // Add gradient border
    content = CustomPaint(
      foregroundPainter: GradientBorderPainter(
        borderRadius: widget.borderRadius,
        width: 1.5,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.6 * opacityMultiplier),
            Colors.white.withValues(alpha: 0.1 * opacityMultiplier),
            Colors.white.withValues(alpha: 0.6 * opacityMultiplier),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: content,
    );

    // Apply blur with TileMode.mirror
    if (isBlurEnabled) {
      return RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: blurSigma,
              sigmaY: blurSigma,
              tileMode: TileMode.mirror,
            ),
            child: content,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: content,
    );
  }

  double _getOpacityMultiplier() {
    if (!widget.colorless) return 1.2;
    switch (widget.type) {
      case LiquidMaterialType.ultraThin:
        return 0.6;
      case LiquidMaterialType.thin:
        return 0.8;
      case LiquidMaterialType.regular:
        return 1.0;
      case LiquidMaterialType.thick:
        return 1.3;
    }
  }
}

/// Internal widget that uses RenderObject for shader rendering.
class _ShaderLiquidGlassRenderWidget extends SingleChildRenderObjectWidget {
  final ui.FragmentShader shader;
  final LiquidMaterialType type;
  final bool colorless;
  final bool specularLight;
  final double borderRadius;
  final double blurSigma;
  final double? width;
  final double? height;

  const _ShaderLiquidGlassRenderWidget({
    required this.shader,
    required this.type,
    required this.colorless,
    required this.specularLight,
    required this.borderRadius,
    required this.blurSigma,
    this.width,
    this.height,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderShaderLiquidGlass(
      shader: shader,
      type: type,
      colorless: colorless,
      specularLight: specularLight,
      borderRadius: borderRadius,
      blurSigma: blurSigma,
      devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderShaderLiquidGlass renderObject,
  ) {
    renderObject
      ..shader = shader
      ..type = type
      ..colorless = colorless
      ..specularLight = specularLight
      ..borderRadius = borderRadius
      ..blurSigma = blurSigma
      ..devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
  }
}

/// Custom RenderObject for shader-based liquid glass rendering.
class RenderShaderLiquidGlass extends RenderProxyBox {
  RenderShaderLiquidGlass({
    required ui.FragmentShader shader,
    required LiquidMaterialType type,
    required bool colorless,
    required bool specularLight,
    required double borderRadius,
    required double blurSigma,
    required double devicePixelRatio,
  })  : _shader = shader,
        _type = type,
        _colorless = colorless,
        _specularLight = specularLight,
        _borderRadius = borderRadius,
        _blurSigma = blurSigma,
        _devicePixelRatio = devicePixelRatio;

  ui.FragmentShader _shader;
  LiquidMaterialType _type;
  bool _colorless;
  bool _specularLight;
  double _borderRadius;
  double _blurSigma;
  double _devicePixelRatio;

  final LayerHandle<BackdropFilterLayer> _blurLayerHandle =
      LayerHandle<BackdropFilterLayer>();
  final LayerHandle<ShaderMaskLayer> _shaderLayerHandle =
      LayerHandle<ShaderMaskLayer>();

  set shader(ui.FragmentShader value) {
    if (_shader == value) return;
    _shader = value;
    markNeedsPaint();
  }

  set type(LiquidMaterialType value) {
    if (_type == value) return;
    _type = value;
    markNeedsPaint();
  }

  set colorless(bool value) {
    if (_colorless == value) return;
    _colorless = value;
    markNeedsPaint();
  }

  set specularLight(bool value) {
    if (_specularLight == value) return;
    _specularLight = value;
    markNeedsPaint();
  }

  set borderRadius(double value) {
    if (_borderRadius == value) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  set blurSigma(double value) {
    if (_blurSigma == value) return;
    _blurSigma = value;
    markNeedsPaint();
  }

  set devicePixelRatio(double value) {
    if (_devicePixelRatio == value) return;
    _devicePixelRatio = value;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || size.isEmpty) {
      super.paint(context, offset);
      return;
    }

    // Configure shader uniforms
    _shader.setFloat(0, size.width); // uSize.x
    _shader.setFloat(1, size.height); // uSize.y
    _shader.setFloat(2, _blurSigma); // uBlurSigma
    _shader.setFloat(3, _type.blurSigma / 2); // uThickness

    // Glass color (white with low opacity for colorless)
    final glassColor = _colorless
        ? const Color.fromRGBO(255, 255, 255, 0.1)
        : const Color.fromRGBO(255, 255, 255, 0.2);
    _shader.setFloat(4, glassColor.r / 255.0);
    _shader.setFloat(5, glassColor.g / 255.0);
    _shader.setFloat(6, glassColor.b / 255.0);
    _shader.setFloat(7, glassColor.a);

    _shader.setFloat(8, _borderRadius); // uBorderRadius
    _shader.setFloat(9, _specularLight ? 0.3 : 0.0); // uLightIntensity
    _shader.setFloat(10, 1.0); // uOpacity

    // First, apply blur layer
    final blurLayer = (_blurLayerHandle.layer ??= BackdropFilterLayer())
      ..filter = ui.ImageFilter.blur(
        sigmaX: _blurSigma,
        sigmaY: _blurSigma,
        tileMode: TileMode.mirror,
      );

    // Push blur layer
    context.pushLayer(
      blurLayer,
      (context, offset) {
        // Apply shader filter
        final shaderFilter = ui.ImageFilter.shader(_shader);

        final shaderLayer = BackdropFilterLayer()
          ..filter = shaderFilter
          ..blendMode = BlendMode.srcOver;

        context.pushLayer(
          shaderLayer,
          (context, offset) {
            // Paint child content
            super.paint(context, offset);
          },
          offset,
        );
      },
      offset,
    );
  }

  @override
  void dispose() {
    _blurLayerHandle.layer = null;
    _shaderLayerHandle.layer = null;
    super.dispose();
  }
}
