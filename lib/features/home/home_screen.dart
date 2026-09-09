import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ab/variant.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/workout.dart';
import '../../utils/format.dart';
import '../../widgets/common.dart';
import '../app_state.dart';
import '../session/log_session_screen.dart';
import 'home_view_model.dart';

/// Tela inicial (painel do aluno). É a superfície do experimento A/B:
/// o layout da chamada para iniciar o treino muda conforme a variante.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Registra a exposição após o primeiro frame (fora da fase de build).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().onScreenViewed();
    });
  }

  void _startWorkout(Workout workout) {
    context.read<HomeViewModel>().onStartWorkout();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LogSessionScreen(workout: workout)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final vm = context.watch<HomeViewModel>();
    final workout = app.todaysWorkout;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            _header(app),
            const SizedBox(height: 28),
            _statsRow(app),
            const SizedBox(height: 28),
            if (workout != null)
              vm.variant == Variant.a
                  ? _variantAHero(workout)
                  : _variantBCompact(workout, app.streak)
            else
              _noWorkout(),
            const SizedBox(height: 24),
            _experimentTag(vm.variant),
          ],
        ),
      ),
    );
  }

  Widget _header(AppState app) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Image.asset(
      'assets/images/ironlogo.png',
      width: 220,
      height: 80,
      fit: BoxFit.contain,
    ),
    const SizedBox(height: 4),
    Text('PAINEL DE TREINO', style: AppTheme.label),
  ],
),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: AppTheme.panel(),
          child: Row(
            children: [
              Text(
                '${app.streak}',
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'DIAS\nSEQ.',
                style: AppTheme.label.copyWith(fontSize: 9, height: 1.1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsRow(AppState app) {
    return Row(
      children: [
        Expanded(
          child: StatTile(value: '${app.streak}', label: 'dias seguidos'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatTile(
            value: '${app.sessionsThisWeek}',
            label: 'treinos / semana',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatTile(
            value: formatVolume(app.totalVolume),
            label: 'volume total',
          ),
        ),
      ],
    );
  }

  // ---- Variante A (controle): bloco-herói com botão grande ----
  Widget _variantAHero(Workout workout) {
    return Container(
      key: const Key('home_variant_a'),
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.panel(borderColor: AppTheme.borderStrong),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TREINO DE HOJE',
            style: AppTheme.label.copyWith(color: AppTheme.accent),
          ),
          const SizedBox(height: 12),
          Text(
            workout.name.toUpperCase(),
            style: AppTheme.heavyTitle.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 8),
          Text('${workout.exerciseCount} EXERCÍCIOS', style: AppTheme.label),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('start_workout_button'),
              onPressed: () => _startWorkout(workout),
              child: const Text('INICIAR TREINO'),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Variante B (tratamento): linha compacta + botão de largura total ----
  Widget _variantBCompact(Workout workout, int streak) {
    return Column(
      key: const Key('home_variant_b'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Panel(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              LabelPill(text: workout.label),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.heavyTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text('SEQUÊNCIA: $streak DIAS', style: AppTheme.label),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          key: const Key('start_workout_button'),
          onPressed: () => _startWorkout(workout),
          child: const Text('INICIAR TREINO'),
        ),
      ],
    );
  }

  Widget _noWorkout() {
    return const Panel(
      child: Text('NENHUM TREINO CADASTRADO.', style: AppTheme.label),
    );
  }

  Widget _experimentTag(Variant variant) {
    return Center(
      child: Text(
        'EXPERIMENTO A/B · VARIANTE ${variant.label}',
        style: AppTheme.label.copyWith(color: AppTheme.textFaint),
      ),
    );
  }
}
