import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('validateCardNumber', () {
      test('should return null for valid 16-digit card number', () {
        final result = Validators.validateCardNumber('1234567890123456');
        expect(result, isNull);
      });

      test('should return error for card number with less than 16 digits', () {
        final result = Validators.validateCardNumber('12345678901234');
        expect(result, isNotNull);
      });

      test('should return error for card number with non-numeric characters', () {
        final result = Validators.validateCardNumber('123456789012345a');
        expect(result, isNotNull);
      });

      test('should return error for empty card number', () {
        final result = Validators.validateCardNumber('');
        expect(result, isNotNull);
      });
    });

    group('validateCVV', () {
      test('should return null for valid 3-digit CVV', () {
        final result = Validators.validateCVV('123');
        expect(result, isNull);
      });

      test('should return null for valid 4-digit CVV', () {
        final result = Validators.validateCVV('1234');
        expect(result, isNull);
      });

      test('should return error for CVV with less than 3 digits', () {
        final result = Validators.validateCVV('12');
        expect(result, isNotNull);
      });

      test('should return error for CVV with non-numeric characters', () {
        final result = Validators.validateCVV('12a');
        expect(result, isNotNull);
      });
    });

    group('validateExpiryDate', () {
      test('should return null for valid future expiry date', () {
        final result = Validators.validateExpiryDate('12/30');
        expect(result, isNull);
      });

      test('should return error for expired card', () {
        final result = Validators.validateExpiryDate('01/20');
        expect(result, isNotNull);
      });

      test('should return error for invalid format', () {
        final result = Validators.validateExpiryDate('13/25');
        expect(result, isNotNull);
      });

      test('should return error for wrong format', () {
        final result = Validators.validateExpiryDate('12/2025');
        expect(result, isNotNull);
      });
    });

    group('validateEmail', () {
      test('should return null for valid email', () {
        final result = Validators.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('should return error for invalid email without @', () {
        final result = Validators.validateEmail('testexample.com');
        expect(result, isNotNull);
      });

      test('should return error for invalid email without domain', () {
        final result = Validators.validateEmail('test@');
        expect(result, isNotNull);
      });

      test('should return error for empty email', () {
        final result = Validators.validateEmail('');
        expect(result, isNotNull);
      });
    });

    group('validateOnlyText', () {
      test('should return null for valid text with letters only', () {
        final result = Validators.validateOnlyText('John Doe', 'Name');
        expect(result, isNull);
      });

      test('should return null for text with accents', () {
        final result = Validators.validateOnlyText('José María', 'Name');
        expect(result, isNull);
      });

      test('should return error for text with numbers', () {
        final result = Validators.validateOnlyText('John123', 'Name');
        expect(result, isNotNull);
      });

      test('should return error for text with special characters', () {
        final result = Validators.validateOnlyText('John@Doe', 'Name');
        expect(result, isNotNull);
      });
    });

    group('validateOnlyNumbers', () {
      test('should return null for valid numbers', () {
        final result = Validators.validateOnlyNumbers('12345', 'Number');
        expect(result, isNull);
      });

      test('should return error for text with letters', () {
        final result = Validators.validateOnlyNumbers('123a5', 'Number');
        expect(result, isNotNull);
      });

      test('should return error for empty string', () {
        final result = Validators.validateOnlyNumbers('', 'Number');
        expect(result, isNotNull);
      });
    });

    group('validateTicketQuantity', () {
      test('should return null for valid quantity', () {
        final result = Validators.validateTicketQuantity(5, 10, 20);
        expect(result, isNull);
      });

      test('should return error for quantity exceeding max allowed', () {
        final result = Validators.validateTicketQuantity(11, 10, 20);
        expect(result, isNotNull);
        expect(result, contains('Máximo'));
      });

      test('should return error for quantity exceeding available tickets', () {
        final result = Validators.validateTicketQuantity(5, 10, 3);
        expect(result, isNotNull);
        expect(result, contains('disponibles'));
      });

      test('should return error for quantity less than 1', () {
        final result = Validators.validateTicketQuantity(0, 10, 20);
        expect(result, isNotNull);
        expect(result, contains('al menos 1'));
      });
    });
  });
}
