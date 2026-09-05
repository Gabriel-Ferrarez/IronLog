import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/domain/models/exercise.dart';

void main() {
  group('MuscleGroup', () {
    test('todos os grupos têm rótulo não vazio', () {
      for (final g in MuscleGroup.values) {
        expect(g.label, isNotEmpty);
      }
    });

    test('fromName reconhece o nome e faz fallback seguro', () {
      expect(MuscleGroup.fromName('costas'), MuscleGroup.costas);
      expect(MuscleGroup.fromName('inexistente'), MuscleGroup.peito);
    });
  });

  group('Exercise', () {
    const exercise = Exercise(
      id: 'supino_reto',
      name: 'Supino reto',
      muscleGroup: MuscleGroup.peito,
      equipment: 'Barra',
    );

    test('toJson/fromJson preserva os campos', () {
      final restored = Exercise.fromJson(exercise.toJson());
      expect(restored.id, exercise.id);
      expect(restored.name, exercise.name);
      expect(restored.muscleGroup, MuscleGroup.peito);
      expect(restored.equipment, 'Barra');
    });

    test('igualdade por valor', () {
      const igual = Exercise(
        id: 'supino_reto',
        name: 'Supino reto',
        muscleGroup: MuscleGroup.peito,
        equipment: 'Barra',
      );
      expect(exercise, igual);
      expect(exercise.hashCode, igual.hashCode);
    });
  });
}
