import 'package:autolavado_app/features/booking/data/occupancy_repository.dart';
import 'package:autolavado_app/features/booking/domain/occupancy.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

/// PROVISIONAL: ocupación de ejemplo en memoria.
/// Se reemplazará por FirestoreOccupancyRepository.
class SampleOccupancyRepository implements OccupancyRepository {
  @override
  Future<DayOccupancy> getDayOccupancy(DateTime day) async {
    // Simula la espera de la red para ver el estado "cargando".
    await Future.delayed(const Duration(milliseconds: 600));

    // PROVISIONAL: citas de demostración, iguales para todos los días,
    // para ver el efecto de la capacidad: el local (2 lugares) está
    // lleno de 10:00 a 11:10 (servicio + limpieza).
    return DayOccupancy(
      bookings: [
        BookedInterval(
          range: TimeRange(minutesOf(10), minutesOf(11, 10)),
          location: ServiceLocation.shop,
        ),
        BookedInterval(
          range: TimeRange(minutesOf(10), minutesOf(11, 10)),
          location: ServiceLocation.shop,
        ),
      ],
    );
  }
}
