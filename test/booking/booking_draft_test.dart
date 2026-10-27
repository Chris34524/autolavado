import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

const shopOnly = WashService(
  id: 'test-1',
  name: 'Solo local',
  description: 'Prueba',
  priceCents: 15000,
  durationMinutes: 30,
);

const shopAndHome = WashService(
  id: 'test-2',
  name: 'Local y domicilio',
  description: 'Prueba',
  priceCents: 30000,
  durationMinutes: 60,
  availableAtHome: true,
);

void main() {
  test('un borrador nuevo solo tiene el servicio', () {
    const draft = BookingDraft(service: shopOnly);
    expect(draft.location, ServiceLocation.shop);
    expect(draft.hasDate, isFalse);
    expect(draft.hasStartTime, isFalse);
    expect(draft.startDateTime, isNull);
  });

  test('withDate guarda solo el día, sin hora', () {
    final draft = const BookingDraft(service: shopOnly)
        .withDate(DateTime(2026, 10, 26, 17, 45));
    expect(draft.date, DateTime(2026, 10, 26));
  });

  test('withStartTime completa fecha y hora', () {
    final draft = const BookingDraft(service: shopOnly)
        .withDate(DateTime(2026, 10, 26))
        .withStartTime(minutesOf(10, 30));
    expect(draft.startMinutes, minutesOf(10, 30));
    expect(draft.startDateTime, DateTime(2026, 10, 26, 10, 30));
  });

  test('cambiar la fecha borra la hora', () {
    final draft = const BookingDraft(service: shopOnly)
        .withDate(DateTime(2026, 10, 26))
        .withStartTime(minutesOf(10))
        .withDate(DateTime(2026, 10, 27));
    expect(draft.date, DateTime(2026, 10, 27));
    expect(draft.hasStartTime, isFalse);
  });

  test('no se puede elegir hora sin día', () {
    expect(
      () => const BookingDraft(service: shopOnly).withStartTime(minutesOf(10)),
      throwsStateError,
    );
  });

  test('cambiar a domicilio conserva el día y borra la hora', () {
    final draft = const BookingDraft(service: shopAndHome)
        .withDate(DateTime(2026, 10, 26))
        .withStartTime(minutesOf(10))
        .withLocation(ServiceLocation.home);
    expect(draft.location, ServiceLocation.home);
    expect(draft.date, DateTime(2026, 10, 26));
    expect(draft.hasStartTime, isFalse);
  });

  test('no se puede pedir a domicilio un servicio que no lo ofrece', () {
    expect(
      () => const BookingDraft(service: shopOnly)
          .withLocation(ServiceLocation.home),
      throwsArgumentError,
    );
  });

  test('el borrador original no cambia (inmutable)', () {
    const original = BookingDraft(service: shopOnly);
    final withDay = original.withDate(DateTime(2026, 10, 26));
    expect(original.hasDate, isFalse);
    expect(withDay.hasDate, isTrue);
  });
}
