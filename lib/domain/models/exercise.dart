/// Grupo muscular trabalhado por um exercício.
enum MuscleGroup {
  peito,
  costas,
  pernas,
  ombros,
  biceps,
  triceps,
  abdomen,
  gluteos;

  /// Nome amigável para exibição.
  String get label {
    switch (this) {
      case MuscleGroup.peito:
        return 'Peito';
      case MuscleGroup.costas:
        return 'Costas';
      case MuscleGroup.pernas:
        return 'Pernas';
      case MuscleGroup.ombros:
        return 'Ombros';
      case MuscleGroup.biceps:
        return 'Bíceps';
      case MuscleGroup.triceps:
        return 'Tríceps';
      case MuscleGroup.abdomen:
        return 'Abdômen';
      case MuscleGroup.gluteos:
        return 'Glúteos';
    }
  }

  static MuscleGroup fromName(String name) => MuscleGroup.values.firstWhere(
        (g) => g.name == name,
        orElse: () => MuscleGroup.peito,
      );
}

/// Um exercício do catálogo.
class Exercise {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  final String equipment;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.equipment = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroup': muscleGroup.name,
        'equipment': equipment,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        muscleGroup: MuscleGroup.fromName(json['muscleGroup'] as String),
        equipment: (json['equipment'] as String?) ?? '',
      );

  @override
  bool operator ==(Object other) =>
      other is Exercise &&
      other.id == id &&
      other.name == name &&
      other.muscleGroup == muscleGroup &&
      other.equipment == equipment;

  @override
  int get hashCode => Object.hash(id, name, muscleGroup, equipment);
}
