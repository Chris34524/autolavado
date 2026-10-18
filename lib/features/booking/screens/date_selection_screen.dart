import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

/// PROVISIONAL: cuántos días hacia adelante se puede reservar.
/// Vendrá de la configuración del negocio en Firestore.
const int kBookingWindowDays = 30;

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({
    super.key,
    required this.service,
  });

  /// El servicio que el cliente eligió en la pantalla anterior.
  final WashService service;

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  /// Día elegido (sin hora). null = todavía no elige.
  DateTime? _selectedDate;

  /// PROVISIONAL: aquí se excluirán días no laborables y bloqueados.
  /// Por ahora todos los días son seleccionables.
  bool _isSelectableDay(DateTime day) => true;

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: kBookingWindowDays)),
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
    // PROVISIONAL: aquí navegaremos a la pantalla de horarios (tarea #12),
    // pasando servicio + fecha.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fecha elegida: ${formatLongDate(_selectedDate!)}. '
          'Los horarios llegan en el siguiente paso.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;
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
                  '${formatMxn(service.priceCents)}',
                ),
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
