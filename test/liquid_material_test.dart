import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_ui/liquid_ui.dart';

void main() {
  group('LiquidMaterial', () {
    testWidgets('renders with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with ultraThin type', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              type: LiquidMaterialType.ultraThin,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with thin type', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              type: LiquidMaterialType.thin,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with thick type', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              type: LiquidMaterialType.thick,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              width: 200,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders with colorless mode disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              colorless: false,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with specular light disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              specularLight: false,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('renders with noise overlay enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LiquidMaterial(
              noiseOverlay: true,
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
    });

    testWidgets('adaptive factory creates widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LiquidMaterial.adaptive(
              type: LiquidMaterialType.regular,
              child: const Text('Adaptive'),
            ),
          ),
        ),
      );

      expect(find.byType(LiquidMaterial), findsOneWidget);
      expect(find.text('Adaptive'), findsOneWidget);
    });
  });
}
