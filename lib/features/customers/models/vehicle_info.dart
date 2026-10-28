/// Tipo de vehículo.
///
/// PROVISIONAL: la lista y si el tipo cambia el precio
/// se confirmarán con el negocio.
enum VehicleType {
  car('Auto'),
  suv('Camioneta / SUV'),
  pickup('Pick-up'),
  van('Van');

  const VehicleType(this.label);

  final String label;
}

/// Datos básicos del vehículo para una reserva.
class VehicleInfo {
  const VehicleInfo({
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    this.plates,
  });

  /// Crea el vehículo a partir de lo que escribió el cliente:
  /// limpia espacios y guarda las placas en mayúsculas.
  factory VehicleInfo.fromInput({
    required VehicleType type,
    required String brand,
    required String model,
    required String color,
    String? plates,
  }) {
    final cleanPlates = plates?.trim().toUpperCase();
    return VehicleInfo(
      type: type,
      brand: brand.trim(),
      model: model.trim(),
      color: color.trim(),
      plates: (cleanPlates == null || cleanPlates.isEmpty) ? null : cleanPlates,
    );
  }

  final VehicleType type;
  final String brand;
  final String model;
  final String color;

  /// Opcionales.
  final String? plates;

  /// "Nissan Versa gris"
  String get description => '$brand $model $color';
}
