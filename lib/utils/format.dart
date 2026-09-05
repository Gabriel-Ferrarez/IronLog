/// Formata um número inteiro com ponto como separador de milhar (pt-BR).
/// Ex.: 12480 -> "12.480".
String thousands(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Formata um volume de treino (kg). Acima de 1000 kg usa toneladas.
String formatVolume(double kg) {
  if (kg >= 1000) {
    final tons = kg / 1000;
    return '${tons.toStringAsFixed(1).replaceAll('.', ',')} t';
  }
  return '${thousands(kg)} kg';
}

/// Formata uma porcentagem no intervalo [0, 1]. Ex.: 0.234 -> "23,4%".
String formatPercent(double ratio) {
  final pct = (ratio * 100).toStringAsFixed(1).replaceAll('.', ',');
  return '$pct%';
}
