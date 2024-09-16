import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';

void main() {
  group('Email', () {
    const tEmail = Email.dirty();
    const tEmailValue = Email.dirty('test');

    test(
      'should return pure value when pure constructor is called',
      () async {
        //arrange

        //act
        const result = Email.pure('');

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
        //arrange

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
  });
}
