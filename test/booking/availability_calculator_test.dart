import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/booking/domain/availability_calculator.dart';
import 'package:autolavado_app/features/booking/domain/business_schedule.dart';
import 'package:autolavado_app/features/booking/domain/occupancy.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

// Horario SOLO para pruebas (independiente de los valores provisionales).
// Lunes 9:00-14:00 y 15:00-18:00. Local: 2 lugares, sin margen.
// Domicilio: 1 equipo, 30 min de traslado.
final schedule = BusinessSchedule(
  openingHours: {
    DateTime.monday: [
      TimeRange(minutesOf(9), minutesOf(14)),
      TimeRange(minutesOf(15), minutesOf(18)),
    ],
  },
  capacity: const {ServiceLocation.shop: 2, ServiceLocation.home: 1},
  bufferMinutes: const {ServiceLocation.home: 30},
  slotIntervalMinutes: 30,
  minLeadTimeMinutes: 60,
  bookingWindowDays: 30,
);

final calculator = AvailabilityCalculator(schedule);

final monday = DateTime(2026, 10, 26);
final tuesday = DateTime(2026, 10, 27);
final aWeekBefore = DateTime(2026, 10, 19, 8, 0);

/// Intervalo escrito como horas: range(10, 0, 11, 30) = 10:00-11:30.
TimeRange range(int h1, int m1, int h2, int m2) =>
    TimeRange(minutesOf(h1, m1), minutesOf(h2, m2));

BookedInterval shopBooking(TimeRange r) =>
    BookedInterval(range: r, location: ServiceLocation.shop);

BookedInterval homeBooking(TimeRange r) =>
    BookedInterval(range: r, location: ServiceLocation.home);

/// Atajo: por defecto lunes, una semana antes, 60 min, en local, día vacío.
List<int> slots({
  DateTime? day,
  DateTime? now,
  int duration = 60,
  ServiceLocation location = ServiceLocation.shop,
  DayOccupancy occupancy = DayOccupancy.empty,
}) {
  return calculator.availableStartTimes(
    day: day ?? monday,
    now: now ?? aWeekBefore,
    durationMinutes: duration,
    location: location,
    occupancy: occupancy,
  );
}

