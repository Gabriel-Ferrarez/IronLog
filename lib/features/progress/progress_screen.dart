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
      appBar: AppBar(title: const Text('PROGRESSO')),
      body: vm.isEmpty
          ? _empty()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        value: '${vm.totalSessions}',
                        label: 'sessões',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatTile(
                        value: formatVolume(vm.totalVolume),
                        label: 'volume total',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatTile(
                        value: formatVolume(vm.bestVolume),
                        label: 'melhor sessão',
                        emphasize: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const SectionTitle('Evolução do volume'),
                const SizedBox(height: 18),
                Container(
                  height: 230,
                  padding: const EdgeInsets.fromLTRB(8, 18, 16, 8),
                  decoration: AppTheme.panel(),
                  child: _Chart(points: vm.volumePoints),
                ),
                const SizedBox(height: 28),
                const SectionTitle('Histórico'),
                const SizedBox(height: 12),
                for (final session in app.sessions)
                  _HistoryTile(session: session),
              ],
            ),
    );
  }

  Widget _empty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.show_chart, size: 48, color: AppTheme.textFaint),
            const SizedBox(height: 18),
            Text(
              'SEM SESSÕES REGISTRADAS.\nINICIE UM TREINO PARA VER A EVOLUÇÃO.',
              textAlign: TextAlign.center,
              style: AppTheme.label.copyWith(height: 1.6),
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
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: null,
        ),
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
            isCurved: false,
            color: AppTheme.accent,
            barWidth: 2.5,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.accent.withValues(alpha: 0.10),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.panel(),
      child: Row(
        children: [
          LabelPill(text: workout?.label ?? '?'),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (workout?.name ?? 'Treino').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.heavyTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 3),
                Text('$dateStr · ${session.totalSets} SÉRIES',
                    style: AppTheme.label.copyWith(fontSize: 10)),
              ],
            ),
          ),
          Text(
            formatVolume(session.totalVolume),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: AppTheme.text,
            ),
          ),
        ],
      ),
    );
  }
}
