import 'dart:math';

import 'package:autolavado_app/features/booking/domain/business_schedule.dart';
import 'package:autolavado_app/features/booking/domain/occupancy.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

/// Calcula qué horarios se pueden reservar.
///
/// Las mismas reglas se repetirán en la Cloud Function createBooking,
/// que es la que valida de forma definitiva dentro de una transacción.
class AvailabilityCalculator {
  const AvailabilityCalculator(this.schedule);

  final BusinessSchedule schedule;

  /// Horarios de inicio disponibles, en minutos desde medianoche
  /// (hora del negocio), ordenados de menor a mayor.
  ///
  /// [day]: día consultado (se ignora la hora).
  /// [now]: fecha y hora actuales del negocio.
  List<int> availableStartTimes({
    required DateTime day,
    required DateTime now,
    required int durationMinutes,
    required ServiceLocation location,
    required DayOccupancy occupancy,
  }) {
    final daysAhead = _daysBetween(now, day);
    if (daysAhead < 0 || daysAhead > schedule.bookingWindowDays) return [];
    if (occupancy.closedAllDay) return [];

    final capacity = schedule.capacityFor(location);
    if (capacity <= 0 || durationMinutes <= 0) return [];

    // Primer minuto permitido en el día consultado.
    // Si el día es futuro, el resultado es negativo y no limita nada.
    final earliestStart = minutesOf(now.hour, now.minute) +
        schedule.minLeadTimeMinutes -
        daysAhead * minutesPerDay;

    final buffer = schedule.bufferFor(location);
    final booked = occupancy.bookings
        .where((b) => b.location == location)
        .map((b) => b.range)
        .toList();
    final blocked = occupancy.blocks
        .where((b) => b.appliesTo(location))
        .map((b) => b.range)
        .toList();

    final result = <int>[];
    for (final open in schedule.openRangesFor(day.weekday)) {
      for (var start = open.start;
          start + durationMinutes <= open.end;
          start += schedule.slotIntervalMinutes) {
        if (start < earliestStart) continue;

        // Lo que la cita ocupa realmente: servicio + margen.
        final occupied = TimeRange(start, start + durationMinutes + buffer);

        if (blocked.any((b) => b.overlaps(occupied))) continue;
        if (maxConcurrent(booked, occupied) + 1 > capacity) continue;

        result.add(start);
      }
    }
    result.sort();
    return result;
  }

  /// Validación de un horario concreto con exactamente las mismas reglas.
  bool isStartTimeAvailable({
    required int startMinutes,
    required DateTime day,
    required DateTime now,
    required int durationMinutes,
    required ServiceLocation location,
    required DayOccupancy occupancy,
  }) {
    return availableStartTimes(
      day: day,
      now: now,
      durationMinutes: durationMinutes,
      location: location,
      occupancy: occupancy,
    ).contains(startMinutes);
  }

  /// Cuántos [intervals] se ocupan AL MISMO TIEMPO, como máximo,
  /// dentro de [window].
  ///
  /// No es lo mismo que contar cuántos se cruzan con [window]:
  /// dos citas que se cruzan con la ventana pero nunca entre sí
  /// solo ocupan un lugar a la vez.
  static int maxConcurrent(List<TimeRange> intervals, TimeRange window) {
    // Cada evento es (minuto, cambio): +1 cuando entra un auto, -1 cuando sale.
    final events = <(int, int)>[];
    for (final r in intervals) {
      if (!r.overlaps(window)) continue;
      events.add((max(r.start, window.start), 1));
      events.add((min(r.end, window.end), -1));
    }

    // Por minuto; en empate, primero las salidas: una cita que termina
    // a las 10:30 libera su lugar para la que empieza a las 10:30.
    events.sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));

    var current = 0;
    var peak = 0;
    for (final (_, change) in events) {
      current += change;
      if (current > peak) peak = current;
    }
    return peak;
  }

  /// Días de calendario entre las fechas de [from] y [to] (ignora horas).
  static int _daysBetween(DateTime from, DateTime to) {
    final a = DateTime.utc(from.year, from.month, from.day);
    final b = DateTime.utc(to.year, to.month, to.day);
    return b.difference(a).inDays;
  }
}
