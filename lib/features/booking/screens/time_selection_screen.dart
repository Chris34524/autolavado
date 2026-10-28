import 'package:flutter/material.dart';

import 'package:autolavado_app/app/dependencies.dart';
import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/features/booking/domain/availability_calculator.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/time_range.dart';

class TimeSelectionScreen extends StatefulWidget {
  const TimeSelectionScreen({
    super.key,
    required this.draft,
  });

  /// Lo que el cliente lleva elegido. Debe incluir la fecha.
  final BookingDraft draft;

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  BookingDraft get _draft => widget.draft;

  /// Esta pantalla solo se abre después de elegir fecha.
  DateTime get _date => _draft.date!;

  late Future<List<int>> _slotsFuture;

  /// Horario elegido en minutos desde medianoche. null = no ha elegido.
  int? _selectedStart;

  @override
  void initState() {
    super.initState();
    // Se pide UNA vez, al abrir la pantalla.
    _slotsFuture = _loadSlots();
  }

  Future<List<int>> _loadSlots() async {
    final occupancy = await occupancyRepository.getDayOccupancy(_date);
    final calculator = AvailabilityCalculator(businessSchedule);
    return calculator.availableStartTimes(
      day: _date,
      // PROVISIONAL: hora del dispositivo. La validación definitiva la hará
      // el backend con la zona America/Mexico_City.
      now: DateTime.now(),
      durationMinutes: _draft.service.durationMinutes,
      // Local o domicilio: cada uno tiene su capacidad y su margen.
      location: _draft.location,
      occupancy: occupancy,
    );
  }

  void _retry() {
    setState(() {
      _selectedStart = null;
      _slotsFuture = _loadSlots();
    });
  }

  void _select(int start) {
    setState(() => _selectedStart = start);
  }

  void _continue() {
    // Borrador nuevo = el anterior + la hora.
    final draft = _draft.withStartTime(_selectedStart!);

    // PROVISIONAL: aquí seguiremos a la siguiente pantalla del flujo.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${draft.service.name} (${draft.location.label}): '
          '${formatLongDate(draft.date!)} a las '
          '${formatClock(draft.startMinutes!)}. Lo siguiente llega pronto.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = _draft.service;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige la hora'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event_available),
                  title: Text(service.name),
                  subtitle: Text(
                    '${formatLongDate(_date)} · '
                    '${formatDuration(service.durationMinutes)}\n'
                    '${_draft.location.label}',
                  ),
                  isThreeLine: true,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<int>>(
                  future: _slotsFuture,
                  builder: (context, snapshot) {
                    // 1. Cargando
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // 2. Error
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'No pudimos cargar los horarios.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _retry,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    // 3. Sin horarios libres ese día
                    final slots = snapshot.data ?? [];
                    if (slots.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Ya no hay horarios disponibles este día.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Elegir otra fecha'),
                            ),
                          ],
                        ),
                      );
                    }

                    // 4. Horarios, separados en mañana y tarde
                    final noon = minutesOf(12);
                    final morning = slots.where((s) => s < noon).toList();
                    final afternoon = slots.where((s) => s >= noon).toList();

                    return ListView(
                      children: [
                        if (morning.isNotEmpty)
                          _SlotSection(
                            title: 'Mañana',
                            slots: morning,
                            selected: _selectedStart,
                            onSelected: _select,
                          ),
                        if (afternoon.isNotEmpty)
                          _SlotSection(
                            title: 'Tarde',
                            slots: afternoon,
                            selected: _selectedStart,
                            onSelected: _select,
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                // null deshabilita el botón hasta que haya horario.
                onPressed: _selectedStart == null ? null : _continue,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Un grupo de horarios (mañana o tarde). Solo dibuja;
/// avisa con [onSelected] cuando el cliente toca uno.
class _SlotSection extends StatelessWidget {
  const _SlotSection({
    required this.title,
    required this.slots,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<int> slots;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final start in slots)
                ChoiceChip(
                  label: Text(formatClock(start)),
                  selected: start == selected,
                  onSelected: (_) => onSelected(start),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
