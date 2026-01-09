import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Manages shader loading and caching for liquid glass effects.
///
/// This class provides a centralized way to load and cache shaders,
/// ensuring they're only compiled once per app lifecycle.
class LiquidShaderManager {
  LiquidShaderManager._();

  static final LiquidShaderManager _instance = LiquidShaderManager._();

  /// Singleton instance of the shader manager.
  static LiquidShaderManager get instance => _instance;

  ui.FragmentProgram? _liquidGlassProgram;
  bool _isLoading = false;
  final List<VoidCallback> _loadCallbacks = [];

  /// The shader asset path.
  static const String shaderPath =
      'packages/liquid_ui/lib/src/shaders/liquid_glass.frag';

  /// Whether shaders are supported on this platform.
  ///
  /// Returns true on Impeller-enabled platforms (iOS, Android, macOS).
  static bool get isSupported => ui.ImageFilter.isShaderFilterSupported;

  /// Whether the shader is loaded and ready.
  bool get isLoaded => _liquidGlassProgram != null;

  /// Gets the liquid glass fragment program.
  ///
  /// Returns null if not loaded yet.
  ui.FragmentProgram? get liquidGlassProgram => _liquidGlassProgram;

  /// Preloads the shader asynchronously.
  ///
  /// Call this early in your app lifecycle for best performance.
  Future<void> preload() async {
    if (_liquidGlassProgram != null || _isLoading) return;

    if (!isSupported) {
      debugPrint('LiquidShaderManager: Shaders not supported on this platform');
      return;
    }

    _isLoading = true;

    try {
      _liquidGlassProgram = await ui.FragmentProgram.fromAsset(shaderPath);
      debugPrint('LiquidShaderManager: Shader loaded successfully');

      // Notify all waiting callbacks
      for (final callback in _loadCallbacks) {
        callback();
      }
      _loadCallbacks.clear();
    } catch (e) {
      debugPrint('LiquidShaderManager: Failed to load shader: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Registers a callback to be called when the shader is loaded.
  void onLoaded(VoidCallback callback) {
    if (isLoaded) {
      callback();
    } else {
      _loadCallbacks.add(callback);
      preload(); // Ensure loading starts
    }
  }
}

/// A widget that builds with a loaded shader.
///
/// This widget handles shader loading and provides the shader to its builder.
class ShaderBuilder extends StatefulWidget {
  /// The asset key for the shader.
  final String assetKey;

  /// Builder function called with the loaded shader.
  final Widget Function(
    BuildContext context,
    ui.FragmentShader shader,
    Widget? child,
  ) builder;

  /// Optional child widget passed to the builder.
  final Widget? child;

  /// Fallback widget shown while shader is loading or if not supported.
  final Widget? fallback;

  /// Creates a [ShaderBuilder].
  const ShaderBuilder({
    super.key,
    required this.assetKey,
    required this.builder,
    this.child,
    this.fallback,
  });

  @override
  State<ShaderBuilder> createState() => _ShaderBuilderState();
}

class _ShaderBuilderState extends State<ShaderBuilder> {
  ui.FragmentProgram? _program;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  Future<void> _loadShader() async {
    if (!LiquidShaderManager.isSupported) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final program = await ui.FragmentProgram.fromAsset(widget.assetKey);
      if (mounted) {
        setState(() {
          _program = program;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('ShaderBuilder: Failed to load shader: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _program == null) {
      return widget.fallback ?? widget.child ?? const SizedBox.shrink();
    }

    return widget.builder(context, _program!.fragmentShader(), widget.child);
  }
}
