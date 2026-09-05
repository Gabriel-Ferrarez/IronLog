import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/key_value_store.dart';
import 'package:gym_tracker/data/session_repository.dart';
import 'package:gym_tracker/domain/models/session.dart';

void main() {
  late StoredSessionRepository repo;

  WorkoutSession session(String id, DateTime date, {String workoutId = 'w1'}) =>
      WorkoutSession(
        id: id,
        workoutId: workoutId,
        date: date,
        entries: const [
          SessionEntry(exerciseId: 'supino', sets: [
            LoggedSet(reps: 10, weightKg: 40),
          ]),
        ],
      );

  setUp(() {
    repo = StoredSessionRepository(InMemoryKeyValueStore());
  });

  group('StoredSessionRepository', () {
    test('adiciona e recupera sessões', () async {
      await repo.add(session('s1', DateTime(2026, 1, 1)));
      expect(await repo.getAll(), hasLength(1));
    });

    test('retorna as sessões mais recentes primeiro', () async {
      await repo.add(session('antiga', DateTime(2026, 1, 1)));
      await repo.add(session('nova', DateTime(2026, 6, 1)));

      final all = await repo.getAll();
      expect(all.first.id, 'nova');
      expect(all.last.id, 'antiga');
    });

    test('forWorkout filtra por treino', () async {
      await repo.add(session('s1', DateTime(2026, 1, 1), workoutId: 'w1'));
      await repo.add(session('s2', DateTime(2026, 1, 2), workoutId: 'w2'));

      final onlyW1 = await repo.forWorkout('w1');
      expect(onlyW1, hasLength(1));
      expect(onlyW1.first.id, 's1');
    });
  });
}
