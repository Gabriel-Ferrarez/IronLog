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
        title: const Text('MEUS TREINOS'),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.panel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LabelPill(text: workout.label),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  workout.name.toUpperCase(),
                  style: AppTheme.heavyTitle.copyWith(fontSize: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final we in workout.exercises)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      app.exercise(we.exerciseId)?.name ?? we.exerciseId,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  Text(
                    '${we.targetSets}×${we.targetReps}',
                    style: const TextStyle(
                      color: AppTheme.textDim,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LogSessionScreen(workout: workout),
                ),
              ),
              child: const Text('INICIAR TREINO'),
            ),
          ),
        ],
      ),
    );
  }
}
