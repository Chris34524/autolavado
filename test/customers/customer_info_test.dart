import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/customers/models/customer_info.dart';

void main() {
  test('fromInput limpia y normaliza', () {
    final customer = CustomerInfo.fromInput(
      name: '  Ana López ',
      phone: '+52 55 1234 5678',
      email: '  ',
    );
    expect(customer.name, 'Ana López');
    expect(customer.phone, '5512345678');
    expect(customer.email, isNull);
    expect(customer.whatsapp, isNull);
    expect(customer.whatsappNumber, '5512345678');
  });

  test('WhatsApp distinto se guarda; igual al teléfono no', () {
    final distinto = CustomerInfo.fromInput(
      name: 'Ana',
      phone: '5512345678',
      whatsapp: '33 1111 2222',
    );
    expect(distinto.whatsapp, '3311112222');
    expect(distinto.whatsappNumber, '3311112222');

    final igual = CustomerInfo.fromInput(
      name: 'Ana',
      phone: '5512345678',
      whatsapp: '55 1234 5678',
    );
    expect(igual.whatsapp, isNull);
  });
}
