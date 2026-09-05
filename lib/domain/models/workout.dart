/// Um exercício dentro de um treino, com metas de séries e repetições.
class WorkoutExercise {
  final String exerciseId;
  final int targetSets;
  final int targetReps;

  const WorkoutExercise({
    required this.exerciseId,
    this.targetSets = 3,
    this.targetReps = 12,
  });

  WorkoutExercise copyWith({int? targetSets, int? targetReps}) =>
      WorkoutExercise(
        exerciseId: exerciseId,
        targetSets: targetSets ?? this.targetSets,
        targetReps: targetReps ?? this.targetReps,
      );

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'targetSets': targetSets,
        'targetReps': targetReps,
      };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseId: json['exerciseId'] as String,
        targetSets: (json['targetSets'] as num?)?.toInt() ?? 3,
        targetReps: (json['targetReps'] as num?)?.toInt() ?? 12,
      );
}

/// Um treino (ex.: "Treino A — Peito e Tríceps"), com sua lista de exercícios.
class Workout {
  final String id;
  final String name;

  /// Rótulo curto usado na divisão A/B/C do treino.
  final String label;
  final List<WorkoutExercise> exercises;

  const Workout({
    required this.id,
    required this.name,
    this.label = 'A',
    this.exercises = const [],
  });

  int get exerciseCount => exercises.length;

  Workout copyWith({
    String? name,
    String? label,
    List<WorkoutExercise>? exercises,
  }) =>
      Workout(
        id: id,
        name: name ?? this.name,
        label: label ?? this.label,
        exercises: exercises ?? this.exercises,
      );

  /// Retorna uma cópia com [exercise] adicionado ao fim.
  Workout addExercise(WorkoutExercise exercise) =>
      copyWith(exercises: [...exercises, exercise]);

  /// Retorna uma cópia sem o exercício de id [exerciseId].
  Workout removeExercise(String exerciseId) => copyWith(
        exercises: exercises.where((e) => e.exerciseId != exerciseId).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'label': label,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'] as String,
        name: json['name'] as String,
        label: (json['label'] as String?) ?? 'A',
        exercises: ((json['exercises'] as List?) ?? [])
            .map((e) =>
                WorkoutExercise.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
