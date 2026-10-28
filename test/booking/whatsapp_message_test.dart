import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:autolavado_app/features/booking/domain/booking_confirmation.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/booking_status.dart';
import 'package:autolavado_app/features/booking/domain/home_address.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';
import 'package:autolavado_app/features/booking/domain/whatsapp_message.dart';
import 'package:autolavado_app/features/customers/models/customer_info.dart';
import 'package:autolavado_app/features/customers/models/vehicle_info.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

const service = WashService(
  id: 'test',
  name: 'Lavado de prueba',
  description: 'Prueba',
  priceCents: 30000,
  durationMinutes: 60,
  availableAtHome: true,
);

BookingDraft completeDraft({bool atHome = false}) {
  var draft = const BookingDraft(service: service);
  if (atHome) {
    draft = draft.withLocation(
      ServiceLocation.home,
      address: const HomeAddress(
        street: 'Av. Juárez 123',
        neighborhood: 'Centro',
        references: 'Portón negro',
      ),
    );
  }
  return draft
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
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_MX');
  });

  test('el mensaje incluye folio, servicio, fecha, vehículo y nombre', () {
    final message = bookingWhatsappMessage(BookingConfirmation(
      folio: 'DEMO-000123',
      status: BookingStatus.pending,
      draft: completeDraft(),
    ));
    expect(message, contains('Folio: DEMO-000123'));
    expect(message, contains('Servicio: Lavado de prueba'));
    expect(message, contains('Martes 3 de noviembre, 10:30 a. m.'));
    expect(message, contains('Lugar: En el local'));
    expect(message, contains('Nissan Versa gris'));
    expect(message, contains('Nombre: Ana'));
    expect(message, isNot(contains('Dirección')));
  });

  test('a domicilio incluye dirección y referencias', () {
    final message = bookingWhatsappMessage(BookingConfirmation(
      folio: 'DEMO-000123',
      status: BookingStatus.pending,
      draft: completeDraft(atHome: true),
    ));
    expect(message, contains('Dirección: Av. Juárez 123, Centro'));
    expect(message, contains('Referencias: Portón negro'));
  });
}
