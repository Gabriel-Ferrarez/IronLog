import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/session.dart';
import 'package:gym_tracker/domain/stats.dart';

void main() {
  group('Stats.epleyOneRepMax', () {
    test('para 1 repetição, o 1RM é a própria carga', () {
      expect(Stats.epleyOneRepMax(100, 1), 100);
    });

    test('aplica a fórmula de Epley para múltiplas repetições', () {
      // 100 * (1 + 10/30) = 133.33...
      expect(Stats.epleyOneRepMax(100, 10), closeTo(133.33, 0.01));
    });

    test('retorna 0 para repetições inválidas', () {
      expect(Stats.epleyOneRepMax(100, 0), 0);
      expect(Stats.epleyOneRepMax(100, -3), 0);
    });
  });

  group('Stats.bestOneRepMax', () {
    test('retorna o maior 1RM estimado entre as séries', () {
      const entry = SessionEntry(exerciseId: 'supino', sets: [
        LoggedSet(reps: 10, weightKg: 60), // ~80
        LoggedSet(reps: 5, weightKg: 80), // ~93.3
        LoggedSet(reps: 12, weightKg: 50), // ~70
      ]);
      expect(Stats.bestOneRepMax(entry), closeTo(93.33, 0.01));
    });

    test('retorna 0 quando não há séries', () {
      const entry = SessionEntry(exerciseId: 'x');
      expect(Stats.bestOneRepMax(entry), 0);
    });
  });

  group('Stats.totalVolume', () {
    test('soma o volume de várias sessões', () {
      final sessions = [
        WorkoutSession(
          id: '1',
          workoutId: 'w',
          date: DateTime(2026, 1, 1),
          entries: const [
            SessionEntry(
                exerciseId: 'a', sets: [LoggedSet(reps: 10, weightKg: 10)]),
          ],
        ),
        WorkoutSession(
          id: '2',
          workoutId: 'w',
          date: DateTime(2026, 1, 2),
          entries: const [
            SessionEntry(
                exerciseId: 'a', sets: [LoggedSet(reps: 10, weightKg: 20)]),
          ],
        ),
      ];
      expect(Stats.totalVolume(sessions), 100 + 200);
    });
  });
}
