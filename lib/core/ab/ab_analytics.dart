import 'package:flutter/foundation.dart';

import 'variant.dart';

/// Contadores de uma variante: quantas vezes foi exibida (exposições)
/// e quantas vezes converteu (o usuário realizou a ação-alvo).
class VariantStats {
  int exposures;
  int conversions;

  VariantStats({this.exposures = 0, this.conversions = 0});

  /// Taxa de conversão no intervalo [0, 1]. Retorna 0 se não houve exposição
  /// (evita divisão por zero).
  double get conversionRate => exposures == 0 ? 0 : conversions / exposures;

  Map<String, dynamic> toJson() => {
        'exposures': exposures,
        'conversions': conversions,
      };

  factory VariantStats.fromJson(Map<String, dynamic> json) => VariantStats(
        exposures: (json['exposures'] as num?)?.toInt() ?? 0,
        conversions: (json['conversions'] as num?)?.toInt() ?? 0,
      );
}

/// Coleta métricas dos experimentos: exposições e conversões por variante.
///
/// É um [ChangeNotifier] para que a tela do painel A/B se atualize sozinha
/// quando um número muda. A lógica de contagem é pura e independente de
/// persistência, o que a torna simples de testar.
class AbAnalytics extends ChangeNotifier {
  final Map<String, Map<Variant, VariantStats>> _data;

  AbAnalytics([Map<String, Map<Variant, VariantStats>>? initial])
      : _data = initial ?? <String, Map<Variant, VariantStats>>{};

  VariantStats statsFor(String experimentKey, Variant variant) =>
      _ref(experimentKey, variant);

  int exposures(String experimentKey, Variant variant) =>
      _ref(experimentKey, variant).exposures;

  int conversions(String experimentKey, Variant variant) =>
      _ref(experimentKey, variant).conversions;

  double conversionRate(String experimentKey, Variant variant) =>
      _ref(experimentKey, variant).conversionRate;

  /// Registra que a variante foi exibida ao usuário.
  void recordExposure(String experimentKey, Variant variant) {
    _ref(experimentKey, variant).exposures++;
    notifyListeners();
  }

  /// Registra que a variante levou o usuário à ação-alvo (conversão).
  void recordConversion(String experimentKey, Variant variant) {
    _ref(experimentKey, variant).conversions++;
    notifyListeners();
  }

  void clear() {
  // Limpe aqui o mapa/estrutura de dados interna da classe
  // Exemplo: _exposures.clear(); _conversions.clear();
  notifyListeners();
}

  VariantStats _ref(String experimentKey, Variant variant) {
    final byVariant = _data.putIfAbsent(experimentKey, () => {});
    return byVariant.putIfAbsent(variant, VariantStats.new);
  }

  Map<String, dynamic> toJson() => {
        for (final entry in _data.entries)
          entry.key: {
            for (final v in entry.value.entries) v.key.name: v.value.toJson(),
          },
      };

  factory AbAnalytics.fromJson(Map<String, dynamic> json) {
    final data = <String, Map<Variant, VariantStats>>{};
    json.forEach((experimentKey, variants) {
      final byVariant = <Variant, VariantStats>{};
      (variants as Map).forEach((variantName, stats) {
        final variant = Variant.values.firstWhere(
          (v) => v.name == variantName,
          orElse: () => Variant.a,
        );
        byVariant[variant] =
            VariantStats.fromJson(Map<String, dynamic>.from(stats as Map));
      });
      data[experimentKey] = byVariant;
    });
    return AbAnalytics(data);
  }
}
