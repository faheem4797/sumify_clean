import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/form_inputs/confirm_password.dart';

void main() {
  group('ConfirmPassword', () {
    const tConfirmPasswordPure = ConfirmPassword.pure();

    const tConfirmPassword = ConfirmPassword.dirty(password: 'test');
    const tConfirmPasswordValue =
        ConfirmPassword.dirty(password: 'test', value: 'test');

    test(
      'should return a pure value when pure constructor is callled',
      () async {
        //assert
        expect(tConfirmPasswordPure.value, equals(''));
        expect(tConfirmPasswordPure.password, equals(''));
        expect(tConfirmPasswordPure.isPure, equals(true));
      },
    );

    test(
      'should return a dirty value when dirty constructor is callled  with a provided password and no value',
      () async {
        //assert
        expect(tConfirmPassword.value, equals(''));
        expect(tConfirmPassword.password, equals('test'));
        expect(tConfirmPassword.isPure, equals(false));
      },
    );

    test(
      'should return a dirty value when dirty constructor is callled  with a provided password and a provided value',
      () async {
        //assert
        expect(tConfirmPasswordValue.value, equals('test'));
        expect(tConfirmPasswordValue.password, equals('test'));
        expect(tConfirmPasswordValue.isPure, equals(false));
      },
    );

    test(
      'should return ConfirmPasswordValidationError.empty when value is empty',
      () async {
        //act
        final result = tConfirmPassword.validator(tConfirmPassword.value);

        //assert
        expect(result, equals(ConfirmPasswordValidationError.empty));
      },
    );
    test(
      'should return ConfirmPasswordValidationError.invalid when value does not match the password',
      () async {
        //arrange
        const tPasswordValue =
            ConfirmPassword.dirty(password: '12345678', value: 'test12345678');

        //act
        final result = tPasswordValue.validator(tPasswordValue.value);

        //assert
        expect(result, equals(ConfirmPasswordValidationError.invalid));
      },
    );

    test(
      'should return null when value matches the password',
      () async {
        //arrange
        const tPasswordValue =
            ConfirmPassword.dirty(password: '12345678', value: '12345678');

        //act
        final result = tPasswordValue.validator(tPasswordValue.value);

        //assert
        expect(result, isNull);
      },
    );

    test(
      'should return ConfirmPasswordValidationError.invalid for a case-sensitive mismatch',
      () async {
        // Arrange
        const tPasswordValue =
            ConfirmPassword.dirty(password: 'Password', value: 'password');

        // Act
        final result = tPasswordValue.validator(tPasswordValue.value);

        // Assert
        expect(result, equals(ConfirmPasswordValidationError.invalid));
      },
    );
  });
}
