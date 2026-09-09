import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/exercise.dart';
import 'exercise_detail_view_model.dart';

/// Tela de detalhe do exercício.
class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseDetailViewModel(exercise: widget.exercise),
      child: Builder(
        builder: (context) {
          final vm = context.watch<ExerciseDetailViewModel>();
          return Scaffold(
            appBar: AppBar(
              title: Text(vm.exercise.name.toUpperCase()),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Cabeçalho com informações básicas
                  _buildHeader(vm),
                  const SizedBox(height: 24),

                  /// Descrição
                  _buildSection(
                    title: 'SOBRE',
                    child: Text(
                      vm.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.text,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Grupos musculares afetados
                  _buildSection(
                    title: 'GRUPOS MUSCULARES',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMuscleTag(
                          vm.exercise.muscleGroup.label,
                          primary: true,
                        ),
                        const SizedBox(height: 8),
                        if (vm.secondaryMuscles.isNotEmpty) ...[
                          const Text(
                            'Secundários:',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textFaint,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final muscle in vm.secondaryMuscles)
                                _buildMuscleTag(muscle),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Equipamento
                  _buildSection(
                    title: 'EQUIPAMENTO',
                    child: Text(
                      vm.exercise.equipment.isNotEmpty
                          ? vm.exercise.equipment
                          : 'Sem equipamento',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Dicas de execução
                  _buildSection(
                    title: 'DICAS DE EXECUÇÃO',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < vm.tips.length; i++) ...[
                          _buildTipItem(i + 1, vm.tips[i]),
                          if (i < vm.tips.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Botão de ação (usar exercício)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${vm.exercise.name} adicionado ao treino',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('USAR ESTE EXERCÍCIO'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ExerciseDetailViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: AppTheme.panel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.exercise.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.whatshot,
                size: 16,
                color: AppTheme.accent.withOpacity(0.8),
              ),
              const SizedBox(width: 6),
              Text(
                vm.exercise.muscleGroup.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textFaint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textFaint,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildMuscleTag(String label, {bool primary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primary
            ? AppTheme.accent.withOpacity(0.15)
            : Colors.grey.withOpacity(0.1),
        border: Border.all(
          color: primary
              ? AppTheme.accent.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primary ? AppTheme.accent : AppTheme.text,
        ),
      ),
    );
  }

  Widget _buildTipItem(int number, String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppTheme.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Rota de navegação para o detalhe do exercício.
class ExerciseDetailRoute {
  static Route<void> build(Exercise exercise) => MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(exercise: exercise),
      );
}
