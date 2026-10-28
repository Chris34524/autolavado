import 'package:autolavado_app/features/booking/domain/home_address.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

/// Borrador de la reserva que el cliente va armando paso a paso.
///
/// Es inmutable: cada paso crea un borrador NUEVO con lo que se agregó.
/// Solo cuando el backend la acepte se convertirá en una cita real.
class BookingDraft {
  const BookingDraft({
    required this.service,
    this.location = ServiceLocation.shop,
    this.address,
    this.date,
    this.startMinutes,
  });

  final WashService service;

  /// Dónde se hace el servicio. Por defecto, en el local.
  final ServiceLocation location;

  /// Dirección. Solo existe cuando [location] es a domicilio.
  final HomeAddress? address;

  /// Día elegido, sin hora. null = todavía no elige.
  final DateTime? date;

  /// Hora de inicio en minutos desde medianoche (hora del negocio).
  /// null = todavía no elige.
  final int? startMinutes;

  bool get hasDate => date != null;
  bool get hasStartTime => startMinutes != null;

  /// Fecha y hora de inicio juntas, o null si falta alguna.
  DateTime? get startDateTime {
    final d = date;
    final m = startMinutes;
    if (d == null || m == null) return null;
    return DateTime(d.year, d.month, d.day, m ~/ 60, m % 60);
  }

  /// Cambia dónde se hace el servicio.
  ///
  /// A domicilio exige [address]. En el local, la dirección se descarta.
  /// Borra la hora: la disponibilidad depende del lugar.
  BookingDraft withLocation(ServiceLocation newLocation, {HomeAddress? address}) {
    final allowed = switch (newLocation) {
      ServiceLocation.shop => service.availableAtShop,
      ServiceLocation.home => service.availableAtHome,
    };
    if (!allowed) {
      throw ArgumentError(
          '${service.name} no está disponible: ${newLocation.label}');
    }

    final isHome = newLocation == ServiceLocation.home;
    if (isHome && (address == null || !address.isComplete)) {
      throw ArgumentError('Para servicio a domicilio se necesita la dirección.');
    }

    return BookingDraft(
      service: service,
      location: newLocation,
      address: isHome ? address : null,
      date: date,
    );
  }

  /// Cambia el día. Borra la hora: la hora elegida era de otro día.
  BookingDraft withDate(DateTime newDate) {
    return BookingDraft(
      service: service,
      location: location,
      address: address,
      date: DateTime(newDate.year, newDate.month, newDate.day),
    );
  }

  /// Elige la hora de inicio. Requiere haber elegido día antes.
  BookingDraft withStartTime(int minutes) {
    if (date == null) {
      throw StateError('Primero se debe elegir el día.');
    }
    return BookingDraft(
      service: service,
      location: location,
      address: address,
      date: date,
      startMinutes: minutes,
    );
  }
}
