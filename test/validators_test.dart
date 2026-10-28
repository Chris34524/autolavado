import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/core/utils/validators.dart';

void main() {
  test('requiredText rechaza vacío y solo espacios', () {
    expect(requiredText(null, 'Falta'), 'Falta');
    expect(requiredText('', 'Falta'), 'Falta');
    expect(requiredText('   ', 'Falta'), 'Falta');
  });

  test('requiredText acepta texto', () {
    expect(requiredText('Centro', 'Falta'), isNull);
  });

  group('Teléfono de México', () {
    test('acepta distintas formas de escribirlo', () {
      expect(normalizeMxPhone('5512345678'), '5512345678');
      expect(normalizeMxPhone('55 1234 5678'), '5512345678');
      expect(normalizeMxPhone('(55) 1234-5678'), '5512345678');
      expect(normalizeMxPhone('+52 55 1234 5678'), '5512345678');
    });

    test('rechaza números incompletos o de más', () {
      expect(normalizeMxPhone('12345'), isNull);
      expect(normalizeMxPhone('551234567890'), isNull);
      expect(normalizeMxPhone(''), isNull);
    });

    test('validateMxPhone da mensajes claros', () {
      expect(validateMxPhone(''), 'Escribe tu teléfono');
      expect(validateMxPhone('5512'), 'Debe tener 10 dígitos');
      expect(validateMxPhone('55 1234 5678'), isNull);
    });
  });

  group('Correo opcional', () {
    test('vacío es válido', () {
      expect(validateOptionalEmail(null), isNull);
      expect(validateOptionalEmail('  '), isNull);
    });

    test('si escribe algo, debe parecer correo', () {
      expect(validateOptionalEmail('cliente@correo.mx'), isNull);
      expect(validateOptionalEmail('cliente'), 'Revisa el correo');
    });
  });
}
