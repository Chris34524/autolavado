/// Dónde se realiza el servicio. Cada tipo tiene su propia capacidad.
enum ServiceLocation {
  /// En el local del autolavado.
  shop('En el local'),

  /// A domicilio.
  home('A domicilio');

  const ServiceLocation(this.label);

  /// Texto para mostrar al cliente.
  final String label;
}
