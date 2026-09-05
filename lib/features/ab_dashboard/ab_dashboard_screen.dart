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
import '../../widgets/common.dart';

/// Cor de cada variante: A é neutra (controle), B usa o destaque único.
Color _variantColor(Variant v) =>
    v == Variant.b ? AppTheme.accent : AppTheme.textDim;

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
      appBar: AppBar(title: const Text('EXPERIMENTO A/B')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _explanationCard(_experiment),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _VariantCard(
                  variant: Variant.a,
                  title: 'Bloco-herói',
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
          const SizedBox(height: 14),
          _WinnerBanner(rateA: rateA, rateB: rateB, expA: expA, expB: expB),
          const SizedBox(height: 28),
          const SectionTitle('Comparação da conversão'),
          const SizedBox(height: 14),
          _RateBar(
              label: 'VARIANTE A',
              rate: rateA,
              color: _variantColor(Variant.a)),
          const SizedBox(height: 12),
          _RateBar(
              label: 'VARIANTE B',
              rate: rateB,
              color: _variantColor(Variant.b)),
          const SizedBox(height: 28),
          _simulationCard(context),
        ],
      ),
    );
  }

  Widget _explanationCard(Experiment experiment) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experiment.key,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(height: 10),
          Text(experiment.description,
              style: const TextStyle(color: AppTheme.textDim)),
          const SizedBox(height: 10),
          Text(
            'DIVISÃO ${formatPercent(1 - experiment.weightB)} A · '
            '${formatPercent(experiment.weightB)} B',
            style: AppTheme.label,
          ),
        ],
      ),
    );
  }

  Widget _simulationCard(BuildContext context) {
    return Panel(
      color: AppTheme.surfaceAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DEMONSTRAÇÃO', style: AppTheme.label),
          const SizedBox(height: 8),
          const Text(
            'Simula usuários entrando no app para popular as métricas '
            'ou limpa os dados registrados.',
            style: TextStyle(color: AppTheme.textDim, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _simulate(context, 100),
                  child: const Text('SIMULAR 100 USUÁRIOS'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Zerar métricas',
                onPressed: () => _clearMetrics(context),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                style: IconButton.styleFrom(
                  side: const BorderSide(color: AppTheme.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                ),
              ),
            ],
          ),
        ],
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

/// Reseta todas as métricas acumuladas do experimento A/B.
  void _clearMetrics(BuildContext context) {
    final analytics = context.read<AbAnalytics>();
    analytics.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Métricas zeradas com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
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
    final color = _variantColor(variant);
    final exposures = analytics.exposures(experimentKey, variant);
    final conversions = analytics.conversions(experimentKey, variant);
    final rate = analytics.conversionRate(experimentKey, variant);
    final isB = variant == Variant.b;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.panel(
        borderColor: isB ? AppTheme.accent : AppTheme.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isB ? AppTheme.accent : AppTheme.surfaceAlt,
                  border: Border.all(
                      color: isB ? AppTheme.accent : AppTheme.borderStrong),
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                ),
                child: Text(
                  variant.label,
                  style: TextStyle(
                    color: isB ? AppTheme.onAccent : AppTheme.text,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title.toUpperCase(),
                    style: AppTheme.label.copyWith(fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatPercent(rate),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
              color: color,
            ),
          ),
          Text('CONVERSÃO', style: AppTheme.label.copyWith(fontSize: 9)),
          const SizedBox(height: 10),
          Text('$conversions / $exposures',
              style: const TextStyle(fontSize: 12, color: AppTheme.textDim)),
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
        text: 'COLETE MAIS DADOS PARA COMPARAR.',
        color: AppTheme.textDim,
      );
    }
    if ((rateA - rateB).abs() < 0.0001) {
      return _banner(
        icon: Icons.balance,
        text: 'EMPATE TÉCNICO ENTRE A E B.',
        color: AppTheme.textDim,
      );
    }
    final bWins = rateB > rateA;
    return _banner(
      icon: Icons.emoji_events,
      text: bWins
          ? 'VARIANTE B LIDERA · ${formatPercent(rateB)} VS ${formatPercent(rateA)}'
          : 'VARIANTE A LIDERA · ${formatPercent(rateA)} VS ${formatPercent(rateB)}',
      color: bWins ? AppTheme.accent : AppTheme.text,
    );
  }

  Widget _banner({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(
            color: color == AppTheme.textDim ? AppTheme.border : color),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
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

  const _RateBar({
    required this.label,
    required this.rate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.label),
            Text(formatPercent(rate),
                style: TextStyle(fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: LinearProgressIndicator(
            value: rate.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: AppTheme.surfaceAlt,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
