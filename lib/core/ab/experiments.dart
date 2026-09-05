import 'experiment.dart';

/// Catálogo de experimentos ativos no app.
///
/// Centralizar aqui facilita a apresentação: é o único lugar onde os
/// testes A/B do produto são declarados.
class Experiments {
  Experiments._();

  /// Testa qual layout da tela inicial gera mais "inícios de treino".
  ///
  /// - Variante A (controle): card grande com botão de destaque.
  /// - Variante B (tratamento): resumo compacto + barra fixa inferior.
  static const homeCta = Experiment(
    key: 'home_cta_layout',
    description: 'Layout da chamada para iniciar o treino na tela inicial',
    weightB: 0.5,
  );

  static const all = <Experiment>[homeCta];
}
