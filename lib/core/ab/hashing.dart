import 'dart:convert';

/// Hash FNV-1a de 32 bits.
///
/// Determinístico e estável entre plataformas (web, Android, iOS, desktop),
/// o que é essencial para um teste A/B: o mesmo usuário sempre cai no mesmo
/// "balde" (bucket), independentemente do dispositivo.
int fnv1a32(String input) {
  const int fnvPrime = 0x01000193;
  int hash = 0x811c9dc5; // offset basis
  for (final int byte in utf8.encode(input)) {
    hash ^= byte;
    hash = (hash * fnvPrime) & 0xffffffff; // mantém 32 bits
  }
  return hash;
}

/// Converte uma string em um número real no intervalo semiaberto [0, 1).
///
/// Usado para decidir a variante: se o valor cair abaixo do peso da
/// variante B, o usuário recebe B; caso contrário, A.
double hashToUnitInterval(String input) {
  return fnv1a32(input) / 0x100000000; // divide por 2^32
}
