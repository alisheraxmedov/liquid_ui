import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liquid_ui/liquid_ui.dart';

void main() {
  group('GlassWidget', () {
    testWidgets('renders correctly with default parameters', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GlassWidget())),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('renders with custom width and height', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassWidget(width: 200, height: 100)),
        ),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
    });

    testWidgets('renders with custom borderRadius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: GlassWidget(borderRadius: 50))),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
    });

    testWidgets('renders with child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassWidget(width: 100, height: 100, child: Text('Test')),
          ),
        ),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('renders with Icon as child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlassWidget(
              width: 80,
              height: 80,
              borderRadius: 40,
              child: Center(child: Icon(Icons.camera_alt)),
            ),
          ),
        ),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('renders without child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GlassWidget(width: 100, height: 100)),
        ),
      );

      expect(find.byType(GlassWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('multiple GlassWidgets render correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                GlassWidget(width: 50, height: 50),
                GlassWidget(width: 50, height: 50),
                GlassWidget(width: 50, height: 50),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GlassWidget), findsNWidgets(3));
    });
  });
}
