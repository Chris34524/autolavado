import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/core/utils/whatsapp.dart';

void main() {
  test('con número: agrega la lada 52 y el mensaje', () {
    final uri = whatsappUri(tenDigitPhone: '5512345678', message: 'Hola mundo');
    expect(uri.toString(), 'https://wa.me/525512345678?text=Hola%20mundo');
  });

  test('sin número: WhatsApp deja elegir el contacto', () {
    final uri = whatsappUri(message: 'Hola');
    expect(uri.host, 'wa.me');
    expect(uri.path, '/');
  });

  test('acentos y saltos de línea viajan completos', () {
    const message = 'Fecha: Miércoles\nLugar: A domicilio';
    final uri = whatsappUri(tenDigitPhone: '5512345678', message: message);
    expect(uri.queryParameters['text'], message);
  });
}
