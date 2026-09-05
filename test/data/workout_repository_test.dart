import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/key_value_store.dart';
import 'package:gym_tracker/data/workout_repository.dart';
import 'package:gym_tracker/domain/models/workout.dart';

void main() {
  late InMemoryKeyValueStore store;
  late StoredWorkoutRepository repo;

  setUp(() {
    store = InMemoryKeyValueStore();
    repo = StoredWorkoutRepository(store);
  });

  group('StoredWorkoutRepository', () {
    test('começa vazio', () async {
      expect(await repo.getAll(), isEmpty);
    });

    test('salva e recupera um treino', () async {
      const workout = Workout(id: 'w1', name: 'Treino A', label: 'A');
      await repo.save(workout);

      final all = await repo.getAll();
      expect(all, hasLength(1));
      expect(all.first.name, 'Treino A');
    });

    test('salvar com id existente atualiza (não duplica)', () async {
      await repo.save(const Workout(id: 'w1', name: 'Original', label: 'A'));
      await repo.save(const Workout(id: 'w1', name: 'Editado', label: 'A'));

      final all = await repo.getAll();
      expect(all, hasLength(1));
      expect(all.first.name, 'Editado');
    });

    test('getById retorna o treino certo ou null', () async {
      await repo.save(const Workout(id: 'w1', name: 'Treino A', label: 'A'));
      expect((await repo.getById('w1'))?.name, 'Treino A');
      expect(await repo.getById('inexistente'), isNull);
    });

    test('delete remove o treino', () async {
      await repo.save(const Workout(id: 'w1', name: 'Treino A', label: 'A'));
      await repo.delete('w1');
      expect(await repo.getAll(), isEmpty);
    });

    test('seedIfEmpty cria os treinos padrão apenas uma vez', () async {
      await repo.seedIfEmpty();
      final afterFirst = await repo.getAll();
      expect(afterFirst, hasLength(3)); // A, B, C

      await repo.seedIfEmpty();
      final afterSecond = await repo.getAll();
      expect(afterSecond, hasLength(3)); // não duplica
    });

    test('persiste entre instâncias que compartilham o mesmo store', () async {
      await repo.save(const Workout(id: 'w1', name: 'Persistido', label: 'A'));

      final outra = StoredWorkoutRepository(store);
      final all = await outra.getAll();
      expect(all.first.name, 'Persistido');
    });
  });
}
