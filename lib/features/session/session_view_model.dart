import 'package:flutter/foundation.dart';

import '../../domain/models/session.dart';
import '../../domain/models/workout.dart';

/// Estado da tela de registro de uma sessão: acumula as séries digitadas
/// por exercício e monta a [WorkoutSession] final.
class SessionViewModel extends ChangeNotifier {
  final Workout workout;
  final Map<String, List<LoggedSet>> _logged = {};

  SessionViewModel(this.workout) {
    for (final we in workout.exercises) {
      _logged[we.exerciseId] = [];
    }
  }

  List<LoggedSet> setsOf(String exerciseId) =>
      List.unmodifiable(_logged[exerciseId] ?? const []);

  void addSet(String exerciseId, int reps, double weightKg) {
    if (reps <= 0) return;
    (_logged[exerciseId] ??= []).add(LoggedSet(reps: reps, weightKg: weightKg));
    notifyListeners();
  }

  void removeSet(String exerciseId, int index) {
    final list = _logged[exerciseId];
    if (list != null && index >= 0 && index < list.length) {
      list.removeAt(index);
      notifyListeners();
    }
  }

  int get totalSets =>
      _logged.values.fold(0, (total, list) => total + list.length);

  bool get hasAnySet => totalSets > 0;

  double get totalVolume => _logged.values
      .expand((list) => list)
      .fold(0.0, (total, set) => total + set.volume);

  /// Monta a sessão com os exercícios que tiveram ao menos uma série.
  WorkoutSession buildSession() {
    final entries = _logged.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => SessionEntry(exerciseId: e.key, sets: List.of(e.value)))
        .toList();
    return WorkoutSession(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      workoutId: workout.id,
      date: DateTime.now(),
      entries: entries,
    );
  }
}
