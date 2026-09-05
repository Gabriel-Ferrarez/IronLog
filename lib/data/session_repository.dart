import 'dart:convert';

import '../domain/models/session.dart';
import 'key_value_store.dart';

/// Persistência das sessões de treino concluídas.
abstract interface class SessionRepository {
  Future<List<WorkoutSession>> getAll();
  Future<void> add(WorkoutSession session);
  Future<List<WorkoutSession>> forWorkout(String workoutId);
}

/// Implementação que serializa as sessões em JSON no [KeyValueStore].
class StoredSessionRepository implements SessionRepository {
  final KeyValueStore _store;
  static const _key = 'sessions';

  StoredSessionRepository(this._store);

  @override
  Future<List<WorkoutSession>> getAll() async {
    final raw = await _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    final sessions = list
        .map(
            (e) => WorkoutSession.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      // Mais recentes primeiro.
      ..sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  @override
  Future<void> add(WorkoutSession session) async {
    final all = await getAll()
      ..add(session);
    final encoded = jsonEncode(all.map((s) => s.toJson()).toList());
    await _store.setString(_key, encoded);
  }

  @override
  Future<List<WorkoutSession>> forWorkout(String workoutId) async {
    final all = await getAll();
    return all.where((s) => s.workoutId == workoutId).toList();
  }
}
