import 'package:intl/intl.dart';

/// Convierte centavos a texto en pesos mexicanos.
/// 35000 -> "$350"   |   35050 -> "$350.50"
String formatMxn(int cents) {
  final hasCents = cents % 100 != 0;
  final format = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: hasCents ? 2 : 0,
  );
  return format.format(cents / 100);
}

/// Convierte minutos a texto legible.
/// 45 -> "45 min"   |   60 -> "1 h"   |   90 -> "1 h 30 min"
String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return '$rest min';
  if (rest == 0) return '$hours h';
  return '$hours h $rest min';
}

/// Fecha larga en español de México, con mayúscula inicial.
/// 2026-10-21 -> "Miércoles 21 de octubre"
String formatLongDate(DateTime date) {
  final text = DateFormat("EEEE d 'de' MMMM", 'es_MX').format(date);
  return text[0].toUpperCase() + text.substring(1);
}

/// Hora del día (minutos desde medianoche) en formato de 12 horas.
/// 630 -> "10:30 a. m."   |   900 -> "3:00 p. m."
String formatClock(int minutesSinceMidnight) {
  final hour24 = minutesSinceMidnight ~/ 60;
  final minute = minutesSinceMidnight % 60;
  final suffix = hour24 < 12 ? 'a. m.' : 'p. m.';
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  return '$hour12:${minute.toString().padLeft(2, '0')} $suffix';
}

/// Teléfono de 10 dígitos en formato fácil de leer.
/// "5512345678" -> "55 1234 5678"
String formatMxPhone(String tenDigits) {
  if (tenDigits.length != 10) return tenDigits;
  return '${tenDigits.substring(0, 2)} '
      '${tenDigits.substring(2, 6)} '
      '${tenDigits.substring(6)}';
}
