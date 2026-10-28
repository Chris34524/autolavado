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
}
