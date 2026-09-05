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
        const SnackBar(content: Text('REGISTRE AO MENOS UMA SÉRIE.')),
      );
      return;
    }
    await app.addSession(vm.buildSession());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('TREINO REGISTRADO')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SessionViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text(workout.name.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
        children: [
          for (final we in workout.exercises)
            _ExerciseCard(exerciseId: we.exerciseId, target: we),
        ],
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
          color: AppTheme.bg,
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${vm.totalSets}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('SÉRIES', style: AppTheme.label),
                        Text(
                          formatVolume(vm.totalVolume),
                          style: const TextStyle(
                            color: AppTheme.textDim,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _finish(context),
              child: const Text('CONCLUIR'),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.panel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (exercise?.name ?? widget.exerciseId).toUpperCase(),
            style: AppTheme.heavyTitle.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            'META ${widget.target.targetSets}×${widget.target.targetReps}'
            '${exercise != null ? ' · ${exercise.muscleGroup.label.toUpperCase()}' : ''}',
            style: AppTheme.label,
          ),
          if (sets.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < sets.length; i++)
                  _SetChip(
                    reps: sets[i].reps,
                    weight: sets[i].weightKg,
                    onRemove: () => context
                        .read<SessionViewModel>()
                        .removeSet(widget.exerciseId, i),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'REPS',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'CARGA (KG)',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 52,
                width: 52,
                child: ElevatedButton(
                  onPressed: _add,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bloco de uma série registrada: número em destaque + remover.
class _SetChip extends StatelessWidget {
  final int reps;
  final double weight;
  final VoidCallback onRemove;

  const _SetChip({
    required this.reps,
    required this.weight,
    required this.onRemove,
  });

  String get _weightLabel {
    if (weight == weight.roundToDouble()) return '${weight.round()}kg';
    return '${weight.toStringAsFixed(1).replaceAll('.', ',')}kg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        border: Border.all(color: AppTheme.borderStrong),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$reps',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: AppTheme.text,
            ),
          ),
          Text(
            ' × $_weightLabel',
            style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, size: 15, color: AppTheme.textFaint),
            ),
          ),
        ],
      ),
    );
  }
}
