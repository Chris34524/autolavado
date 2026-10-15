import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/screens/date_selection_screen.dart';
import 'package:autolavado_app/features/services/data/sample_services.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Solo servicios activos, ordenados por sortOrder.
    final services = sampleServices.where((s) => s.isActive).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu servicio'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _ServiceCard(
            service: service,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DateSelectionScreen(service: service),
                ),
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