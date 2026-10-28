import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/domain/booking_confirmation.dart';

/// Mensaje que el cliente envía al negocio para confirmar su reserva.
String bookingWhatsappMessage(BookingConfirmation confirmation) {
  final draft = confirmation.draft;
  final address = draft.address;

  final lines = [
    'Hola, acabo de reservar en la app:',
    'Folio: ${confirmation.folio}',
    'Servicio: ${draft.service.name}',
    'Fecha: ${formatLongDate(draft.date!)}, ${formatClock(draft.startMinutes!)}',
    'Lugar: ${draft.location.label}',
    if (address != null) 'Dirección: ${address.singleLine}',
    if (address?.references != null) 'Referencias: ${address!.references}',
    'Vehículo: ${draft.vehicle!.type.label}, ${draft.vehicle!.description}',
    'Nombre: ${draft.customer!.name}',
  ];
  return lines.join('\n');
}
