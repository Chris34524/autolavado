import 'package:autolavado_app/features/booking/data/occupancy_repository.dart';
import 'package:autolavado_app/features/booking/data/sample_occupancy_repository.dart';
import 'package:autolavado_app/features/booking/data/sample_schedule.dart';
import 'package:autolavado_app/features/booking/domain/business_schedule.dart';
import 'package:autolavado_app/features/services/data/sample_service_repository.dart';
import 'package:autolavado_app/features/services/data/service_repository.dart';

// PROVISIONAL: instancias globales. Más adelante usaremos un gestor de
// estado (probablemente Riverpod) para entregar dependencias de forma
// más limpia y testeable. Para cambiar a Firestore, solo se cambia
// la clase de la derecha.

final ServiceRepository serviceRepository = SampleServiceRepository();

// PROVISIONAL: reglas del negocio; vendrán de Firestore (tarea #21).
final BusinessSchedule businessSchedule = sampleSchedule;

// PROVISIONAL: se reemplazará por FirestoreOccupancyRepository.
final OccupancyRepository occupancyRepository = SampleOccupancyRepository();
