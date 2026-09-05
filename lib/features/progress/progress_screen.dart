import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/session.dart';
import '../../utils/format.dart';
import '../../widgets/common.dart';
import '../app_state.dart';
import 'progress_view_model.dart';

/// Tela de progresso: gráfico de evolução do volume + histórico de sessões.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final vm = ProgressViewModel(app.sessions);

    return Scaffold(
      appBar: AppBar(title: const Text('Progresso')),
      body: vm.isEmpty
          ? _empty()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        value: '${vm.totalSessions}',
                        label: 'sessões',
                        icon: Icons.event_available,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        value: formatVolume(vm.totalVolume),
                        label: 'volume total',
                        icon: Icons.fitness_center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        value: formatVolume(vm.bestVolume),
                        label: 'melhor sessão',
                        icon: Icons.emoji_events,
                        accent: AppTheme.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionTitle('Evolução do volume'),
                const SizedBox(height: 16),
                SizedBox(height: 220, child: _Chart(points: vm.volumePoints)),
                const SizedBox(height: 24),
                const SectionTitle('Histórico'),
                const SizedBox(height: 8),
                for (final session in app.sessions)
                  _HistoryTile(session: session),
              ],
            ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights, size: 56, color: AppTheme.textMuted),
            SizedBox(height: 16),
            Text(
              'Ainda não há sessões registradas.\nInicie um treino para ver sua evolução.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final List<ProgressPoint> points;

  const _Chart({required this.points});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].volume),
    ];

    return LineChart(
      LineChartData(
        minY: 0,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 44)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.lime,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.lime.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final WorkoutSession session;

  const _HistoryTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final workout = app.workoutById(session.workoutId);
    final d = session.date;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: LabelPill(
          text: workout?.label ?? '?',
          color: AppTheme.lime,
        ),
        title: Text(workout?.name ?? 'Treino',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$dateStr · ${session.totalSets} séries'),
        trailing: Text(
          formatVolume(session.totalVolume),
          style: const TextStyle(
              fontWeight: FontWeight.w800, color: AppTheme.lime),
        ),
      ),
    );
  }
}
