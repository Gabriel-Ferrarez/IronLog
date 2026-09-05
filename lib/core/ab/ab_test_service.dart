import 'experiment.dart';
import 'hashing.dart';
import 'variant.dart';

/// Serviço de atribuição de variantes de teste A/B.
///
/// A atribuição é **determinística**: dada a mesma dupla
/// (experimento, unidade), o resultado é sempre o mesmo. Isso garante uma
/// experiência consistente para o usuário e torna o comportamento 100%
/// testável (não depende de sorteio aleatório).
class AbTestService {
  const AbTestService();

  /// Retorna a variante do [experiment] para a unidade [unitId]
  /// (normalmente o id do usuário ou do dispositivo).
  Variant assign(Experiment experiment, String unitId) {
    final double bucket = hashToUnitInterval('${experiment.key}:$unitId');
    // bucket ∈ [0, 1). Se weightB = 0, nunca cai em B; se weightB = 1,
    // sempre cai em B — as bordas ficam corretas.
    return bucket < experiment.weightB ? Variant.b : Variant.a;
  }
}
