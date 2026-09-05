import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/ab/ab_analytics.dart';
import 'package:gym_tracker/core/ab/ab_test_service.dart';
import 'package:gym_tracker/core/ab/experiment.dart';
import 'package:gym_tracker/features/home/home_view_model.dart';

void main() {
  const experiment = Experiment(key: 'home_cta_layout', weightB: 0.5);

  HomeViewModel build(AbAnalytics analytics, {String userId = 'user-1'}) =>
      HomeViewModel(
        abTest: const AbTestService(),
        analytics: analytics,
        experiment: experiment,
        userId: userId,
      );

  group('HomeViewModel', () {
    test('atribui a variante no construtor de forma determinística', () {
      final vm1 = build(AbAnalytics(), userId: 'user-fixo');
      final vm2 = build(AbAnalytics(), userId: 'user-fixo');
      expect(vm1.variant, vm2.variant);
    });

    test('onScreenViewed registra exatamente uma exposição', () {
      final analytics = AbAnalytics();
      final vm = build(analytics);

      vm.onScreenViewed();
      vm.onScreenViewed(); // chamadas repetidas não contam de novo
      vm.onScreenViewed();

      expect(analytics.exposures(experiment.key, vm.variant), 1);
    });

    test('onStartWorkout registra a conversão da variante do usuário', () {
      final analytics = AbAnalytics();
      final vm = build(analytics);

      vm.onScreenViewed();
      vm.onStartWorkout();

      expect(analytics.conversions(experiment.key, vm.variant), 1);
      expect(analytics.conversionRate(experiment.key, vm.variant), 1.0);
    });
  });
}
