/// Dirección para un servicio a domicilio.
///
/// Solo pedimos lo necesario para llegar (protección de datos personales).
/// PROVISIONAL: todavía no validamos zona de cobertura.
class HomeAddress {
  const HomeAddress({
    required this.street,
    required this.neighborhood,
    this.references,
  });

  /// Crea la dirección a partir de lo que escribió el cliente:
  /// quita espacios sobrantes y convierte referencias vacías en null.
  factory HomeAddress.fromInput({
    required String street,
    required String neighborhood,
    String? references,
  }) {
    final refs = references?.trim();
    return HomeAddress(
      street: street.trim(),
      neighborhood: neighborhood.trim(),
      references: (refs == null || refs.isEmpty) ? null : refs,
    );
  }

  /// Calle y número, por ejemplo "Av. Juárez 123, int. 4".
  final String street;

  /// Colonia.
  final String neighborhood;

  /// Referencias para encontrar el lugar. Opcional.
  final String? references;

  bool get isComplete => street.isNotEmpty && neighborhood.isNotEmpty;

  /// "Av. Juárez 123, Centro"
  String get singleLine => '$street, $neighborhood';
}
