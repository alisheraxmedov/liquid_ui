# Liquid UI

[![pub package](https://img.shields.io/pub/v/liquid_ui.svg)](https://pub.dev/packages/liquid_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter package for creating iOS-style liquid glass UI widgets with blur effects, gradient borders, and subtle shadows.

## Features

### Core Features

- **True iOS Liquid Material** — Apple's liquid material design with pure blur and light effects
- **Material Types** — Four thickness levels: `ultraThin`, `thin`, `regular`, `thick`
- **Colorless Guarantee Mode** — Background colors remain untinted
- **Specular Light Gradient** — Top-to-bottom light reflection effect

### Advanced Features

- **Scroll-aware Dynamic Blur** — Blur intensity changes based on scroll position
- **Motion Parallax** — Gyroscope-based light movement (optional)
- **Adaptive Performance** — Automatic blur reduction on low-end devices
- **Noise Overlay** — Subtle glass texture for authenticity

### Platform Support

| Platform | Blur Quality | Notes |
|----------|--------------|-------|
| iOS | Full | Best visual quality |
| Android | Optimized | Reduced blur for performance |
| Linux | Full | Desktop quality |
| Web | Fallback | Solid background, no blur |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_ui: ^0.0.1
```

Run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:liquid_ui/liquid_ui.dart';

LiquidMaterial(
  type: LiquidMaterialType.regular,
  width: 200,
  height: 100,
  child: Center(
    child: Text('Hello'),
  ),
)
```

### Material Types

```dart
// Ultra thin material - minimal blur (sigma: 10)
LiquidMaterial(type: LiquidMaterialType.ultraThin, ...)

// Thin material - light blur (sigma: 15)
LiquidMaterial(type: LiquidMaterialType.thin, ...)

// Regular material - standard blur (sigma: 20, default)
LiquidMaterial(type: LiquidMaterialType.regular, ...)

// Thick material - heavy blur (sigma: 30)
LiquidMaterial(type: LiquidMaterialType.thick, ...)
```

### Scroll-aware Navigation Bar

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: _scrollController,
          children: [...],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: LiquidNavigationBar(
            scrollController: _scrollController,
            height: 56,
            blurOnScroll: true,
            child: Text('Title'),
          ),
        ),
      ],
    );
  }
}
```

### All Configuration Options

```dart
LiquidMaterial(
  type: LiquidMaterialType.regular,  // Material thickness
  colorless: true,                    // No background tinting
  specularLight: true,                // Light gradient effect
  noiseOverlay: false,                // Glass texture
  borderRadius: 20,                   // Corner radius
  width: 200,                         // Widget width
  height: 100,                        // Widget height
  child: YourWidget(),
)
```

### Legacy GlassWidget

For simple use cases, the legacy `GlassWidget` is still available:

```dart
GlassWidget(
  width: 200,
  height: 100,
  borderRadius: 30,
  child: YourWidget(),
)
```

## API Reference

### LiquidMaterial

The main widget for creating liquid glass effects.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `type` | `LiquidMaterialType` | `regular` | Material thickness type |
| `colorless` | `bool` | `true` | Enable colorless guarantee mode |
| `specularLight` | `bool` | `true` | Show light gradient effect |
| `noiseOverlay` | `bool` | `false` | Show glass texture overlay |
| `borderRadius` | `double` | `20` | Corner radius |
| `width` | `double?` | `null` | Widget width |
| `height` | `double?` | `null` | Widget height |
| `child` | `Widget?` | `null` | Child widget |

### LiquidMaterialType

| Type | Blur Sigma | Background Opacity |
|------|------------|-------------------|
| `ultraThin` | 10 | 0.02 |
| `thin` | 15 | 0.04 |
| `regular` | 20 | 0.06 |
| `thick` | 30 | 0.08 |

### LiquidNavigationBar

A navigation bar with scroll-aware blur.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `scrollController` | `ScrollController` | required | Scroll controller to monitor |
| `height` | `double` | `56` | Bar height |
| `type` | `LiquidMaterialType` | `regular` | Material type |
| `blurOnScroll` | `bool` | `true` | Enable dynamic blur |
| `minBlur` | `double` | `5.0` | Minimum blur sigma |
| `maxBlur` | `double` | `25.0` | Maximum blur sigma |
| `scrollThreshold` | `double` | `100.0` | Scroll offset for max blur |
| `child` | `Widget?` | `null` | Child widget |

### GlassWidget

Legacy widget for simple glass effects.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `width` | `double?` | `null` | Widget width |
| `height` | `double?` | `null` | Widget height |
| `borderRadius` | `double` | `30` | Corner radius |
| `child` | `Widget?` | `null` | Child widget |

## Requirements

- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.5.0`

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

