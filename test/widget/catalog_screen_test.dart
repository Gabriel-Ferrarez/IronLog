import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/data/exercise_repository.dart';
import 'package:gym_tracker/data/key_value_store.dart';
import 'package:gym_tracker/data/session_repository.dart';
import 'package:gym_tracker/data/workout_repository.dart';
import 'package:gym_tracker/features/app_state.dart';
import 'package:gym_tracker/features/catalog/catalog_screen.dart';
import 'package:provider/provider.dart';

Widget _wrap(AppState app) => ChangeNotifierProvider<AppState>.value(
      value: app,
      child: const MaterialApp(home: CatalogScreen()),
    );

void main() {
  late AppState app;

  setUp(() {
    final store = InMemoryKeyValueStore();
    app = AppState(
      exerciseRepo: const SeedExerciseRepository(),
      workoutRepo: StoredWorkoutRepository(store),
      sessionRepo: StoredSessionRepository(store),
      userId: 'u',
    );
  });

  testWidgets('lista os exercícios do catálogo', (tester) async {
    await tester.pumpWidget(_wrap(app));
    // Itens no topo da lista (a ListView é preguiçosa: só constrói o visível).
    expect(find.text('Supino reto'), findsOneWidget);
    expect(find.text('Supino inclinado'), findsOneWidget);
  });

  testWidgets('a busca filtra pelo nome digitado', (tester) async {
    await tester.pumpWidget(_wrap(app));

    await tester.enterText(find.byKey(const Key('catalog_search')), 'rosca');
    await tester.pump();

    expect(find.text('Rosca direta'), findsOneWidget);
    expect(find.text('Supino reto'), findsNothing);
  });

  testWidgets('o filtro por grupo muscular mostra só o grupo escolhido',
      (tester) async {
    await tester.pumpWidget(_wrap(app));

    // Toca no chip "Costas".
    await tester.tap(find.text('Costas'));
    await tester.pump();

    expect(find.text('Puxada frente'), findsOneWidget);
    expect(find.text('Supino reto'), findsNothing);
  });
}
