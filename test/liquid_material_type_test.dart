import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_ui/liquid_ui.dart';

void main() {
  group('LiquidMaterialType', () {
    test('ultraThin has correct blur sigma', () {
      expect(LiquidMaterialType.ultraThin.blurSigma, 10.0);
    });

    test('thin has correct blur sigma', () {
      expect(LiquidMaterialType.thin.blurSigma, 15.0);
    });

    test('regular has correct blur sigma', () {
      expect(LiquidMaterialType.regular.blurSigma, 20.0);
    });

    test('thick has correct blur sigma', () {
      expect(LiquidMaterialType.thick.blurSigma, 30.0);
    });

    test('ultraThin has correct background opacity', () {
      expect(LiquidMaterialType.ultraThin.backgroundOpacity, 0.02);
    });

    test('thin has correct background opacity', () {
      expect(LiquidMaterialType.thin.backgroundOpacity, 0.04);
    });

    test('regular has correct background opacity', () {
      expect(LiquidMaterialType.regular.backgroundOpacity, 0.06);
    });

    test('thick has correct background opacity', () {
      expect(LiquidMaterialType.thick.backgroundOpacity, 0.08);
    });

    test('ultraThin has correct border opacity', () {
      expect(LiquidMaterialType.ultraThin.borderOpacity, 0.3);
    });

    test('regular has correct border opacity', () {
      expect(LiquidMaterialType.regular.borderOpacity, 0.5);
    });

    test('thick has correct border opacity', () {
      expect(LiquidMaterialType.thick.borderOpacity, 0.6);
    });
  });
}
