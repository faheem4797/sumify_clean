import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { short, empty, invalid }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  /// The original password.
  final String password;

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    } else if (value.length < 8) {
      return ConfirmPasswordValidationError.short;
    } else if (value == password) {
      return null;
    }

    return ConfirmPasswordValidationError.invalid;
  }
}
