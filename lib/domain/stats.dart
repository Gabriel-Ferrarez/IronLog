import 'models/session.dart';

/// Funções puras de cálculo de métricas de treino.
///
/// São puras (sem estado, sem I/O) de propósito: ficam triviais de testar,
/// que é o coração do TDD deste projeto.
class Stats {
  Stats._();

  /// 1RM (uma repetição máxima) estimado pela fórmula de Epley:
  ///
  ///   1RM = carga × (1 + reps / 30)
  ///
  /// Para 1 repetição, o próprio peso é o 1RM.
  static double epleyOneRepMax(double weightKg, int reps) {
    if (reps <= 0) return 0;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30.0);
  }

  /// Maior 1RM estimado entre todas as séries de um exercício na sessão.
  static double bestOneRepMax(SessionEntry entry) {
    double best = 0;
    for (final set in entry.sets) {
      final orm = epleyOneRepMax(set.weightKg, set.reps);
      if (orm > best) best = orm;
    }
    return best;
  }

  /// Volume total de uma lista de sessões.
  static double totalVolume(Iterable<WorkoutSession> sessions) =>
      sessions.fold(0, (total, s) => total + s.totalVolume);
}
