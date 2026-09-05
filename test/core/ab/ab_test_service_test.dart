import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/ab/ab_test_service.dart';
import 'package:gym_tracker/core/ab/experiment.dart';
import 'package:gym_tracker/core/ab/variant.dart';

void main() {
  const service = AbTestService();
  const exp = Experiment(key: 'exp_teste', weightB: 0.5);

  group('AbTestService.assign', () {
    test('é determinístico: mesma unidade sempre recebe a mesma variante', () {
      final first = service.assign(exp, 'user-123');
      for (var i = 0; i < 50; i++) {
        expect(service.assign(exp, 'user-123'), first);
      }
    });

    test('weightB = 0 sempre resulta em A', () {
      const control = Experiment(key: 'so_a', weightB: 0);
      for (var i = 0; i < 500; i++) {
        expect(service.assign(control, 'u$i'), Variant.a);
      }
    });

    test('weightB = 1 sempre resulta em B', () {
      const treatment = Experiment(key: 'so_b', weightB: 1);
      for (var i = 0; i < 500; i++) {
        expect(service.assign(treatment, 'u$i'), Variant.b);
      }
    });

    test('divisão 50/50 fica próxima do esperado em uma amostra grande', () {
      var b = 0;
      const total = 4000;
      for (var i = 0; i < total; i++) {
        if (service.assign(exp, 'pessoa_$i') == Variant.b) b++;
      }
      expect(b / total, closeTo(0.5, 0.05));
    });

    test('respeita um peso assimétrico (30% em B)', () {
      const exp30 = Experiment(key: 'exp30', weightB: 0.3);
      var b = 0;
      const total = 4000;
      for (var i = 0; i < total; i++) {
        if (service.assign(exp30, 'p_$i') == Variant.b) b++;
      }
      expect(b / total, closeTo(0.3, 0.05));
    });

    test(
        'experimentos diferentes podem dar variantes diferentes ao mesmo usuário',
        () {
      // Garante que a chave do experimento entra no cálculo (não é só o usuário).
      const a = Experiment(key: 'exp_a', weightB: 0.5);
      const b = Experiment(key: 'exp_b', weightB: 0.5);
      var diff = 0;
      for (var i = 0; i < 200; i++) {
        if (service.assign(a, 'u$i') != service.assign(b, 'u$i')) diff++;
      }
      expect(diff, greaterThan(0));
    });
  });
}
