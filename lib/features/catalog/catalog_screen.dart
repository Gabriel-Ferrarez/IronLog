import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/exercise.dart';
import '../app_state.dart';

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
      appBar: AppBar(title: const Text('Catálogo de exercícios')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              key: const Key('catalog_search'),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Buscar exercício...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
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
                    child: Text('Nenhum exercício encontrado.',
                        style: TextStyle(color: AppTheme.textMuted)),
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
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.surfaceHigh,
          child: Icon(Icons.fitness_center, color: AppTheme.lime, size: 20),
        ),
        title: Text(exercise.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${exercise.muscleGroup.label} · ${exercise.equipment}'),
      ),
    );
  }
}
