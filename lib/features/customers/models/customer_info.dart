import 'package:autolavado_app/core/utils/validators.dart';

/// Datos de contacto del cliente para una reserva.
///
/// Solo lo necesario para atenderlo y avisarle (protección de datos).
class CustomerInfo {
  const CustomerInfo({
    required this.name,
    required this.phone,
    this.whatsapp,
    this.email,
  });

  /// Crea los datos a partir de lo que escribió el cliente.
  ///
  /// Los teléfonos se guardan normalizados a 10 dígitos.
  /// Debe llamarse solo después de validar el formulario.
  factory CustomerInfo.fromInput({
    required String name,
    required String phone,
    String? whatsapp,
    String? email,
  }) {
    final normalizedPhone = normalizeMxPhone(phone);
    if (normalizedPhone == null) {
      throw ArgumentError('Teléfono inválido: $phone');
    }

    // WhatsApp solo se guarda si es un número DISTINTO al teléfono.
    final normalizedWhatsapp =
        whatsapp == null ? null : normalizeMxPhone(whatsapp);
    final trimmedEmail = email?.trim();

    return CustomerInfo(
      name: name.trim(),
      phone: normalizedPhone,
      whatsapp: normalizedWhatsapp == normalizedPhone ? null : normalizedWhatsapp,
      email: (trimmedEmail == null || trimmedEmail.isEmpty) ? null : trimmedEmail,
    );
  }

  final String name;

  /// 10 dígitos, sin espacios. Ejemplo: "5512345678".
  final String phone;

  /// Solo si es distinto de [phone]. null = su WhatsApp es [phone].
  final String? whatsapp;

  /// Opcional.
  final String? email;

  /// El número al que escribiremos por WhatsApp.
  String get whatsappNumber => whatsapp ?? phone;
}
