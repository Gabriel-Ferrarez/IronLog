import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/workout.dart';
import '../../widgets/common.dart';
import '../app_state.dart';
import '../catalog/catalog_screen.dart';
import '../session/log_session_screen.dart';

/// Lista os treinos do usuário (A/B/C). Permite iniciar uma sessão e
/// abrir o catálogo de exercícios.
class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus treinos'),
        actions: [
          IconButton(
            tooltip: 'Catálogo',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CatalogScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          for (final workout in app.workouts) _WorkoutCard(workout: workout),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LabelPill(text: workout.label, color: AppTheme.lime),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    workout.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final we in workout.exercises)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 6, color: AppTheme.textMuted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        app.exercise(we.exerciseId)?.name ?? we.exerciseId,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${we.targetSets}×${we.targetReps}',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LogSessionScreen(workout: workout),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Iniciar treino'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
