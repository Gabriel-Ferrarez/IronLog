/// Uma série registrada: número de repetições e carga usada (kg).
class LoggedSet {
  final int reps;
  final double weightKg;

  const LoggedSet({required this.reps, required this.weightKg});

  /// Volume da série = repetições × carga.
  double get volume => reps * weightKg;

  Map<String, dynamic> toJson() => {'reps': reps, 'weightKg': weightKg};

  factory LoggedSet.fromJson(Map<String, dynamic> json) => LoggedSet(
        reps: (json['reps'] as num).toInt(),
        weightKg: (json['weightKg'] as num).toDouble(),
      );
}

/// Registro de um exercício dentro de uma sessão: suas séries.
class SessionEntry {
  final String exerciseId;
  final List<LoggedSet> sets;

  const SessionEntry({required this.exerciseId, this.sets = const []});

  /// Soma do volume de todas as séries deste exercício.
  double get volume => sets.fold(0, (total, s) => total + s.volume);

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  factory SessionEntry.fromJson(Map<String, dynamic> json) => SessionEntry(
        exerciseId: json['exerciseId'] as String,
        sets: ((json['sets'] as List?) ?? [])
            .map((s) => LoggedSet.fromJson(Map<String, dynamic>.from(s as Map)))
            .toList(),
      );
}

/// Uma sessão de treino concluída, com data e os exercícios realizados.
class WorkoutSession {
  final String id;
  final String workoutId;
  final DateTime date;
  final List<SessionEntry> entries;

  const WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.date,
    this.entries = const [],
  });

  /// Volume total da sessão (soma de todos os exercícios).
  double get totalVolume => entries.fold(0, (total, e) => total + e.volume);

  /// Número total de séries realizadas na sessão.
  int get totalSets => entries.fold(0, (total, e) => total + e.sets.length);

  Map<String, dynamic> toJson() => {
        'id': id,
        'workoutId': workoutId,
        'date': date.toIso8601String(),
        'entries': entries.map((e) => e.toJson()).toList(),
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
        id: json['id'] as String,
        workoutId: json['workoutId'] as String,
        date: DateTime.parse(json['date'] as String),
        entries: ((json['entries'] as List?) ?? [])
            .map((e) =>
                SessionEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
