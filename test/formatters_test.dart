import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:autolavado_app/core/utils/formatters.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_MX');
  });

  group('formatMxn', () {
    test('sin centavos', () => expect(formatMxn(35000), '\$350'));
    test('con centavos', () => expect(formatMxn(35050), '\$350.50'));
    test('miles', () => expect(formatMxn(125050), '\$1,250.50'));
  });

  group('formatDuration', () {
    test('minutos', () => expect(formatDuration(45), '45 min'));
    test('hora exacta', () => expect(formatDuration(60), '1 h'));
    test('hora y minutos', () => expect(formatDuration(90), '1 h 30 min'));
  });

  group('formatLongDate', () {
    test('fecha en español con mayúscula', () {
      expect(formatLongDate(DateTime(2026, 10, 21)), 'Miércoles 21 de octubre');
    });
  });
}
