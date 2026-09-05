import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/session.dart';

void main() {
  group('LoggedSet', () {
    test('volume = repetições × carga', () {
      const set = LoggedSet(reps: 10, weightKg: 40);
      expect(set.volume, 400);
    });
  });

  group('SessionEntry', () {
    test('soma o volume de todas as séries', () {
      const entry = SessionEntry(exerciseId: 'supino', sets: [
        LoggedSet(reps: 10, weightKg: 40),
        LoggedSet(reps: 8, weightKg: 50),
      ]);
      expect(entry.volume, 400 + 400);
    });
  });

  group('WorkoutSession', () {
    final session = WorkoutSession(
      id: 's1',
      workoutId: 'w1',
      date: DateTime(2026, 9, 1),
      entries: const [
        SessionEntry(exerciseId: 'supino', sets: [
          LoggedSet(reps: 10, weightKg: 40),
        ]),
        SessionEntry(exerciseId: 'crucifixo', sets: [
          LoggedSet(reps: 12, weightKg: 20),
          LoggedSet(reps: 12, weightKg: 20),
        ]),
      ],
    );

    test('totalVolume soma todos os exercícios', () {
      expect(session.totalVolume, 400 + 240 + 240);
    });

    test('totalSets conta todas as séries', () {
      expect(session.totalSets, 3);
    });

    test('toJson/fromJson preserva data e volumes', () {
      final restored = WorkoutSession.fromJson(session.toJson());
      expect(restored.id, session.id);
      expect(restored.workoutId, session.workoutId);
      expect(restored.date, session.date);
      expect(restored.totalVolume, session.totalVolume);
      expect(restored.totalSets, 3);
    });
  });
}
