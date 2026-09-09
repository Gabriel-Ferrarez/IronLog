import 'package:flutter/foundation.dart';

import '../../domain/models/exercise.dart';

/// ViewModel para a tela de detalhe de exercício.
class ExerciseDetailViewModel extends ChangeNotifier {
  final Exercise exercise;

  ExerciseDetailViewModel({required this.exercise});

  /// Descrição completa do exercício (pode ser expandida para dados do banco).
  String get description {
    return 'O ${exercise.name} é um exercício que trabalha principalmente '
        'o ${exercise.muscleGroup.label.toLowerCase()}. '
        '${exercise.equipment.isNotEmpty ? 'Utiliza ${exercise.equipment}.' : 'Exercício sem equipamento.'} '
        'Ideal para treinos de força e hipertrofia.';
  }

  /// Dicas de execução.
  List<String> get tips => [
    'Mantenha a forma correta durante todo o movimento',
    'Controle o peso em todas as fases do exercício',
    'Respire adequadamente: inspire na fase mais difícil',
    'Aumente a intensidade gradualmente',
    'Descanse adequadamente entre os treinos',
  ];

  /// Grupos musculares secundários afetados.
  List<String> get secondaryMuscles => _getSecondaryMuscles();

  List<String> _getSecondaryMuscles() {
    switch (exercise.muscleGroup) {
      case MuscleGroup.peito:
        return ['Tríceps', 'Ombros'];
      case MuscleGroup.costas:
        return ['Bíceps', 'Trapézio'];
      case MuscleGroup.pernas:
        return ['Glúteos', 'Abdômen'];
      case MuscleGroup.ombros:
        return ['Tríceps', 'Peito'];
      case MuscleGroup.biceps:
        return ['Costas', 'Antebraço'];
      case MuscleGroup.triceps:
        return ['Peito', 'Ombros'];
      case MuscleGroup.abdomen:
        return ['Pernas', 'Costas'];
      case MuscleGroup.gluteos:
        return ['Pernas', 'Costas'];
    }
  }
}
