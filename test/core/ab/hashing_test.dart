import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/ab/hashing.dart';

void main() {
  group('fnv1a32', () {
    test('é determinístico para a mesma entrada', () {
      expect(fnv1a32('abc'), fnv1a32('abc'));
    });

    test('produz valores diferentes para entradas diferentes', () {
      expect(fnv1a32('abc'), isNot(fnv1a32('abd')));
    });

    test('mantém o resultado dentro de 32 bits', () {
      final hash = fnv1a32('qualquer-string-grande-aqui-1234567890');
      expect(hash, greaterThanOrEqualTo(0));
      expect(hash, lessThan(0x100000000));
    });
  });

  group('hashToUnitInterval', () {
    test('retorna sempre um valor em [0, 1)', () {
      for (var i = 0; i < 1000; i++) {
        final value = hashToUnitInterval('unidade_$i');
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThan(1.0));
      }
    });

    test('é determinístico', () {
      expect(hashToUnitInterval('user-42'), hashToUnitInterval('user-42'));
    });

    test('distribui de forma aproximadamente uniforme', () {
      var below = 0;
      const total = 5000;
      for (var i = 0; i < total; i++) {
        if (hashToUnitInterval('id_$i') < 0.5) below++;
      }
      final fraction = below / total;
      // Deve ficar perto de 50% (tolerância de 5 pontos percentuais).
      expect(fraction, closeTo(0.5, 0.05));
    });
  });
}
