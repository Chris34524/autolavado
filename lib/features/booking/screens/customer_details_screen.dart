import 'package:flutter/material.dart';

import 'package:autolavado_app/core/utils/validators.dart';
import 'package:autolavado_app/features/booking/domain/booking_draft.dart';
import 'package:autolavado_app/features/booking/screens/booking_summary_screen.dart';
import 'package:autolavado_app/features/customers/models/customer_info.dart';
import 'package:autolavado_app/features/customers/models/vehicle_info.dart';

/// Paso del flujo: datos del cliente y de su vehículo.
class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({
    super.key,
    required this.draft,
  });

  /// Debe incluir servicio, lugar, fecha y hora.
  final BookingDraft draft;

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Si el cliente regresa a esta pantalla, lo que ya capturó vuelve a aparecer.
  CustomerInfo? get _customer => widget.draft.customer;
  VehicleInfo? get _vehicle => widget.draft.vehicle;

  late final _nameController = TextEditingController(text: _customer?.name);
  late final _phoneController = TextEditingController(text: _customer?.phone);
  late final _whatsappController =
      TextEditingController(text: _customer?.whatsapp);
  late final _emailController = TextEditingController(text: _customer?.email);

  late final _brandController = TextEditingController(text: _vehicle?.brand);
  late final _modelController = TextEditingController(text: _vehicle?.model);
  late final _colorController = TextEditingController(text: _vehicle?.color);
  late final _platesController = TextEditingController(text: _vehicle?.plates);

  /// ¿Su WhatsApp es un número distinto al teléfono?
  late bool _differentWhatsapp = _customer?.whatsapp != null;

  late VehicleType? _vehicleType = _vehicle?.type;

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _phoneController,
      _whatsappController,
      _emailController,
      _brandController,
      _modelController,
      _colorController,
      _platesController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _continue() {
    // validate() revisa TODOS los campos y muestra los errores.
    if (!_formKey.currentState!.validate()) return;

    final draft = widget.draft.withDetails(
      customer: CustomerInfo.fromInput(
        name: _nameController.text,
        phone: _phoneController.text,
        whatsapp: _differentWhatsapp ? _whatsappController.text : null,
        email: _emailController.text,
      ),
      vehicle: VehicleInfo.fromInput(
        type: _vehicleType!,
        brand: _brandController.text,
        model: _modelController.text,
        color: _colorController.text,
        plates: _platesController.text,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingSummaryScreen(draft: draft),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus datos'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // SingleChildScrollView + Column (y no ListView): ListView solo
              // construye los campos visibles, y validate() no revisaría
              // los que están fuera de la pantalla.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Contacto', style: titleStyle),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        maxLength: 60,
                        validator: (value) =>
                            requiredText(value, 'Escribe tu nombre'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono (10 dígitos)',
                          hintText: 'Ej. 55 1234 5678',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        validator: validateMxPhone,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Mi WhatsApp es otro número'),
                        value: _differentWhatsapp,
                        onChanged: (value) =>
                            setState(() => _differentWhatsapp = value),
                      ),
                      if (_differentWhatsapp) ...[
                        TextFormField(
                          controller: _whatsappController,
                          decoration: const InputDecoration(
                            labelText: 'WhatsApp (10 dígitos)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: validateMxPhone,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: validateOptionalEmail,
                      ),
                      const SizedBox(height: 24),
                      Text('Tu vehículo', style: titleStyle),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<VehicleType>(
                        initialValue: _vehicleType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final type in VehicleType.values)
                            DropdownMenuItem(value: type, child: Text(type.label)),
                        ],
                        onChanged: (value) => setState(() => _vehicleType = value),
                        validator: (value) =>
                            value == null ? 'Elige el tipo de vehículo' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _brandController,
                        decoration: const InputDecoration(
                          labelText: 'Marca',
                          hintText: 'Ej. Nissan',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: (value) => requiredText(value, 'Escribe la marca'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _modelController,
                        decoration: const InputDecoration(
                          labelText: 'Modelo',
                          hintText: 'Ej. Versa',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: (value) =>
                            requiredText(value, 'Escribe el modelo'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _colorController,
                        decoration: const InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 20,
                        validator: (value) => requiredText(value, 'Escribe el color'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _platesController,
                        decoration: const InputDecoration(
                          labelText: 'Placas (opcional)',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        maxLength: 10,
                      ),
                      Text(
                        'Usamos tus datos solo para atender y confirmar tu cita.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
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
