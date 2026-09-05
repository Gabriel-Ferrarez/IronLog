import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/workout.dart';
import 'package:gym_tracker/features/session/session_view_model.dart';

void main() {
  const workout = Workout(
    id: 'w1',
    name: 'Treino A',
    label: 'A',
    exercises: [
      WorkoutExercise(exerciseId: 'supino'),
      WorkoutExercise(exerciseId: 'crucifixo'),
    ],
  );

  group('SessionViewModel', () {
    test('começa sem séries', () {
      final vm = SessionViewModel(workout);
      expect(vm.hasAnySet, isFalse);
      expect(vm.totalSets, 0);
      expect(vm.totalVolume, 0);
    });

    test('addSet acumula séries e volume', () {
      final vm = SessionViewModel(workout);
      vm.addSet('supino', 10, 40);
      vm.addSet('supino', 8, 50);

      expect(vm.totalSets, 2);
      expect(vm.totalVolume, 400 + 400);
      expect(vm.setsOf('supino'), hasLength(2));
    });

    test('ignora séries com repetições inválidas', () {
      final vm = SessionViewModel(workout);
      vm.addSet('supino', 0, 40);
      expect(vm.totalSets, 0);
    });

    test('removeSet remove a série pelo índice', () {
      final vm = SessionViewModel(workout);
      vm.addSet('supino', 10, 40);
      vm.addSet('supino', 8, 50);
      vm.removeSet('supino', 0);

      expect(vm.setsOf('supino'), hasLength(1));
      expect(vm.setsOf('supino').first.reps, 8);
    });

    test('buildSession inclui apenas exercícios com séries', () {
      final vm = SessionViewModel(workout);
      vm.addSet('supino', 10, 40);

      final session = vm.buildSession();
      expect(session.workoutId, 'w1');
      expect(session.entries, hasLength(1));
      expect(session.entries.first.exerciseId, 'supino');
      expect(session.totalVolume, 400);
    });
  });
}
