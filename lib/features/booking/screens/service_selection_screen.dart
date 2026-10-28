import 'package:flutter/material.dart';

import 'package:autolavado_app/app/dependencies.dart';
import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/screens/date_selection_screen.dart';
import 'package:autolavado_app/features/booking/screens/location_selection_screen.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  late Future<List<WashService>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    // Se pide UNA vez, al abrir la pantalla.
    _servicesFuture = serviceRepository.getActiveServices();
  }

  void _retry() {
    setState(() {
      _servicesFuture = serviceRepository.getActiveServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu servicio'),
      ),
      body: FutureBuilder<List<WashService>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          // 1. Cargando
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No pudimos cargar los servicios.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Datos
          final services = snapshot.data ?? [];

          if (services.isEmpty) {
            return const Center(
              child: Text('Por ahora no hay servicios disponibles.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceCard(
                service: service,
                onTap: () {
                  // Aquí nace el borrador de la reserva.
                  final draft = BookingDraft(service: service);

                  // Si el servicio también va a domicilio, primero
                  // preguntamos dónde; si no, directo a la fecha.
                  final Widget next = service.availableAtHome
                      ? LocationSelectionScreen(draft: draft)
                      : DateSelectionScreen(draft: draft);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => next),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Tarjeta que muestra un servicio. Solo sabe DIBUJAR;
/// qué pasa al tocarla lo decide quien la usa (onTap).
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.onTap,
  });

  final WashService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.local_car_wash, size: 40),
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${service.description}\n'
            '${formatDuration(service.durationMinutes)}'
            '${service.availableAtHome ? ' · También a domicilio' : ''}',
          ),
        ),
        isThreeLine: true,
        trailing: Text(
          formatMxn(service.priceCents),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
