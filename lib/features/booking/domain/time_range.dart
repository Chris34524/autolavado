/// Minutos que tiene un día.
const int minutesPerDay = 24 * 60;

/// Convierte una hora del día a minutos desde medianoche.
/// minutesOf(10, 30) -> 630
int minutesOf(int hour, [int minute = 0]) => hour * 60 + minute;

/// Intervalo de tiempo dentro de un día, en minutos desde medianoche.
///
/// Es semiabierto: incluye [start] y excluye [end].
/// TimeRange(600, 630) va de 10:00 a 10:30, y una cita que empieza
/// a las 10:30 NO se cruza con él.
class TimeRange {
  const TimeRange(this.start, this.end)
      : assert(start >= 0),
        assert(end > start);

  final int start;
  final int end;

  int get duration => end - start;

  /// ¿Comparten al menos un minuto?
  bool overlaps(TimeRange other) => start < other.end && other.start < end;

  /// ¿[other] cabe completo dentro de este intervalo?
  bool contains(TimeRange other) => start <= other.start && other.end <= end;

  @override
  bool operator ==(Object other) =>
      other is TimeRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'TimeRange(${_hhmm(start)}-${_hhmm(end)})';
}

String _hhmm(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
