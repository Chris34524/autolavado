/// Un servicio de lavado que ofrece el negocio.
///
/// Por ahora se crea con datos de ejemplo.
/// Más adelante se construirá a partir de documentos de Firestore.
class WashService {
  const WashService({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.durationMinutes,
    this.imageUrl,
    this.isActive = true,
    this.availableAtShop = true,
    this.availableAtHome = false,
    this.sortOrder = 0,
  });

  /// Identificador único. En Firestore será el ID del documento.
  final String id;

  final String name;
  final String description;

  /// Precio en centavos de MXN. Ejemplo: 35000 = $350.00 MXN.
  final int priceCents;

  /// Duración estimada en minutos. Se usará para calcular disponibilidad.
  final int durationMinutes;

  /// URL de la imagen (vendrá de Firebase Storage). Puede no existir.
  final String? imageUrl;

  final bool isActive;
  final bool availableAtShop;
  final bool availableAtHome;

  /// Orden de aparición en la lista (menor = primero).
  final int sortOrder;
}
