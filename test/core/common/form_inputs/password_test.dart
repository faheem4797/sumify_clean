import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';

void main() {
  group('Password', () {
    const tPassword = Password.dirty();
    const tPasswordValue = Password.dirty('test');

    test(
      'should return pure value when pure constructor is called',
      () async {
        //arrange

        //act
        const result = Password.pure('');

        //assert
        expect(result.value, equals(''));
        expect(result.isPure, equals(true));
      },
    );

    test(
      'should return dirty value when dirty constructor is called with a provided value',
      () async {
        //arrange

        //act
        // const result = Password.dirty('test');

        //assert
        expect(tPasswordValue.value, equals('test'));
        expect(tPasswordValue.isPure, equals(false));
      },
    );

    test(
      'should return PasswordValidationError.empty when provided value is empty',
      () async {
        //arrange

        //act
        final result = tPassword.validator(tPassword.value);

        //assert
        expect(result, equals(PasswordValidationError.empty));
      },
    );

    test(
      'should return PasswordValidationError.short when provided value is less than 8 characters',
      () async {
        //arrange

        //act
        final result = tPasswordValue.validator(tPasswordValue.value);

        //assert
        expect(result, equals(PasswordValidationError.short));
      },
    );

    test(
      'should return null when provided value is more than 8 characters',
      () async {
        //arrange
        const tLongPasswordValue = Password.pure('12345678');
        //act
        final result = tLongPasswordValue.validator(tLongPasswordValue.value);

        //assert
        expect(result, equals(null));
      },
    );
  });
}
