import '../core/constants/enums.dart';

/// Modelo de pago
class Payment {
  final String id;
  final PaymentMethod method;
  final double amount;
  final DateTime timestamp;
  final PaymentDetails details;

  Payment({
    required this.id,
    required this.method,
    required this.amount,
    required this.timestamp,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method.toString(),
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'details': details.toJson(),
    };
  }
}

/// Detalles de pago
abstract class PaymentDetails {
  Map<String, dynamic> toJson();
}

/// Detalles de pago con tarjeta
class CardPaymentDetails extends PaymentDetails {
  final String cardNumber; // Solo últimos 4 dígitos
  final String cardholderName;
  final String expiryDate;
  final String cvv;

  CardPaymentDetails({
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.cvv,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardholderName': cardholderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}

/// Detalles de pago con PayPal
class PayPalPaymentDetails extends PaymentDetails {
  final String email;
  final String password;

  PayPalPaymentDetails({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Resultado de validación de pago
class PaymentValidationResult {
  final bool isValid;
  final String? errorMessage;

  PaymentValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  factory PaymentValidationResult.valid() {
    return PaymentValidationResult(isValid: true);
  }

  factory PaymentValidationResult.invalid(String message) {
    return PaymentValidationResult(isValid: false, errorMessage: message);
  }
}
