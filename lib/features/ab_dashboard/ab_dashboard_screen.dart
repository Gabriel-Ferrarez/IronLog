import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/ab/ab_analytics.dart';
import '../../core/ab/ab_test_service.dart';
import '../../core/ab/experiment.dart';
import '../../core/ab/experiments.dart';
import '../../core/ab/variant.dart';
import '../../core/theme/app_theme.dart';
import '../../utils/format.dart';

/// Painel de acompanhamento do teste A/B: exposições, conversões e taxa de
/// conversão de cada variante, atualizados em tempo real.
class AbDashboardScreen extends StatelessWidget {
  const AbDashboardScreen({super.key});

  static const _experiment = Experiments.homeCta;

  @override
  Widget build(BuildContext context) {
    final analytics = context.watch<AbAnalytics>();

    final rateA = analytics.conversionRate(_experiment.key, Variant.a);
    final rateB = analytics.conversionRate(_experiment.key, Variant.b);
    final expA = analytics.exposures(_experiment.key, Variant.a);
    final expB = analytics.exposures(_experiment.key, Variant.b);

    return Scaffold(
      appBar: AppBar(title: const Text('Experimento A/B')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _explanationCard(_experiment),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _VariantCard(
                  variant: Variant.a,
                  title: 'Card-herói',
                  analytics: analytics,
                  experimentKey: _experiment.key,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VariantCard(
                  variant: Variant.b,
                  title: 'Barra fixa',
                  analytics: analytics,
                  experimentKey: _experiment.key,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _WinnerBanner(rateA: rateA, rateB: rateB, expA: expA, expB: expB),
          const SizedBox(height: 24),
          const Text('Comparação da taxa de conversão',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _RateBar(label: 'Variante A', rate: rateA, color: AppTheme.lime),
          const SizedBox(height: 10),
          _RateBar(label: 'Variante B', rate: rateB, color: AppTheme.orange),
          const SizedBox(height: 28),
          _simulationCard(context),
        ],
      ),
    );
  }

  Widget _explanationCard(Experiment experiment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science_outlined, color: AppTheme.lime),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(experiment.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(experiment.description,
                style: const TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 8),
            Text(
              'Divisão: ${formatPercent(1 - experiment.weightB)} A · '
              '${formatPercent(experiment.weightB)} B',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simulationCard(BuildContext context) {
    return Card(
      color: AppTheme.surfaceHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Demonstração',
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
              'Simula usuários entrando no app para popular as métricas '
              'e visualizar o experimento em ação.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _simulate(context, 100),
              icon: const Icon(Icons.groups_outlined),
              label: const Text('Simular 100 usuários'),
            ),
          ],
        ),
      ),
    );
  }

  /// Simula [count] usuários: distribui variantes pelo serviço A/B e converte
  /// com taxas diferentes (A ~30%, B ~45%) para ilustrar um resultado.
  void _simulate(BuildContext context, int count) {
    final analytics = context.read<AbAnalytics>();
    final abTest = context.read<AbTestService>();
    final random = Random();
    for (var i = 0; i < count; i++) {
      final userId = 'sim_${DateTime.now().microsecondsSinceEpoch}_$i';
      final variant = abTest.assign(_experiment, userId);
      analytics.recordExposure(_experiment.key, variant);
      final convertChance = variant == Variant.b ? 0.45 : 0.30;
      if (random.nextDouble() < convertChance) {
        analytics.recordConversion(_experiment.key, variant);
      }
    }
  }
}

class _VariantCard extends StatelessWidget {
  final Variant variant;
  final String title;
  final AbAnalytics analytics;
  final String experimentKey;

  const _VariantCard({
    required this.variant,
    required this.title,
    required this.analytics,
    required this.experimentKey,
  });

  @override
  Widget build(BuildContext context) {
    final color = variant == Variant.a ? AppTheme.lime : AppTheme.orange;
    final exposures = analytics.exposures(experimentKey, variant);
    final conversions = analytics.conversions(experimentKey, variant);
    final rate = analytics.conversionRate(experimentKey, variant);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(variant.label,
                    style: const TextStyle(
                        color: Color(0xFF10130A), fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(formatPercent(rate),
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: color)),
          const Text('conversão',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 10),
          Text('$conversions / $exposures',
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  final double rateA;
  final double rateB;
  final int expA;
  final int expB;

  const _WinnerBanner({
    required this.rateA,
    required this.rateB,
    required this.expA,
    required this.expB,
  });

  @override
  Widget build(BuildContext context) {
    // Sem dados suficientes, não anuncia vencedor.
    if (expA + expB < 10) {
      return _banner(
        icon: Icons.hourglass_empty,
        text: 'Colete mais dados para comparar as variantes.',
        color: AppTheme.textMuted,
      );
    }
    if ((rateA - rateB).abs() < 0.0001) {
      return _banner(
        icon: Icons.balance,
        text: 'Empate técnico entre A e B por enquanto.',
        color: AppTheme.textMuted,
      );
    }
    final bWins = rateB > rateA;
    return _banner(
      icon: Icons.emoji_events,
      text: bWins
          ? 'Variante B lidera (${formatPercent(rateB)} vs ${formatPercent(rateA)}).'
          : 'Variante A lidera (${formatPercent(rateA)} vs ${formatPercent(rateB)}).',
      color: bWins ? AppTheme.orange : AppTheme.lime,
    );
  }

  Widget _banner(
      {required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _RateBar extends StatelessWidget {
  final String label;
  final double rate;
  final Color color;

  const _RateBar(
      {required this.label, required this.rate, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text(formatPercent(rate),
                style: TextStyle(fontWeight: FontWeight.w800, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: rate.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: AppTheme.surfaceHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
