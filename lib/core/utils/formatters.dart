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