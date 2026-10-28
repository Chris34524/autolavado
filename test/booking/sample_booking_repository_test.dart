import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/booking/data/sample_booking_repository.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/booking_status.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';
import 'package:autolavado_app/features/customers/models/customer_info.dart';
import 'package:autolavado_app/features/customers/models/vehicle_info.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

const service = WashService(
  id: 'test',
  name: 'Lavado de prueba',
  description: 'Prueba',
  priceCents: 15000,
  durationMinutes: 30,
);

void main() {
  final repository = SampleBookingRepository();

  test('una reserva completa queda pendiente y con folio', () async {
    final draft = const BookingDraft(service: service)
        .withDate(DateTime(2026, 11, 3))
        .withStartTime(minutesOf(10))
        .withDetails(
          customer: const CustomerInfo(name: 'Ana', phone: '5512345678'),
          vehicle: const VehicleInfo(
            type: VehicleType.car,
            brand: 'Nissan',
            model: 'Versa',
            color: 'gris',
          ),
        );

    final confirmation = await repository.submit(draft);
    expect(confirmation.status, BookingStatus.pending);
    expect(confirmation.folio, startsWith('DEMO-'));
    expect(confirmation.draft, draft);
  });

  test('una reserva incompleta se rechaza', () {
    expect(
      repository.submit(const BookingDraft(service: service)),
      throwsArgumentError,
    );
  });
}
