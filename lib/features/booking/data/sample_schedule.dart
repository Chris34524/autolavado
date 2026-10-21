import 'package:autolavado_app/features/booking/domain/business_schedule.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

// PROVISIONAL: reglas del negocio para desarrollo.
// Ningún valor es definitivo; se confirmarán con el negocio y se moverán
// a Firestore (tarea #21). Este archivo se eliminará entonces.

// PROVISIONAL: 9:00-14:00 y 15:00-18:00 (comida 14:00-15:00).
final List<TimeRange> _provisionalDay = [
  TimeRange(minutesOf(9), minutesOf(14)),
  TimeRange(minutesOf(15), minutesOf(18)),
];

final BusinessSchedule sampleSchedule = BusinessSchedule(
  // PROVISIONAL: lunes a sábado; domingo cerrado (sin entrada).
  openingHours: {
    DateTime.monday: _provisionalDay,
    DateTime.tuesday: _provisionalDay,
    DateTime.wednesday: _provisionalDay,
    DateTime.thursday: _provisionalDay,
    DateTime.friday: _provisionalDay,
    DateTime.saturday: _provisionalDay,
  },
  capacity: const {
    ServiceLocation.shop: 2, // PROVISIONAL: autos simultáneos en el local
    ServiceLocation.home: 1, // PROVISIONAL: equipos a domicilio
  },
  bufferMinutes: const {
    ServiceLocation.shop: 10, // PROVISIONAL: limpieza entre autos
    ServiceLocation.home: 30, // PROVISIONAL: traslado entre domicilios
  },
  slotIntervalMinutes: 30, // PROVISIONAL
  minLeadTimeMinutes: 60, // PROVISIONAL
  bookingWindowDays: 30, // PROVISIONAL
);
