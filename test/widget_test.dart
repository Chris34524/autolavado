import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:autolavado_app/main.dart';

void main() {
  testWidgets('La app arranca y muestra el botón de reservar', (tester) async {
    await initializeDateFormatting('es_MX');
    await tester.pumpWidget(const AutolavadoApp());
    expect(find.text('Reservar lavado'), findsOneWidget);
  });
}
