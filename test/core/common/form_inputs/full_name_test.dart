import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';

void main() {
  group('FullName', () {
    const tNamePure = FullName.pure();
    const tName = FullName.dirty();
    const tNameValue = FullName.dirty('test');

    test(
      'should return pure value when pure constructor is called',
      () async {
        //assert
        expect(tNamePure.value, equals(''));
        expect(tNamePure.isPure, equals(true));
      },
    );

    test(
      'should return dirty value when dirty constructor is called with a provided value',
      () async {
        //assert
        expect(tNameValue.value, equals('test'));
        expect(tNameValue.isPure, equals(false));
      },
    );

    test(
      'should return FullNameValidationError.empty when provided value is empty',
      () async {
        //arrange

        //act
        final result = tName.validator(tName.value);

        //assert
        expect(result, equals(FullNameValidationError.empty));
      },
    );

    test(
      'should return null when provided value is not empty',
      () async {
        //arrange

        //act
        final result = tNameValue.validator(tNameValue.value);

        //assert
        expect(result, isNull);
      },
    );
  });
}
