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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _header(app),
            const SizedBox(height: 20),
            _statsRow(app),
            const SizedBox(height: 24),
            if (workout != null)
              vm.variant == Variant.a
                  ? _variantAHero(workout)
                  : _variantBCompact(workout)
            else
              _noWorkout(),
            const SizedBox(height: 20),
            _variantBadge(vm.variant),
          ],
        ),
      ),
    );
  }

  Widget _header(AppState app) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bora treinar 💪',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'IronLog · seu treino, sua evolução',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.orange.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: AppTheme.orange, size: 18),
              const SizedBox(width: 4),
              Text(
                '${app.streak}',
                style: const TextStyle(
                  color: AppTheme.orange,
                  fontWeight: FontWeight.w900,
                ),
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
          child: StatTile(
            value: '${app.streak}',
            label: 'dias seguidos',
            icon: Icons.local_fire_department,
            accent: AppTheme.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatTile(
            value: '${app.sessionsThisWeek}',
            label: 'treinos na semana',
            icon: Icons.event_available,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatTile(
            value: formatVolume(app.totalVolume),
            label: 'volume total',
            icon: Icons.fitness_center,
          ),
        ),
      ],
    );
  }

  // ---- Variante A (controle): card-herói com botão grande ----
  Widget _variantAHero(Workout workout) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF232833), Color(0xFF171A21)],
        ),
        border: Border.all(color: AppTheme.lime.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TREINO DE HOJE',
              style: TextStyle(
                color: AppTheme.lime,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 1.2,
              )),
          const SizedBox(height: 8),
          Text(
            workout.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text('${workout.exerciseCount} exercícios',
              style: const TextStyle(color: AppTheme.textMuted)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              key: const Key('start_workout_button'),
              onPressed: () => _startWorkout(workout),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Iniciar treino de hoje'),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Variante B (tratamento): resumo compacto + barra fixa ----
  Widget _variantBCompact(Workout workout) {
    return Column(
      children: [
        Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: LabelPill(text: workout.label, color: AppTheme.lime),
            title: Text(workout.name,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('${workout.exerciseCount} exercícios · hoje'),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.lime,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, color: Color(0xFF10130A)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Mantenha a sequência! Comece agora.',
                  style: TextStyle(
                    color: Color(0xFF10130A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                key: const Key('start_workout_button'),
                onPressed: () => _startWorkout(workout),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF10130A),
                  foregroundColor: AppTheme.lime,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Iniciar',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _noWorkout() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Nenhum treino cadastrado ainda.'),
      ),
    );
  }

  Widget _variantBadge(Variant variant) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Experimento A/B · você está na variante ${variant.label}',
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
      ),
    );
  }
}
