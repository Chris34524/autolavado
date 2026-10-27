import 'package:autolavado_app/features/booking/domain/occupancy.dart';

/// Contrato: obtener lo ocupado y bloqueado de un día.
/// Con Firestore leerá el documento occupancy/{YYYY-MM-DD}.
abstract class OccupancyRepository {
  /// Ocupación de [day] (se ignora la hora).
  Future<DayOccupancy> getDayOccupancy(DateTime day);
}
