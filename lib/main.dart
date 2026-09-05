import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/ab/ab_analytics.dart';
import 'data/exercise_repository.dart';
import 'data/key_value_store.dart';
import 'data/session_repository.dart';
import 'data/workout_repository.dart';
import 'features/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final store = await _openStore();
  final userId = await _ensureUserId(store);

  // Repositórios.
  const exerciseRepo = SeedExerciseRepository();
  final workoutRepo = StoredWorkoutRepository(store);
  await workoutRepo.seedIfEmpty();
  final sessionRepo = StoredSessionRepository(store);

  // Estado do app.
  final appState = AppState(
    exerciseRepo: exerciseRepo,
    workoutRepo: workoutRepo,
    sessionRepo: sessionRepo,
    userId: userId,
  );
  await appState.load();

  // Métricas do teste A/B (carrega o acumulado e persiste a cada mudança).
  final analytics = await _loadAnalytics(store);
  analytics.addListener(() {
    store.setString('ab_analytics', jsonEncode(analytics.toJson()));
  });

  runApp(IronLogApp(
    appState: appState,
    analytics: analytics,
    userId: userId,
  ));
}

/// Abre o armazenamento local; se indisponível (ex.: navegador sem
/// localStorage), cai para memória para que o app nunca quebre no boot.
Future<KeyValueStore> _openStore() async {
  try {
    return await SharedPrefsStore.create();
  } catch (e) {
    debugPrint('Persistência indisponível, usando memória: $e');
    return InMemoryKeyValueStore();
  }
}

/// Recupera (ou cria e salva) um id estável para este usuário/dispositivo.
Future<String> _ensureUserId(KeyValueStore store) async {
  const key = 'user_id';
  final existing = await store.getString(key);
  if (existing != null && existing.isNotEmpty) return existing;
  // Limite seguro em web (JS trunca deslocamentos em 32 bits) e no VM.
  final id = 'user_${DateTime.now().millisecondsSinceEpoch}_'
      '${Random().nextInt(1 << 30)}';
  await store.setString(key, id);
  return id;
}

Future<AbAnalytics> _loadAnalytics(KeyValueStore store) async {
  final raw = await store.getString('ab_analytics');
  if (raw == null || raw.isEmpty) return AbAnalytics();
  try {
    return AbAnalytics.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  } catch (_) {
    return AbAnalytics();
  }
}
