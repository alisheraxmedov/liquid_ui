import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// State of geometry cache for liquid glass rendering.
enum GeometryCacheState {
  /// The geometry is up to date and does not need to be updated.
  updated,

  /// The geometry might need to be updated, but could potentially be reused.
  mightNeedUpdate,

  /// The geometry definitely needs to be updated.
  needsUpdate,
}

/// A cache for liquid glass geometry that prevents re-rendering on every frame.
///
/// This is the key optimization that prevents blur from disappearing during scroll.
/// By caching the geometry as a texture, we avoid expensive re-computation
/// during rapid scroll operations.
class LiquidGeometryCache {
  /// Creates a new [LiquidGeometryCache].
  LiquidGeometryCache();

  GeometryCacheState _state = GeometryCacheState.needsUpdate;

  /// The current cache state.
  GeometryCacheState get state => _state;

  ui.Picture? _cachedPicture;
  ui.Image? _cachedImage;
  ui.Rect? _cachedBounds;

  /// The cached image if available.
  ui.Image? get cachedImage => _cachedImage;

  /// The cached bounds.
  ui.Rect? get cachedBounds => _cachedBounds;

  /// Whether the cache has valid content.
  bool get hasValidCache =>
      _state == GeometryCacheState.updated && _cachedImage != null;

  /// Marks the cache as potentially needing update.
  ///
  /// This is less aggressive than [invalidate] - the cache might still be
  /// reusable if only the transform changed but geometry stayed the same.
  void markMightNeedUpdate() {
    if (_state != GeometryCacheState.needsUpdate) {
      _state = GeometryCacheState.mightNeedUpdate;
    }
  }

  /// Completely invalidates the cache, forcing a rebuild.
  void invalidate() {
    _state = GeometryCacheState.needsUpdate;
  }

  /// Updates the cache with new picture data.
  ///
  /// The [picture] is rendered to an image synchronously if possible,
  /// or falls back to no caching on platforms that don't support it.
  void updateCache({
    required ui.Picture picture,
    required ui.Rect bounds,
    required double devicePixelRatio,
  }) {
    // Dispose old resources
    _cachedPicture?.dispose();
    _cachedImage?.dispose();

    _cachedPicture = picture;
    _cachedBounds = bounds;

    // Calculate matte bounds in physical pixels
    final width = (bounds.width * devicePixelRatio).ceil();
    final height = (bounds.height * devicePixelRatio).ceil();

    if (width > 0 && height > 0) {
      try {
        // Try to render synchronously for best performance
        _cachedImage = picture.toImageSync(width, height);
        _state = GeometryCacheState.updated;
      } catch (e) {
        // Fall back to no caching if sync rendering fails
        debugPrint('LiquidGeometryCache: Sync render failed, falling back');
        _state = GeometryCacheState.needsUpdate;
      }
    }
  }

  /// Checks if the cache can be reused for the given bounds.
  ///
  /// Returns true if the cache is still valid and can be reused.
  bool canReuse(ui.Rect newBounds) {
    if (_state == GeometryCacheState.needsUpdate) return false;
    if (_cachedImage == null) return false;
    if (_cachedBounds == null) return false;

    // Cache can be reused if bounds haven't changed significantly
    return _cachedBounds!.width == newBounds.width &&
        _cachedBounds!.height == newBounds.height;
  }

  /// Disposes all cached resources.
  void dispose() {
    _cachedPicture?.dispose();
    _cachedImage?.dispose();
    _cachedPicture = null;
    _cachedImage = null;
    _cachedBounds = null;
  }
}
