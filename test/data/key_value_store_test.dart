import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/key_value_store.dart';

void main() {
  group('InMemoryKeyValueStore', () {
    test('retorna null para chave inexistente', () async {
      final store = InMemoryKeyValueStore();
      expect(await store.getString('x'), isNull);
    });

    test('grava e lê um valor', () async {
      final store = InMemoryKeyValueStore();
      await store.setString('nome', 'IronLog');
      expect(await store.getString('nome'), 'IronLog');
    });

    test('remove um valor', () async {
      final store = InMemoryKeyValueStore();
      await store.setString('a', '1');
      await store.remove('a');
      expect(await store.getString('a'), isNull);
    });

    test('aceita um estado inicial (seed)', () async {
      final store = InMemoryKeyValueStore({'k': 'v'});
      expect(await store.getString('k'), 'v');
    });
  });
}
