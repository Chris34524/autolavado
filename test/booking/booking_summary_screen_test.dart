import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/home_address.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';
import 'package:autolavado_app/features/booking/screens/booking_summary_screen.dart';
import 'package:autolavado_app/features/customers/models/customer_info.dart';
import 'package:autolavado_app/features/customers/models/vehicle_info.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_MX');
  });

  testWidgets('el resumen muestra todo lo que eligió el cliente',
      (tester) async {
    final draft = const BookingDraft(
      service: WashService(
        id: 'test',
        name: 'Lavado de prueba',
        description: 'Prueba',
        priceCents: 30000,
        durationMinutes: 60,
        availableAtHome: true,
      ),
    )
        .withLocation(
          ServiceLocation.home,
          address: const HomeAddress(
            street: 'Av. Juárez 123',
            neighborhood: 'Centro',
          ),
        )
        .withDate(DateTime(2026, 11, 3))
        .withStartTime(minutesOf(10, 30))
        .withDetails(
          customer: const CustomerInfo(name: 'Ana', phone: '5512345678'),
          vehicle: const VehicleInfo(
            type: VehicleType.car,
            brand: 'Nissan',
            model: 'Versa',
            color: 'gris',
          ),
        );

    // Dibuja la pantalla dentro de una app mínima, como en un celular.
    await tester.pumpWidget(MaterialApp(home: BookingSummaryScreen(draft: draft)));

    expect(find.textContaining('Lavado de prueba'), findsOneWidget);
    expect(find.textContaining('Martes 3 de noviembre'), findsOneWidget);
    expect(find.textContaining('10:30 a. m. a 11:30 a. m.'), findsOneWidget);
    expect(find.textContaining('Av. Juárez 123, Centro'), findsOneWidget);
    expect(find.textContaining('Nissan Versa gris'), findsOneWidget);
    expect(find.textContaining('55 1234 5678'), findsOneWidget);
    expect(find.text('\$300'), findsOneWidget);
    expect(find.text('Confirmar reserva'), findsOneWidget);
  });
}
