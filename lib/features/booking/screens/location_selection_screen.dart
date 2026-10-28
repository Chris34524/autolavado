import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/formatters.dart';
import 'package:autolavado_app/core/utils/validators.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/domain/home_address.dart';
import 'package:autolavado_app/features/booking/domain/service_location.dart';
import 'package:autolavado_app/features/booking/screens/date_selection_screen.dart';
import 'package:autolavado_app/features/services/models/wash_service.dart';

/// Paso del flujo: ¿en el local o a domicilio?
/// Solo se muestra cuando el servicio se ofrece a domicilio.
class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({
    super.key,
    required this.draft,
  });

  final BookingDraft draft;

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  /// Llave para validar el formulario de dirección.
  final _formKey = GlobalKey<FormState>();

  // Los controladores guardan lo que el cliente escribe.
  // Viven en el State: si cambia a "local" y regresa a "domicilio",
  // lo que ya escribió sigue ahí.
  late final _streetController =
      TextEditingController(text: widget.draft.address?.street);
  late final _neighborhoodController =
      TextEditingController(text: widget.draft.address?.neighborhood);
  late final _referencesController =
      TextEditingController(text: widget.draft.address?.references);

  late ServiceLocation _location = _initialLocation();

  WashService get _service => widget.draft.service;

  /// Opciones que ofrece este servicio.
  List<ServiceLocation> get _allowed => [
        if (_service.availableAtShop) ServiceLocation.shop,
        if (_service.availableAtHome) ServiceLocation.home,
      ];

  ServiceLocation _initialLocation() {
    final current = widget.draft.location;
    return _allowed.contains(current) ? current : _allowed.first;
  }

  bool get _isHome => _location == ServiceLocation.home;

  @override
  void dispose() {
    // Los controladores reservan recursos: hay que liberarlos.
    _streetController.dispose();
    _neighborhoodController.dispose();
    _referencesController.dispose();
    super.dispose();
  }

  void _continue() {
    // A domicilio, la dirección debe ser válida antes de seguir.
    if (_isHome && !_formKey.currentState!.validate()) return;

    final draft = widget.draft.withLocation(
      _location,
      address: _isHome
          ? HomeAddress.fromInput(
              street: _streetController.text,
              neighborhood: _neighborhoodController.text,
              references: _referencesController.text,
            )
          : null,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSelectionScreen(draft: draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Dónde lo lavamos?'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: Text(_service.name),
                      subtitle: Text(
                        '${formatDuration(_service.durationMinutes)} · '
                        '${formatMxn(_service.priceCents)}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SegmentedButton<ServiceLocation>(
                    segments: [
                      for (final option in _allowed)
                        ButtonSegment(
                          value: option,
                          label: Text(option.label),
                          icon: Icon(
                            option == ServiceLocation.shop
                                ? Icons.store
                                : Icons.home,
                          ),
                        ),
                    ],
                    selected: {_location},
                    onSelectionChanged: (selection) {
                      setState(() => _location = selection.first);
                    },
                  ),
                  if (_isHome) ...[
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _streetController,
                            decoration: const InputDecoration(
                              labelText: 'Calle y número',
                              hintText: 'Ej. Av. Juárez 123, int. 4',
                              border: OutlineInputBorder(),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            maxLength: 100,
                            validator: (value) => requiredText(
                                value, 'Escribe la calle y el número'),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _neighborhoodController,
                            decoration: const InputDecoration(
                              labelText: 'Colonia',
                              border: OutlineInputBorder(),
                            ),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            maxLength: 60,
                            validator: (value) =>
                                requiredText(value, 'Escribe la colonia'),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _referencesController,
                            decoration: const InputDecoration(
                              labelText: 'Referencias (opcional)',
                              hintText: 'Ej. Portón negro, frente al parque',
                              border: OutlineInputBorder(),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            maxLength: 150,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Solo usamos tu dirección para llegar a lavar tu auto.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _continue,
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
