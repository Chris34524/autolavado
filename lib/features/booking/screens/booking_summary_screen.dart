import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';

/// Último paso antes de confirmar: el cliente revisa todo.
class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({
    super.key,
    required this.draft,
  });

  /// Debe estar completo (draft.isComplete).
  final BookingDraft draft;

  void _confirm(BuildContext context) {
    // PROVISIONAL: en la tarea #17 se registrará la cita y se abrirá
    // WhatsApp; en la Fase 3 la creará el backend con folio real.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La confirmación llega en el siguiente paso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = draft.service;
    final customer = draft.customer!;
    final vehicle = draft.vehicle!;
    final address = draft.address;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisa tu reserva'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummarySection(
                      icon: Icons.local_car_wash,
                      title: 'Servicio',
                      lines: [
                        service.name,
                        'Duración aproximada: '
                            '${formatDuration(service.durationMinutes)}',
                      ],
                    ),
                    _SummarySection(
                      icon: Icons.event,
                      title: 'Cuándo',
                      lines: [
                        formatLongDate(draft.date!),
                        '${formatClock(draft.startMinutes!)} a '
                            '${formatClock(draft.endMinutes!)}',
                      ],
                    ),
                    _SummarySection(
                      icon: draft.location == ServiceLocation.home
                          ? Icons.home
                          : Icons.store,
                      title: 'Dónde',
                      lines: [
                        draft.location.label,
                        if (address != null) address.singleLine,
                        if (address?.references != null)
                          'Referencias: ${address!.references}',
                      ],
                    ),
                    _SummarySection(
                      icon: Icons.directions_car,
                      title: 'Vehículo',
                      lines: [
                        '${vehicle.type.label}: ${vehicle.description}',
                        if (vehicle.plates != null) 'Placas: ${vehicle.plates}',
                      ],
                    ),
                    _SummarySection(
                      icon: Icons.person,
                      title: 'Contacto',
                      lines: [
                        customer.name,
                        'Tel. ${formatMxPhone(customer.phone)}',
                        if (customer.whatsapp != null)
                          'WhatsApp ${formatMxPhone(customer.whatsapp!)}',
                        if (customer.email != null) customer.email!,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: ListTile(
                        title: const Text('Total'),
                        // PROVISIONAL: forma de pago por definir (tarea #46).
                        subtitle: const Text('Pago en el establecimiento'),
                        trailing: Text(
                          formatMxn(service.priceCents),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¿Algo no está bien? Regresa con la flecha ← para '
                      'cambiarlo; no perderás lo que ya escribiste.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => _confirm(context),
                child: const Text('Confirmar reserva'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una sección del resumen: ícono, título y líneas de texto.
class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.icon,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: Theme.of(context).textTheme.labelLarge),
        subtitle: Text(lines.join('\n')),
      ),
    );
  }
}
