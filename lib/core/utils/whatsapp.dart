import 'package:url_launcher/url_launcher.dart';

/// Link de WhatsApp con un mensaje ya escrito.
///
/// [tenDigitPhone]: número de México a 10 dígitos. Si es null, WhatsApp
/// deja que el usuario elija el contacto.
/// Ejemplo: https://wa.me/525512345678?text=Hola%20...
Uri whatsappUri({String? tenDigitPhone, required String message}) {
  final path = tenDigitPhone == null ? '' : '52$tenDigitPhone';
  // encodeComponent convierte espacios, acentos y saltos de línea
  // en un formato que viaja seguro dentro de un link.
  return Uri.parse('https://wa.me/$path?text=${Uri.encodeComponent(message)}');
}

/// Abre WhatsApp (app o web). Devuelve false si no se pudo abrir.
Future<bool> openWhatsapp({String? tenDigitPhone, required String message}) {
  return launchUrl(
    whatsappUri(tenDigitPhone: tenDigitPhone, message: message),
    mode: LaunchMode.externalApplication,
  );
}
