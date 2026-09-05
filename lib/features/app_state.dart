import 'package:flutter/foundation.dart';

import '../data/exercise_repository.dart';
import '../data/session_repository.dart';
import '../data/workout_repository.dart';
import '../domain/models/exercise.dart';
import '../domain/models/session.dart';
import '../domain/models/workout.dart';
import '../domain/stats.dart';

/// Estado central do app: reúne os repositórios e expõe os dados prontos
/// para as telas (treinos, sessões, métricas do painel inicial).
class AppState extends ChangeNotifier {
  final ExerciseRepository exerciseRepo;
  final WorkoutRepository workoutRepo;
  final SessionRepository sessionRepo;
  final String userId;

  List<Workout> _workouts = const [];
  List<WorkoutSession> _sessions = const [];
  bool _loading = true;

  AppState({
    required this.exerciseRepo,
    required this.workoutRepo,
    required this.sessionRepo,
    required this.userId,
  });

  bool get isLoading => _loading;
  List<Workout> get workouts => List.unmodifiable(_workouts);
  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

  /// Carrega os dados persistidos. Chamado uma vez na inicialização.
  Future<void> load() async {
    _workouts = await workoutRepo.getAll();
    _sessions = await sessionRepo.getAll();
    _loading = false;
    notifyListeners();
  }

  /// Treino sugerido para hoje: rotaciona A/B/C conforme o dia.
  Workout? get todaysWorkout {
    if (_workouts.isEmpty) return null;
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    return _workouts[dayOfYear % _workouts.length];
  }

  /// Nº de sessões nos últimos 7 dias.
  int get sessionsThisWeek {
    final limit = DateTime.now().subtract(const Duration(days: 7));
    return _sessions.where((s) => s.date.isAfter(limit)).length;
  }

  /// Volume total acumulado (kg levantados) em todas as sessões.
  double get totalVolume => Stats.totalVolume(_sessions);

  /// Sequência de dias consecutivos (terminando hoje ou ontem) com treino.
  int get streak {
    if (_sessions.isEmpty) return 0;
    final days = _sessions.map((s) => _dayOnly(s.date)).toSet();
    var cursor = _dayOnly(DateTime.now());
    // Se ainda não treinou hoje, a sequência pode terminar ontem.
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    var count = 0;
    while (days.contains(cursor)) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  Exercise? exercise(String id) => exerciseRepo.byId(id);

  Workout? workoutById(String id) {
    for (final w in _workouts) {
      if (w.id == id) return w;
    }
    return null;
  }

  Future<void> addSession(WorkoutSession session) async {
    await sessionRepo.add(session);
    _sessions = await sessionRepo.getAll();
    notifyListeners();
  }

  Future<void> saveWorkout(Workout workout) async {
    await workoutRepo.save(workout);
    _workouts = await workoutRepo.getAll();
    notifyListeners();
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
