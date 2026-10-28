import 'package:flutter/material.dart';

import 'package:autolavado_app/app/dependencies.dart';
import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/screens/time_selection_screen.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({
    super.key,
    required this.draft,
  });

  /// Lo que el cliente lleva elegido (servicio y lugar).
  final BookingDraft draft;

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  /// Día elegido (sin hora). null = todavía no elige.
  late DateTime? _selectedDate = widget.draft.date;

  /// Solo días en que el negocio abre. Los festivos y bloqueos de día
  /// completo se verán en la pantalla de horarios (sin horarios libres).
  bool _isSelectableDay(DateTime day) => businessSchedule.isOpenOn(day.weekday);

  /// Primer día que se puede elegir entre [from] y [last], o null si no hay.
  DateTime? _firstSelectableDay(DateTime from, DateTime last) {
    for (var day = from;
        !day.isAfter(last);
        day = DateUtils.addDaysToDate(day, 1)) {
      if (_isSelectableDay(day)) return day;
    }
    return null;
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final lastDate =
        DateUtils.addDaysToDate(today, businessSchedule.bookingWindowDays);

    // El calendario exige que el día inicial sea seleccionable:
    // si hoy está cerrado (por ejemplo, domingo), empezamos en el siguiente.
    final initialDate = _selectedDate ?? _firstSelectableDay(today, lastDate);
    if (initialDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por ahora no hay días disponibles.')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: lastDate,
      selectableDayPredicate: _isSelectableDay,
      helpText: 'Elige el día de tu lavado',
    );

    // El cliente cerró el calendario sin elegir.
    if (picked == null) return;
    // La pantalla pudo cerrarse mientras el calendario estaba abierto.
    if (!mounted) return;

    setState(() {
      _selectedDate = DateUtils.dateOnly(picked);
    });
  }

  void _continue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeSelectionScreen(
          // Borrador nuevo = el anterior + la fecha.
          draft: widget.draft.withDate(_selectedDate!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.draft.service;
    final date = _selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige la fecha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: Text(service.name),
                subtitle: Text(
                  '${formatDuration(service.durationMinutes)} · '
                  '${formatMxn(service.priceCents)}\n'
                  '${widget.draft.location.label}',
                ),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                date == null ? 'Elegir fecha' : formatLongDate(date),
              ),
            ),
            const Spacer(),
            FilledButton(
              // null deshabilita el botón hasta que haya fecha.
              onPressed: date == null ? null : _continue,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
