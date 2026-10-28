import 'package:autolavado_app/features/booking/data/booking_repository.dart';
import 'package:autolavado_app/features/booking/domain/booking_confirmation.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/booking_status.dart';

/// PROVISIONAL: simula el registro de una reserva.
///
/// NO guarda nada ni aparta el horario: es solo para recorrer el flujo.
/// Se reemplazará por la versión que llama a la Cloud Function (tarea #27).
class SampleBookingRepository implements BookingRepository {
  @override
  Future<BookingConfirmation> submit(BookingDraft draft) async {
    if (!draft.isComplete) {
      throw ArgumentError('La reserva está incompleta.');
    }

    // Simula la espera del servidor.
    await Future.delayed(const Duration(milliseconds: 800));

    // PROVISIONAL: folio de demostración. El real lo dará el backend.
    final number = DateTime.now().millisecondsSinceEpoch % 1000000;
    return BookingConfirmation(
      folio: 'DEMO-${number.toString().padLeft(6, '0')}',
      status: BookingStatus.pending,
      draft: draft,
    );
  }
}
