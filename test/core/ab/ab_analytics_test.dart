import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/ab/ab_analytics.dart';
import 'package:gym_tracker/core/ab/variant.dart';

void main() {
  const key = 'home_cta';

  group('AbAnalytics', () {
    test('começa zerado', () {
      final analytics = AbAnalytics();
      expect(analytics.exposures(key, Variant.a), 0);
      expect(analytics.conversions(key, Variant.a), 0);
      expect(analytics.conversionRate(key, Variant.a), 0);
    });

    test('conta exposições e conversões por variante', () {
      final analytics = AbAnalytics();
      analytics.recordExposure(key, Variant.a);
      analytics.recordExposure(key, Variant.a);
      analytics.recordConversion(key, Variant.a);

      expect(analytics.exposures(key, Variant.a), 2);
      expect(analytics.conversions(key, Variant.a), 1);
      expect(analytics.exposures(key, Variant.b), 0);
    });

    test('calcula a taxa de conversão corretamente', () {
      final analytics = AbAnalytics();
      for (var i = 0; i < 4; i++) {
        analytics.recordExposure(key, Variant.b);
      }
      analytics.recordConversion(key, Variant.b);
      expect(analytics.conversionRate(key, Variant.b), 0.25);
    });

    test('taxa é 0 sem exposições (evita divisão por zero)', () {
      final analytics = AbAnalytics();
      analytics.recordConversion(key, Variant.a); // caso de borda
      expect(analytics.conversionRate(key, Variant.a), 0);
    });

    test('notifica os listeners ao registrar eventos', () {
      final analytics = AbAnalytics();
      var notified = 0;
      analytics.addListener(() => notified++);
      analytics.recordExposure(key, Variant.a);
      analytics.recordConversion(key, Variant.a);
      expect(notified, 2);
    });

    test('serializa e desserializa preservando os números', () {
      final analytics = AbAnalytics();
      analytics.recordExposure(key, Variant.a);
      analytics.recordExposure(key, Variant.b);
      analytics.recordConversion(key, Variant.b);

      final restored = AbAnalytics.fromJson(analytics.toJson());
      expect(restored.exposures(key, Variant.a), 1);
      expect(restored.exposures(key, Variant.b), 1);
      expect(restored.conversions(key, Variant.b), 1);
    });
  });
}
