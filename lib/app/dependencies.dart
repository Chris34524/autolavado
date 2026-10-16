import 'package:autolavado_app/features/services/data/sample_service_repository.dart';
import 'package:autolavado_app/features/services/data/service_repository.dart';

// PROVISIONAL: instancia global del repositorio.
// Para cambiar a Firestore, solo se cambia la clase de la derecha.
// Más adelante usaremos un gestor de estado (probablemente Riverpod)
// para entregar dependencias de forma más limpia y testeable.
final ServiceRepository serviceRepository = SampleServiceRepository();
