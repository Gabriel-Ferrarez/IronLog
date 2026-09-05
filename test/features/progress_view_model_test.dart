import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/session.dart';
import 'package:gym_tracker/features/progress/progress_view_model.dart';

void main() {
  WorkoutSession session(String id, DateTime date, double weight) =>
      WorkoutSession(
        id: id,
        workoutId: 'w1',
        date: date,
        entries: [
          SessionEntry(exerciseId: 'supino', sets: [
            LoggedSet(reps: 10, weightKg: weight),
          ]),
        ],
      );

  group('ProgressViewModel', () {
    test('isEmpty quando não há sessões', () {
      expect(ProgressViewModel([]).isEmpty, isTrue);
    });

    test('ordena os pontos do mais antigo ao mais recente', () {
      final vm = ProgressViewModel([
        session('nova', DateTime(2026, 6, 1), 50),
        session('antiga', DateTime(2026, 1, 1), 40),
      ]);
      final points = vm.volumePoints;
      expect(points.first.date, DateTime(2026, 1, 1));
      expect(points.last.date, DateTime(2026, 6, 1));
    });

    test('calcula total, melhor sessão e contagem', () {
      final vm = ProgressViewModel([
        session('1', DateTime(2026, 1, 1), 40), // volume 400
        session('2', DateTime(2026, 1, 2), 60), // volume 600
      ]);
      expect(vm.totalSessions, 2);
      expect(vm.totalVolume, 1000);
      expect(vm.bestVolume, 600);
    });
  });
}
