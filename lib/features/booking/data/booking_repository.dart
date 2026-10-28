import 'package:autolavado_app/features/booking/domain/booking_confirmation.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';

/// Contrato: registrar una reserva.
///
/// Con Firebase, la implementación llamará a la Cloud Function
/// createBooking, que valida la disponibilidad en una transacción.
abstract class BookingRepository {
  /// Registra [draft] (debe estar completo) y devuelve la confirmación.
  /// Falla si el horario ya no está disponible.
  Future<BookingConfirmation> submit(BookingDraft draft);
}
