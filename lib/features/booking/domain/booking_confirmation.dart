import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/booking_status.dart';

/// Resultado de registrar una reserva.
///
/// Cuando llegue el backend, el folio y el estado los asignará
/// la Cloud Function createBooking, nunca la app.
class BookingConfirmation {
  const BookingConfirmation({
    required this.folio,
    required this.status,
    required this.draft,
  });

  /// Identificador que el cliente puede mencionar (por WhatsApp, en el local).
  final String folio;

  final BookingStatus status;

  /// Lo que el cliente reservó.
  final BookingDraft draft;
}
