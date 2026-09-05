import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/workout.dart';
import '../../utils/format.dart';
import '../app_state.dart';
import 'session_view_model.dart';

/// Tela para registrar as séries (repetições × carga) de cada exercício
/// do treino e concluir a sessão.
class LogSessionScreen extends StatelessWidget {
  final Workout workout;

  const LogSessionScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SessionViewModel(workout),
      child: _LogSessionView(workout: workout),
    );
  }
}

class _LogSessionView extends StatelessWidget {
  final Workout workout;

  const _LogSessionView({required this.workout});

  Future<void> _finish(BuildContext context) async {
    final vm = context.read<SessionViewModel>();
    final app = context.read<AppState>();
    if (!vm.hasAnySet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registre ao menos uma série.')),
      );
      return;
    }
    await app.addSession(vm.buildSession());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Treino registrado! 🎉')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SessionViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          for (final we in workout.exercises)
            _ExerciseCard(exerciseId: we.exerciseId, target: we),
        ],
      ),
      bottomSheet: Container(
        color: AppTheme.surface,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${vm.totalSets} séries',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text('Volume: ${formatVolume(vm.totalVolume)}',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _finish(context),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Concluir'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  final String exerciseId;
  final WorkoutExercise target;

  const _ExerciseCard({required this.exerciseId, required this.target});

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _add() {
    final reps = int.tryParse(_repsController.text.trim()) ?? 0;
    final weight =
        double.tryParse(_weightController.text.trim().replaceAll(',', '.')) ??
            0;
    if (reps <= 0) return;
    context.read<SessionViewModel>().addSet(widget.exerciseId, reps, weight);
    _repsController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SessionViewModel>();
    final app = context.read<AppState>();
    final exercise = app.exercise(widget.exerciseId);
    final sets = vm.setsOf(widget.exerciseId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise?.name ?? widget.exerciseId,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text(
              'Meta: ${widget.target.targetSets}×${widget.target.targetReps}'
              '${exercise != null ? ' · ${exercise.muscleGroup.label}' : ''}',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            if (sets.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < sets.length; i++)
                    InputChip(
                      label: Text(
                          '${sets[i].reps}× ${_fmtWeight(sets[i].weightKg)}'),
                      onDeleted: () => context
                          .read<SessionViewModel>()
                          .removeSet(widget.exerciseId, i),
                    ),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Carga (kg)',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtWeight(double kg) {
    if (kg == kg.roundToDouble()) return '${kg.round()}kg';
    return '${kg.toStringAsFixed(1).replaceAll('.', ',')}kg';
  }
}
