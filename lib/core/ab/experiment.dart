/// Configuração de um experimento (teste A/B).
class Experiment {
  /// Identificador único do experimento (usado no hash e na análise).
  final String key;

  /// Descrição legível do que está sendo testado.
  final String description;

  /// Fração de usuários destinada à variante B, no intervalo [0, 1].
  ///
  /// Ex.: 0.5 = divisão 50/50; 0.3 = 30% em B e 70% em A.
  final double weightB;

  const Experiment({
    required this.key,
    this.description = '',
    this.weightB = 0.5,
  }) : assert(
          weightB >= 0 && weightB <= 1,
          'weightB precisa estar entre 0 e 1',
        );
}
