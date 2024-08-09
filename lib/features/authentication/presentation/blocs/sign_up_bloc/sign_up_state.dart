part of 'sign_up_bloc.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.passwordObscured = true,
    this.confirmPasswordObscured = true,
    this.errorMessage,
  });

  final FullName fullName;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool passwordObscured;
  final bool confirmPasswordObscured;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        confirmPassword,
        status,
        isValid,
        passwordObscured,
        confirmPasswordObscured,
        errorMessage
      ];

  SignUpState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? passwordObscured,
    bool? confirmPasswordObscured,
    String? errorMessage,
  }) {
    return SignUpState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      passwordObscured: passwordObscured ?? this.passwordObscured,
      confirmPasswordObscured:
          confirmPasswordObscured ?? this.confirmPasswordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
