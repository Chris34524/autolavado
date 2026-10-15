import 'package:autolavado_app/features/services/models/wash_service.dart';

// PROVISIONAL: datos de ejemplo para desarrollo.
// Nombres, precios y duraciones NO son definitivos.
// Este archivo se eliminará cuando los servicios vengan de Firestore.
const List<WashService> sampleServices = [
  WashService(
    id: 'demo-1',
    name: 'Servicio de ejemplo A',
    description: 'Descripción provisional del servicio A.',
    priceCents: 15000,
    durationMinutes: 30,
    sortOrder: 1,
  ),
  WashService(
    id: 'demo-2',
    name: 'Servicio de ejemplo B',
    description: 'Descripción provisional del servicio B.',
    priceCents: 30000,
    durationMinutes: 60,
    availableAtHome: true,
    sortOrder: 2,
  ),
  WashService(
    id: 'demo-3',
    name: 'Servicio de ejemplo C',
    description: 'Descripción provisional del servicio C.',
    priceCents: 55000,
    durationMinutes: 90,
    availableAtHome: true,
    sortOrder: 3,
  ),
  WashService(
    id: 'demo-4',
    name: 'Servicio inactivo (prueba)',
    description: 'Este no debe aparecer en la lista del cliente.',
    priceCents: 10000,
    durationMinutes: 20,
    isActive: false,
    sortOrder: 4,
  ),
];