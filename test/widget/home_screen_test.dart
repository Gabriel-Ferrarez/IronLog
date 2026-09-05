import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/ab/ab_analytics.dart';
import 'package:gym_tracker/core/ab/ab_test_service.dart';
import 'package:gym_tracker/core/ab/experiment.dart';
import 'package:gym_tracker/core/theme/app_theme.dart';
import 'package:gym_tracker/data/exercise_repository.dart';
import 'package:gym_tracker/data/key_value_store.dart';
import 'package:gym_tracker/data/session_repository.dart';
import 'package:gym_tracker/data/workout_repository.dart';
import 'package:gym_tracker/features/app_state.dart';
import 'package:gym_tracker/features/home/home_screen.dart';
import 'package:gym_tracker/features/home/home_view_model.dart';
import 'package:provider/provider.dart';

// Experimentos "forçados" para tornar a variante determinística no teste.
const _forceA = Experiment(key: 'home_cta_layout', weightB: 0);
const _forceB = Experiment(key: 'home_cta_layout', weightB: 1);

Future<AppState> _buildAppState() async {
  final store = InMemoryKeyValueStore();
  final workoutRepo = StoredWorkoutRepository(store);
  await workoutRepo.seedIfEmpty();
  final app = AppState(
    exerciseRepo: const SeedExerciseRepository(),
    workoutRepo: workoutRepo,
    sessionRepo: StoredSessionRepository(store),
    userId: 'test-user',
  );
  await app.load();
  return app;
}

Widget _wrap(AppState app, AbAnalytics analytics, HomeViewModel vm) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AppState>.value(value: app),
      ChangeNotifierProvider<AbAnalytics>.value(value: analytics),
      Provider<AbTestService>.value(value: const AbTestService()),
      ChangeNotifierProvider<HomeViewModel>.value(value: vm),
    ],
    child: MaterialApp(theme: AppTheme.dark, home: const HomeScreen()),
  );
}

void main() {
  testWidgets('Variante A mostra o card-herói e registra a exposição',
      (tester) async {
    final app = await _buildAppState();
    final analytics = AbAnalytics();
    final vm = HomeViewModel(
      abTest: const AbTestService(),
      analytics: analytics,
      experiment: _forceA,
      userId: 'x',
    );

    await tester.pumpWidget(_wrap(app, analytics, vm));
    await tester.pump(); // executa o callback pós-frame (exposição)

    expect(find.byKey(const Key('home_variant_a')), findsOneWidget);
    expect(find.byKey(const Key('home_variant_b')), findsNothing);
    expect(find.text('INICIAR TREINO'), findsOneWidget);
    expect(analytics.exposures('home_cta_layout', vm.variant), 1);
  });

  testWidgets('Variante B mostra o layout compacto', (tester) async {
    final app = await _buildAppState();
    final analytics = AbAnalytics();
    final vm = HomeViewModel(
      abTest: const AbTestService(),
      analytics: analytics,
      experiment: _forceB,
      userId: 'x',
    );

    await tester.pumpWidget(_wrap(app, analytics, vm));
    await tester.pump();

    expect(find.byKey(const Key('home_variant_b')), findsOneWidget);
    expect(find.byKey(const Key('home_variant_a')), findsNothing);
  });

  testWidgets('Tocar em iniciar registra a conversão da variante',
      (tester) async {
    final app = await _buildAppState();
    final analytics = AbAnalytics();
    final vm = HomeViewModel(
      abTest: const AbTestService(),
      analytics: analytics,
      experiment: _forceA,
      userId: 'x',
    );

    await tester.pumpWidget(_wrap(app, analytics, vm));
    await tester.pump();

    await tester.tap(find.byKey(const Key('start_workout_button')));
    await tester.pumpAndSettle();

    expect(analytics.conversions('home_cta_layout', vm.variant), 1);
  });
}
