/// Estados de una cita.
enum BookingStatus {
  pending('Pendiente de confirmar'),
  confirmed('Confirmada'),
  inProgress('En proceso'),
  done('Terminada'),
  cancelled('Cancelada');

  const BookingStatus(this.label);

  final String label;
}
