import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/exercise.dart';
import '../app_state.dart';
import '../exercise_detail/exercise_detail_screen.dart';

/// Catálogo de exercícios com busca por nome e filtro por grupo muscular.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _query = '';
  MuscleGroup? _group;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AppState>().exerciseRepo;
    var results = repo.search(_query);
    if (_group != null) {
      results = results.where((e) => e.muscleGroup == _group).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('CATÁLOGO')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TextField(
              key: const Key('catalog_search'),
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Buscar exercício',
                prefixIcon: Icon(Icons.search, color: AppTheme.textFaint),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _groupChip(null, 'Todos'),
                for (final g in MuscleGroup.values) _groupChip(g, g.label),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Text('NENHUM EXERCÍCIO ENCONTRADO.',
                        style: AppTheme.label),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _ExerciseTile(exercise: results[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _groupChip(MuscleGroup? group, String label) {
    final selected = _group == group;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _group = group),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        ExerciseDetailRoute.build(exercise),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: AppTheme.panel(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${exercise.muscleGroup.label} · ${exercise.equipment}'
                        .toUpperCase(),
                    style: AppTheme.label.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(Icons.fitness_center, color: AppTheme.textFaint, size: 18),
          ],
        ),
      ),
    );
  }
}
