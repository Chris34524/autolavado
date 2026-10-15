import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

class DateSelectionScreen extends StatelessWidget {
  const DateSelectionScreen({
    super.key,
    required this.service,
  });

  /// El servicio que el cliente eligió en la pantalla anterior.
  final WashService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige fecha y hora'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: Text(service.name),
                subtitle: Text(
                  '${formatDuration(service.durationMinutes)} · '
                  '${formatMxn(service.priceCents)}',
                ),
              ),
            ),
            const SizedBox(height: 32),
            // PROVISIONAL: aquí irá el selector de fecha y horarios disponibles.
            const Text(
              'Aquí irá el calendario',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}