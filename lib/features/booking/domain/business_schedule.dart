import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

/// Reglas de operación del negocio que afectan la disponibilidad.
///
/// Es Dart puro (sin Flutter ni Firebase). Más adelante se construirá
/// a partir de la configuración guardada en Firestore (tarea #21).
class BusinessSchedule {
  const BusinessSchedule({
    required this.openingHours,
    required this.capacity,
    this.bufferMinutes = const {},
    this.slotIntervalMinutes = 30,
    this.minLeadTimeMinutes = 60,
    this.bookingWindowDays = 30,
  }) : assert(slotIntervalMinutes > 0);

  /// Rangos abiertos por día de la semana
  /// (DateTime.monday = 1 ... DateTime.sunday = 7).
  /// La comida es el hueco entre dos rangos. Un día sin rangos está cerrado.
  final Map<int, List<TimeRange>> openingHours;

  /// Cuántos servicios simultáneos admite cada tipo.
  final Map<ServiceLocation, int> capacity;

  /// Minutos extra que ocupa cada cita después del servicio:
  /// limpieza en el local, traslado a domicilio.
  final Map<ServiceLocation, int> bufferMinutes;

  /// Cada cuántos minutos se ofrece un horario de inicio.
  final int slotIntervalMinutes;

  /// No se puede reservar con menos de esta anticipación.
  final int minLeadTimeMinutes;

  /// Hasta cuántos días hacia adelante se puede reservar (hoy = día 0).
  final int bookingWindowDays;

  List<TimeRange> openRangesFor(int weekday) =>
      openingHours[weekday] ?? const [];

  bool isOpenOn(int weekday) => openRangesFor(weekday).isNotEmpty;

  int capacityFor(ServiceLocation location) => capacity[location] ?? 0;

  int bufferFor(ServiceLocation location) => bufferMinutes[location] ?? 0;
}
