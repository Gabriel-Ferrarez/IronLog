import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/workout.dart';

void main() {
  const base = Workout(
    id: 'w1',
    name: 'Treino A',
    label: 'A',
    exercises: [
      WorkoutExercise(exerciseId: 'supino', targetSets: 4, targetReps: 10),
    ],
  );

  group('Workout', () {
    test('exerciseCount reflete a lista de exercícios', () {
      expect(base.exerciseCount, 1);
    });

    test('addExercise retorna uma cópia com o novo exercício', () {
      final updated =
          base.addExercise(const WorkoutExercise(exerciseId: 'crucifixo'));
      expect(updated.exerciseCount, 2);
      // O original permanece imutável.
      expect(base.exerciseCount, 1);
    });

    test('removeExercise remove pelo id', () {
      final updated = base.removeExercise('supino');
      expect(updated.exerciseCount, 0);
    });

    test('copyWith altera apenas os campos informados', () {
      final renamed = base.copyWith(name: 'Novo nome');
      expect(renamed.name, 'Novo nome');
      expect(renamed.id, base.id);
      expect(renamed.label, base.label);
    });

    test('toJson/fromJson faz ida e volta sem perder dados', () {
      final json = base.toJson();
      final restored = Workout.fromJson(json);
      expect(restored.id, base.id);
      expect(restored.name, base.name);
      expect(restored.label, base.label);
      expect(restored.exercises.first.exerciseId, 'supino');
      expect(restored.exercises.first.targetSets, 4);
      expect(restored.exercises.first.targetReps, 10);
    });
  });
}
