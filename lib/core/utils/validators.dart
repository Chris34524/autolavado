/// Validador para campos obligatorios de formularios.
///
/// Devuelve [message] si el valor está vacío (o solo tiene espacios),
/// o null si es válido. Así lo espera TextFormField.validator.
String? requiredText(String? value, String message) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}
