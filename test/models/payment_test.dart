import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/models/payment.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';

void main() {
  group('Payment', () {
    test('should create payment with all properties', () {
      final details = CardPaymentDetails(
        cardNumber: '1234',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
      );

      final payment = Payment(
        id: 'payment-123',
        method: PaymentMethod.creditCard,
        amount: 250.00,
        timestamp: DateTime(2025, 11, 27, 10, 30),
        details: details,
      );

      expect(payment.id, 'payment-123');
      expect(payment.method, PaymentMethod.creditCard);
      expect(payment.amount, 250.00);
      expect(payment.timestamp, DateTime(2025, 11, 27, 10, 30));
      expect(payment.details, details);
    });

    test('should convert payment to JSON', () {
      final details = CardPaymentDetails(
        cardNumber: '1234',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
      );

      final payment = Payment(
        id: 'payment-123',
        method: PaymentMethod.creditCard,
        amount: 250.00,
        timestamp: DateTime(2025, 11, 27, 10, 30),
        details: details,
      );

      final json = payment.toJson();

      expect(json['id'], 'payment-123');
      expect(json['method'], 'PaymentMethod.creditCard');
      expect(json['amount'], 250.00);
      expect(json['timestamp'], '2025-11-27T10:30:00.000');
      expect(json['details'], isA<Map<String, dynamic>>());
    });
  });

  group('CardPaymentDetails', () {
    test('should create card payment details', () {
      final details = CardPaymentDetails(
        cardNumber: '4321',
        cardholderName: 'Jane Smith',
        expiryDate: '06/26',
        cvv: '456',
      );

      expect(details.cardNumber, '4321');
      expect(details.cardholderName, 'Jane Smith');
      expect(details.expiryDate, '06/26');
      expect(details.cvv, '456');
    });

    test('should convert card details to JSON', () {
      final details = CardPaymentDetails(
        cardNumber: '4321',
        cardholderName: 'Jane Smith',
        expiryDate: '06/26',
        cvv: '456',
      );

      final json = details.toJson();

      expect(json['cardNumber'], '4321');
      expect(json['cardholderName'], 'Jane Smith');
      expect(json['expiryDate'], '06/26');
      expect(json['cvv'], '456');
    });
  });

  group('PayPalPaymentDetails', () {
    test('should create PayPal payment details', () {
      final details = PayPalPaymentDetails(
        email: 'user@example.com',
        password: 'secure123',
      );

      expect(details.email, 'user@example.com');
      expect(details.password, 'secure123');
    });

    test('should convert PayPal details to JSON', () {
      final details = PayPalPaymentDetails(
        email: 'user@example.com',
        password: 'secure123',
      );

      final json = details.toJson();

      expect(json['email'], 'user@example.com');
      expect(json['password'], 'secure123');
    });
  });

  group('PaymentValidationResult', () {
    test('should create valid result', () {
      final result = PaymentValidationResult.valid();

      expect(result.isValid, true);
      expect(result.errorMessage, isNull);
    });

    test('should create invalid result with message', () {
      final result = PaymentValidationResult.invalid('Invalid card number');

      expect(result.isValid, false);
      expect(result.errorMessage, 'Invalid card number');
    });

    test('should create custom validation result', () {
      final result = PaymentValidationResult(
        isValid: false,
        errorMessage: 'Expired card',
      );

      expect(result.isValid, false);
      expect(result.errorMessage, 'Expired card');
    });
  });
}
