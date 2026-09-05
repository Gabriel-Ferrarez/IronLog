import 'dart:math';

import '../../domain/models/session.dart';
import '../../domain/stats.dart';

/// Um ponto do gráfico de evolução: data e volume da sessão.
class ProgressPoint {
  final DateTime date;
  final double volume;

  const ProgressPoint({required this.date, required this.volume});
}

/// Lógica (pura) da tela de progresso. Sem Flutter, fácil de testar.
class ProgressViewModel {
  final List<WorkoutSession> sessions;

  ProgressViewModel(this.sessions);

  List<WorkoutSession> get _ordered =>
      [...sessions]..sort((a, b) => a.date.compareTo(b.date));

  /// Pontos do gráfico, do mais antigo ao mais recente.
  List<ProgressPoint> get volumePoints => _ordered
      .map((s) => ProgressPoint(date: s.date, volume: s.totalVolume))
      .toList();

  int get totalSessions => sessions.length;

  double get totalVolume => Stats.totalVolume(sessions);

  double get bestVolume =>
      sessions.isEmpty ? 0 : sessions.map((s) => s.totalVolume).reduce(max);

  bool get isEmpty => sessions.isEmpty;
}
