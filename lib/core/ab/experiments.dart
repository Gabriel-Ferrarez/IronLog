import 'experiment.dart';

/// Catálogo de experimentos ativos no app.
///
/// Centralizar aqui facilita a apresentação: é o único lugar onde os
/// testes A/B do produto são declarados.
class Experiments {
  Experiments._();

  /// Testa qual chamada da tela inicial gera mais "inícios de treino".
  ///
  /// - Variante A (controle): card-herói com botão de destaque.
  /// - Variante B (tratamento): resumo compacto com barra fixa inferior.
  static const homeCta = Experiment(
    key: 'home_cta_layout',
    description:
        'Comparação entre card-herói e barra fixa para iniciar o treino',
    weightB: 0.5,
  );

  static const all = <Experiment>[homeCta];
}
