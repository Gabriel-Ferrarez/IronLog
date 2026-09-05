/// Variante de um teste A/B.
///
/// [a] é normalmente o grupo de controle e [b] o grupo de tratamento.
enum Variant {
  a,
  b;

  /// Rótulo curto para exibição ("A" ou "B").
  String get label => this == Variant.a ? 'A' : 'B';
}
