import 'package:flutter_test/flutter_test.dart';

import 'package:autolavado_app/features/customers/models/vehicle_info.dart';

void main() {
  test('fromInput limpia, pone placas en mayúsculas y describe el auto', () {
    final vehicle = VehicleInfo.fromInput(
      type: VehicleType.car,
      brand: ' Nissan',
      model: 'Versa ',
      color: 'gris',
      plates: ' abc-123-d ',
    );
    expect(vehicle.plates, 'ABC-123-D');
    expect(vehicle.description, 'Nissan Versa gris');

    final sinPlacas = VehicleInfo.fromInput(
      type: VehicleType.suv,
      brand: 'Kia',
      model: 'Seltos',
      color: 'rojo',
      plates: '',
    );
    expect(sinPlacas.plates, isNull);
  });
}
