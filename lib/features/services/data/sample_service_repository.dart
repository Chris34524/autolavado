import 'package:autolavado_app/features/services/data/sample_services.dart';
import 'package:autolavado_app/features/services/data/service_repository.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

/// PROVISIONAL: implementación con datos de ejemplo en memoria.
/// Se reemplazará por FirestoreServiceRepository.
class SampleServiceRepository implements ServiceRepository {
  @override
  Future<List<WashService>> getActiveServices() async {
    // Simula la espera de una red real para ver el estado "cargando".
    await Future.delayed(const Duration(milliseconds: 800));

    final services = sampleServices.where((s) => s.isActive).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return services;
  }
}
