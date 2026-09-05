import '../domain/models/exercise.dart';
import 'seed_data.dart';

/// Fonte dos exercícios do catálogo.
abstract interface class ExerciseRepository {
  List<Exercise> all();
  Exercise? byId(String id);
  List<Exercise> byGroup(MuscleGroup group);
  List<Exercise> search(String query);
}

/// Implementação baseada nos dados de seed (catálogo fixo do app).
class SeedExerciseRepository implements ExerciseRepository {
  const SeedExerciseRepository();

  @override
  List<Exercise> all() => SeedData.exercises;

  @override
  Exercise? byId(String id) => SeedData.exerciseById(id);

  @override
  List<Exercise> byGroup(MuscleGroup group) =>
      SeedData.exercises.where((e) => e.muscleGroup == group).toList();

  @override
  List<Exercise> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all();
    return SeedData.exercises
        .where((e) => e.name.toLowerCase().contains(q))
        .toList();
  }
}
