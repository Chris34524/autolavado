import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

/// Un intervalo ya ocupado por una cita, incluyendo su margen.
///
/// No contiene datos personales (nombre, teléfono, placas):
/// por eso cualquier cliente puede leerlo sin ver datos de otros.
class BookedInterval {
  const BookedInterval({required this.range, required this.location});

  final TimeRange range;
  final ServiceLocation location;
}

/// Un intervalo que el administrador bloqueó
/// (mantenimiento, falta de personal, evento...).
class BlockedInterval {
  const BlockedInterval({required this.range, this.location, this.reason});

  final TimeRange range;

  /// null = bloquea local y domicilio.
  final ServiceLocation? location;

  final String? reason;

  bool appliesTo(ServiceLocation other) => location == null || location == other;
}

/// Todo lo que ocupa o bloquea un día.
/// Representa el documento occupancy/{YYYY-MM-DD} de Firestore.
class DayOccupancy {
  const DayOccupancy({
    this.bookings = const [],
    this.blocks = const [],
    this.closedAllDay = false,
  });

  /// Día sin citas ni bloqueos.
  static const empty = DayOccupancy();

  final List<BookedInterval> bookings;
  final List<BlockedInterval> blocks;

  /// Día no laborable completo (por ejemplo, un día festivo).
  final bool closedAllDay;
}
