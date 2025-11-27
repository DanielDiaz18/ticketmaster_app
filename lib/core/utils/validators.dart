/// Validadores de entrada de datos y reglas de negocio

class Validators {
  /// Valida que el texto no sea vacío
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Valida que el texto solo contenga letras y espacios
  static String? validateOnlyText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    
    // Permitir letras (incluyendo acentos), espacios y apóstrofes
    final regex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s']+$");
    if (!regex.hasMatch(value)) {
      return '$fieldName solo puede contener letras';
    }
    return null;
  }

  /// Valida que el texto solo contenga números
  static String? validateOnlyNumbers(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(value)) {
      return '$fieldName solo puede contener números';
    }
    return null;
  }

  /// Valida número de tarjeta (16 dígitos)
  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Número de tarjeta es requerido';
    }
    
    // Remover espacios
    final cleanValue = value.replaceAll(' ', '');
    
    final regex = RegExp(r'^[0-9]{16}$');
    if (!regex.hasMatch(cleanValue)) {
      return 'Número de tarjeta debe tener 16 dígitos';
    }
    return null;
  }

  /// Valida CVV (3 o 4 dígitos)
  static String? validateCVV(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV es requerido';
    }
    
    final regex = RegExp(r'^[0-9]{3,4}$');
    if (!regex.hasMatch(value)) {
      return 'CVV debe tener 3 o 4 dígitos';
    }
    return null;
  }

  /// Valida fecha de expiración (MM/AA)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fecha de expiración es requerida';
    }
    
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
    if (!regex.hasMatch(value)) {
      return 'Formato debe ser MM/AA';
    }

    // Validar que no esté vencida
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = 2000 + int.parse(parts[1]);
    final now = DateTime.now();
    final expiryDate = DateTime(year, month);
    
    if (expiryDate.isBefore(DateTime(now.year, now.month))) {
      return 'La tarjeta está vencida';
    }
    
    return null;
  }

  /// Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email es requerido';
    }
    
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Email no es válido';
    }
    return null;
  }

  /// Valida cantidad de boletos
  static String? validateTicketQuantity(int quantity, int maxAllowed, int availableTickets) {
    if (quantity < 1) {
      return 'Debe seleccionar al menos 1 boleto';
    }
    
    if (quantity > maxAllowed) {
      return 'Máximo $maxAllowed boletos por usuario';
    }
    
    if (quantity > availableTickets) {
      return 'Solo hay $availableTickets boletos disponibles';
    }
    
    return null;
  }

  /// Valida que una fecha esté en el futuro
  static String? validateFutureDate(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      return 'La fecha debe ser futura';
    }
    return null;
  }
}
