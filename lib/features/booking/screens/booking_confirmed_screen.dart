import 'package:flutter/material.dart';

import 'package:autolavado_app/app/business_info.dart';
import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/core/utils/whatsapp.dart';
import 'package:autolavado_app/features/booking/domain/booking_confirmation.dart';
import 'package:autolavado_app/features/booking/domain/whatsapp_message.dart';

/// Final del flujo: la reserva quedó registrada.
class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({
    super.key,
    required this.confirmation,
  });

  final BookingConfirmation confirmation;

  Future<void> _sendWhatsapp(BuildContext context) async {
    final opened = await openWhatsapp(
      tenDigitPhone: businessWhatsappNumber,
      message: bookingWhatsappMessage(confirmation),
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos abrir WhatsApp.')),
      );
    }
  }

  void _goHome(BuildContext context) {
    // Quita todas las pantallas de encima y deja solo el inicio.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final draft = confirmation.draft;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva registrada'),
        // Sin flecha de regreso: la reserva ya se envió.
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                '¡Listo, ${draft.customer!.name}!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu reserva quedó registrada.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  title: Text('Folio ${confirmation.folio}'),
                  subtitle: Text(
                    '${draft.service.name}\n'
                    '${formatLongDate(draft.date!)}, '
                    '${formatClock(draft.startMinutes!)}\n'
                    '${draft.location.label}\n'
                    'Estado: ${confirmation.status.label}',
                  ),
                  isThreeLine: true,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Para confirmarla, envíanos el resumen por WhatsApp.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _sendWhatsapp(context),
                icon: const Icon(Icons.chat),
                label: const Text('Enviar por WhatsApp'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _goHome(context),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
