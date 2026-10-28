/// Validador para campos obligatorios de formularios.
///
/// Devuelve [message] si el valor está vacío (o solo tiene espacios),
/// o null si es válido. Así lo espera TextFormField.validator.
String? requiredText(String? value, String message) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}

/// Convierte un teléfono mexicano escrito de cualquier forma
/// a sus 10 dígitos, o null si no es válido.
///
/// "55 1234 5678", "+52 55 1234 5678", "(55) 1234-5678" -> "5512345678"
String? normalizeMxPhone(String input) {
  var digits = input.replaceAll(RegExp(r'\D'), ''); // solo números
  if (digits.length == 12 && digits.startsWith('52')) {
    digits = digits.substring(2); // quita la lada de país
  }
  return digits.length == 10 ? digits : null;
}

/// Validador de teléfono obligatorio (10 dígitos, México).
String? validateMxPhone(String? value) {
  if (value == null || value.trim().isEmpty) return 'Escribe tu teléfono';
  if (normalizeMxPhone(value) == null) return 'Debe tener 10 dígitos';
  return null;
}

/// Validador de correo OPCIONAL: vacío es válido;
/// si escribe algo, debe parecer un correo.
String? validateOptionalEmail(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;
  final looksLikeEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
  return looksLikeEmail ? null : 'Revisa el correo';
}