void main() {
  group('Horario del negocio', () {
    test('día libre: 14 horarios y ninguno cruza la comida', () {
      final s = slots();
      expect(s.length, 14);
      expect(s.first, minutesOf(9));
      expect(s.last, minutesOf(17));
      expect(s, contains(minutesOf(13))); // 13:00-14:00 cabe justo
      expect(s, isNot(contains(minutesOf(13, 30)))); // cruzaría la comida
      expect(s, contains(minutesOf(15)));
    });

    test('un servicio largo solo cabe si termina antes de la comida', () {
      final s = slots(duration: 120);
      expect(s, contains(minutesOf(12)));
      expect(s, isNot(contains(minutesOf(12, 30))));
    });

    test('día de la semana cerrado', () {
      expect(slots(day: tuesday), isEmpty);
    });

    test('día cerrado completo (festivo)', () {
      expect(slots(occupancy: const DayOccupancy(closedAllDay: true)), isEmpty);
    });
  });

  group('Fechas permitidas', () {
    test('no se puede reservar en el pasado', () {
      expect(slots(now: DateTime(2026, 10, 27, 8, 0)), isEmpty);
    });

    test('ventana de 30 días', () {
      expect(slots(now: DateTime(2026, 9, 26, 8, 0)), isNotEmpty); // 30 días
      expect(slots(now: DateTime(2026, 9, 25, 8, 0)), isEmpty); // 31 días
    });

    test('anticipación mínima de 60 minutos', () {
      // Son las 10:10 → lo más pronto es 11:10 → primer horario 11:30.
      final s = slots(now: DateTime(2026, 10, 26, 10, 10));
      expect(s.first, minutesOf(11, 30));
    });
  });

  group('Capacidad', () {
    test('con 2 autos de 10:00 a 11:00 el local está lleno en ese tramo', () {
      final s = slots(
        occupancy: DayOccupancy(bookings: [
          shopBooking(range(10, 0, 11, 0)),
          shopBooking(range(10, 0, 11, 0)),
        ]),
      );
      expect(s, contains(minutesOf(9))); // 9:00-10:00 termina justo a tiempo
      expect(s, isNot(contains(minutesOf(9, 30))));
      expect(s, isNot(contains(minutesOf(10))));
      expect(s, isNot(contains(minutesOf(10, 30))));
      expect(s, contains(minutesOf(11)));
    });

    test('caso X/Y: dos citas que nunca coinciden dejan lugar', () {
      // X 10:00-10:30 e Y 11:00-12:00 no están al mismo tiempo.
      // Nueva cita de 90 min a las 10:00 (hasta 11:30): sí cabe.
      final s = slots(
        duration: 90,
        occupancy: DayOccupancy(bookings: [
          shopBooking(range(10, 0, 10, 30)),
          shopBooking(range(11, 0, 12, 0)),
        ]),
      );
      expect(s, contains(minutesOf(10)));
    });

    test('caso X/Y + Z: ahora sí se llena', () {
      final s = slots(
        duration: 90,
        occupancy: DayOccupancy(bookings: [
          shopBooking(range(10, 0, 10, 30)),
          shopBooking(range(11, 0, 12, 0)),
          shopBooking(range(10, 0, 12, 0)),
        ]),
      );
      expect(s, isNot(contains(minutesOf(10))));
    });

    test('local y domicilio tienen capacidad independiente', () {
      final occupancy =
          DayOccupancy(bookings: [homeBooking(range(10, 0, 11, 0))]);
      expect(slots(occupancy: occupancy), contains(minutesOf(10)));
      expect(
        slots(occupancy: occupancy, location: ServiceLocation.home),
        isNot(contains(minutesOf(10))),
      );
    });
  });

  group('Margen de traslado a domicilio', () {
    test('la cita nueva incluye 30 min de traslado', () {
      // Cita existente 10:00-11:00 + 30 min de traslado = ocupa hasta 11:30.
      final s = slots(
        location: ServiceLocation.home,
        occupancy: DayOccupancy(bookings: [homeBooking(range(10, 0, 11, 30))]),
      );
      expect(s, isNot(contains(minutesOf(9)))); // 9:00 + 60 + 30 = 10:30
      expect(s, isNot(contains(minutesOf(11))));
      expect(s, contains(minutesOf(11, 30)));
    });
  });

  group('Bloqueos del administrador', () {
    test('bloqueo de 12:00 a 13:00 para todo el negocio', () {
      final s = slots(
        occupancy: DayOccupancy(
          blocks: [BlockedInterval(range: range(12, 0, 13, 0))],
        ),
      );
      expect(s, contains(minutesOf(11))); // 11:00-12:00 termina justo
      expect(s, isNot(contains(minutesOf(11, 30))));
      expect(s, isNot(contains(minutesOf(12))));
      expect(s, contains(minutesOf(13)));
    });

    test('bloqueo solo de domicilio no afecta al local', () {
      final occupancy = DayOccupancy(blocks: [
        BlockedInterval(
          range: range(12, 0, 13, 0),
          location: ServiceLocation.home,
        ),
      ]);
      expect(slots(occupancy: occupancy), contains(minutesOf(12)));
      expect(
        slots(occupancy: occupancy, location: ServiceLocation.home),
        isNot(contains(minutesOf(12))),
      );
    });
  });

  group('maxConcurrent', () {
    test('citas contiguas no se suman', () {
      expect(
        AvailabilityCalculator.maxConcurrent(
          const [TimeRange(600, 630), TimeRange(630, 660)],
          const TimeRange(600, 660),
        ),
        1,
      );
    });

    test('citas encimadas sí se suman', () {
      expect(
        AvailabilityCalculator.maxConcurrent(
          const [TimeRange(600, 660), TimeRange(630, 690)],
          const TimeRange(600, 690),
        ),
        2,
      );
    });
  });

  group('isStartTimeAvailable', () {
    test('valida con las mismas reglas', () {
      bool check(int start) => calculator.isStartTimeAvailable(
            startMinutes: start,
            day: monday,
            now: aWeekBefore,
            durationMinutes: 60,
            location: ServiceLocation.shop,
            occupancy: DayOccupancy.empty,
          );
      expect(check(minutesOf(10)), isTrue);
      expect(check(minutesOf(10, 10)), isFalse); // no es un horario ofrecido
      expect(check(minutesOf(13, 30)), isFalse); // cruza la comida
    });
  });
}
