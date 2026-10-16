import 'package:autolavado_app/features/services/models/wash_service.dart';

/// Contrato: QUÉ datos de servicios puede pedir la app.
/// No dice de dónde vienen; eso lo decide cada implementación.
abstract class ServiceRepository {
  /// Servicios activos, ya ordenados para mostrarse al cliente.
  Future<List<WashService>> getActiveServices();
}
