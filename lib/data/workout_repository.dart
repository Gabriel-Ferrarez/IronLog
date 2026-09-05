import 'dart:convert';

import '../domain/models/workout.dart';
import 'key_value_store.dart';
import 'seed_data.dart';

/// Persistência dos treinos do usuário.
abstract interface class WorkoutRepository {
  Future<List<Workout>> getAll();
  Future<Workout?> getById(String id);
  Future<void> save(Workout workout);
  Future<void> delete(String id);
}

/// Implementação que serializa os treinos em JSON no [KeyValueStore].
class StoredWorkoutRepository implements WorkoutRepository {
  final KeyValueStore _store;
  static const _key = 'workouts';

  StoredWorkoutRepository(this._store);

  /// Garante que, na primeira execução, os treinos A/B/C padrão existam.
  Future<void> seedIfEmpty() async {
    final existing = await getAll();
    if (existing.isEmpty) {
      for (final workout in SeedData.defaultWorkouts()) {
        await save(workout);
      }
    }
  }

  @override
  Future<List<Workout>> getAll() async {
    final raw = await _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Workout.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<Workout?> getById(String id) async {
    final all = await getAll();
    for (final w in all) {
      if (w.id == id) return w;
    }
    return null;
  }

  @override
  Future<void> save(Workout workout) async {
    final all = await getAll();
    final index = all.indexWhere((w) => w.id == workout.id);
    if (index >= 0) {
      all[index] = workout;
    } else {
      all.add(workout);
    }
    await _persist(all);
  }

  @override
  Future<void> delete(String id) async {
    final all = await getAll()
      ..removeWhere((w) => w.id == id);
    await _persist(all);
  }

  Future<void> _persist(List<Workout> workouts) async {
    final encoded = jsonEncode(workouts.map((w) => w.toJson()).toList());
    await _store.setString(_key, encoded);
  }
}
