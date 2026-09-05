import 'package:flutter/foundation.dart';

import '../../core/ab/ab_analytics.dart';
import '../../core/ab/ab_test_service.dart';
import '../../core/ab/experiment.dart';
import '../../core/ab/variant.dart';

/// Controla a tela inicial e o experimento A/B do layout de chamada (CTA).
///
/// Fluxo do experimento:
/// 1. No construtor, a variante do usuário é decidida (determinística).
/// 2. [onScreenViewed] registra a exposição uma única vez.
/// 3. [onStartWorkout] registra a conversão quando o usuário inicia o treino.
class HomeViewModel extends ChangeNotifier {
  final AbTestService abTest;
  final AbAnalytics analytics;
  final Experiment experiment;
  final String userId;

  late final Variant variant;
  bool _exposed = false;

  HomeViewModel({
    required this.abTest,
    required this.analytics,
    required this.experiment,
    required this.userId,
  }) {
    variant = abTest.assign(experiment, userId);
  }

  /// Deve ser chamado quando a tela aparece. Conta a exposição só uma vez.
  void onScreenViewed() {
    if (_exposed) return;
    _exposed = true;
    analytics.recordExposure(experiment.key, variant);
  }

  /// Ação-alvo do experimento: o usuário iniciou o treino.
  void onStartWorkout() {
    analytics.recordConversion(experiment.key, variant);
  }
}
