import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';

void main() {
  group('Email', () {
    const tEmailPure = Email.pure();
    const tEmail = Email.dirty();
    const tEmailValue = Email.dirty('test');

    test(
      'should return pure value when pure constructor is called',
      () async {
        //assert
        expect(tEmailPure.value, equals(''));
        expect(tEmailPure.isPure, equals(true));
      },
    );

    test(
      'should return dirty value when dirty constructor is called with a provided value',
      () async {
        //arrange

        //act
        // const result = Password.dirty('test');

        //assert
        expect(tEmailValue.value, equals('test'));
        expect(tEmailValue.isPure, equals(false));
      },
    );

    test(
      'should return EmailValidationError.empty when provided value is empty',
      () async {
        //arrange

        //act
        final result = tEmail.validator(tEmail.value);

        //assert
        expect(result, equals(EmailValidationError.empty));
      },
    );

    test(
      'should return EmailValidationError.invalid when provided value does not match the Regexp',
      () async {
        //act
        final result = tEmailValue.validator(tEmailValue.value);

        //assert
        expect(result, equals(EmailValidationError.invalid));
      },
    );

    test(
      'should return null when provided value macthes an email',
      () async {
        //arrange
        const tGoodEmailValue = Email.pure('test@gmail.com');
        //act
        final result = tGoodEmailValue.validator(tGoodEmailValue.value);

        //assert
        expect(result, equals(null));
      },
    );

    test(
      'should return EmailValidationError.invalid for emails with invalid format',
      () async {
        const invalidEmailCases = [
          'invalid@',
          'invalid.com',
          '@invalid.com',
          'invalid@domain.',
          'invalid@.com',
          // 'invalid@domain.c',
        ];

        for (final invalidEmail in invalidEmailCases) {
          // Arrange
          final email = Email.dirty(invalidEmail);

          // Act
          final result = email.validator(email.value);

          // Assert
          expect(result, equals(EmailValidationError.invalid));
        }
      },
    );

    test(
      'should return null for emails with valid format and special characters',
      () async {
        const validEmailCases = [
          'test.email+alex@leetcode.com',
          'email@domain.co.uk',
          'email@sub.domain.com',
          '1234567890@domain.com',
          'user.name@domain.com',
        ];

        for (final validEmail in validEmailCases) {
          // Arrange
          final email = Email.dirty(validEmail);

          // Act
          final result = email.validator(email.value);

          // Assert
          expect(result, isNull);
        }
      },
    );
  });
}
