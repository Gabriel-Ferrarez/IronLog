import '../domain/models/exercise.dart';
import '../domain/models/workout.dart';

/// Dados iniciais do app: catálogo de exercícios e treinos A/B/C padrão.
class SeedData {
  SeedData._();

  static const exercises = <Exercise>[
    Exercise(
        id: 'supino_reto',
        name: 'Supino reto',
        muscleGroup: MuscleGroup.peito,
        equipment: 'Barra'),
    Exercise(
        id: 'supino_inclinado',
        name: 'Supino inclinado',
        muscleGroup: MuscleGroup.peito,
        equipment: 'Halteres'),
    Exercise(
        id: 'crucifixo',
        name: 'Crucifixo',
        muscleGroup: MuscleGroup.peito,
        equipment: 'Máquina'),
    Exercise(
        id: 'puxada_frente',
        name: 'Puxada frente',
        muscleGroup: MuscleGroup.costas,
        equipment: 'Polia'),
    Exercise(
        id: 'remada_curvada',
        name: 'Remada curvada',
        muscleGroup: MuscleGroup.costas,
        equipment: 'Barra'),
    Exercise(
        id: 'remada_baixa',
        name: 'Remada baixa',
        muscleGroup: MuscleGroup.costas,
        equipment: 'Polia'),
    Exercise(
        id: 'agachamento',
        name: 'Agachamento livre',
        muscleGroup: MuscleGroup.pernas,
        equipment: 'Barra'),
    Exercise(
        id: 'leg_press',
        name: 'Leg press',
        muscleGroup: MuscleGroup.pernas,
        equipment: 'Máquina'),
    Exercise(
        id: 'cadeira_extensora',
        name: 'Cadeira extensora',
        muscleGroup: MuscleGroup.pernas,
        equipment: 'Máquina'),
    Exercise(
        id: 'desenvolvimento',
        name: 'Desenvolvimento',
        muscleGroup: MuscleGroup.ombros,
        equipment: 'Halteres'),
    Exercise(
        id: 'elevacao_lateral',
        name: 'Elevação lateral',
        muscleGroup: MuscleGroup.ombros,
        equipment: 'Halteres'),
    Exercise(
        id: 'rosca_direta',
        name: 'Rosca direta',
        muscleGroup: MuscleGroup.biceps,
        equipment: 'Barra'),
    Exercise(
        id: 'rosca_alternada',
        name: 'Rosca alternada',
        muscleGroup: MuscleGroup.biceps,
        equipment: 'Halteres'),
    Exercise(
        id: 'triceps_polia',
        name: 'Tríceps na polia',
        muscleGroup: MuscleGroup.triceps,
        equipment: 'Polia'),
    Exercise(
        id: 'triceps_testa',
        name: 'Tríceps testa',
        muscleGroup: MuscleGroup.triceps,
        equipment: 'Barra'),
    Exercise(
        id: 'abdominal_supra',
        name: 'Abdominal supra',
        muscleGroup: MuscleGroup.abdomen,
        equipment: 'Livre'),
    Exercise(
        id: 'prancha',
        name: 'Prancha',
        muscleGroup: MuscleGroup.abdomen,
        equipment: 'Livre'),
    Exercise(
        id: 'agachamento_bulgaro',
        name: 'Agachamento búlgaro',
        muscleGroup: MuscleGroup.gluteos,
        equipment: 'Halteres'),
  ];

  static Exercise? exerciseById(String id) {
    for (final e in exercises) {
      if (e.id == id) return e;
    }
    return null;
  }

  static List<Workout> defaultWorkouts() => [
        const Workout(
          id: 'treino_a',
          name: 'Treino A — Peito e Tríceps',
          label: 'A',
          exercises: [
            WorkoutExercise(
                exerciseId: 'supino_reto', targetSets: 4, targetReps: 10),
            WorkoutExercise(
                exerciseId: 'supino_inclinado', targetSets: 3, targetReps: 12),
            WorkoutExercise(
                exerciseId: 'crucifixo', targetSets: 3, targetReps: 15),
            WorkoutExercise(
                exerciseId: 'triceps_polia', targetSets: 4, targetReps: 12),
            WorkoutExercise(
                exerciseId: 'triceps_testa', targetSets: 3, targetReps: 12),
          ],
        ),
        const Workout(
          id: 'treino_b',
          name: 'Treino B — Costas e Bíceps',
          label: 'B',
          exercises: [
            WorkoutExercise(
                exerciseId: 'puxada_frente', targetSets: 4, targetReps: 10),
            WorkoutExercise(
                exerciseId: 'remada_curvada', targetSets: 4, targetReps: 10),
            WorkoutExercise(
                exerciseId: 'remada_baixa', targetSets: 3, targetReps: 12),
            WorkoutExercise(
                exerciseId: 'rosca_direta', targetSets: 4, targetReps: 12),
            WorkoutExercise(
                exerciseId: 'rosca_alternada', targetSets: 3, targetReps: 12),
          ],
        ),
        const Workout(
          id: 'treino_c',
          name: 'Treino C — Pernas e Ombros',
          label: 'C',
          exercises: [
            WorkoutExercise(
                exerciseId: 'agachamento', targetSets: 4, targetReps: 8),
            WorkoutExercise(
                exerciseId: 'leg_press', targetSets: 4, targetReps: 12),
            WorkoutExercise(
                exerciseId: 'cadeira_extensora', targetSets: 3, targetReps: 15),
            WorkoutExercise(
                exerciseId: 'desenvolvimento', targetSets: 4, targetReps: 10),
            WorkoutExercise(
                exerciseId: 'elevacao_lateral', targetSets: 3, targetReps: 15),
          ],
        ),
      ];
}
