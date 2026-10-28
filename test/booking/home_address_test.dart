import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/booking/domain/home_address.dart';

void main() {
  test('fromInput limpia espacios y referencias vacías', () {
    final address = HomeAddress.fromInput(
      street: '  Av. Juárez 123 ',
      neighborhood: ' Centro',
      references: '   ',
    );
    expect(address.street, 'Av. Juárez 123');
    expect(address.neighborhood, 'Centro');
    expect(address.references, isNull);
    expect(address.isComplete, isTrue);
  });

  test('singleLine junta calle y colonia', () {
    const address = HomeAddress(street: 'Av. Juárez 123', neighborhood: 'Centro');
    expect(address.singleLine, 'Av. Juárez 123, Centro');
  });
}
