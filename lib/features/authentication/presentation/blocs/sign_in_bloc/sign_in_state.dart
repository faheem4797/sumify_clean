part of 'sign_in_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.passwordObscured = true,
    // this.errorMessage,
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final bool passwordObscured;
  // final String? errorMessage;

  @override
  List<Object?> get props => [
        email, password, status, isValid, passwordObscured,
        // errorMessage
      ];

  SignInState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    bool? passwordObscured,
    // String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      passwordObscured: passwordObscured ?? this.passwordObscured,
      // errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


//TODO: REMOVED ALL UNNECESSARY ERROR MESSAGE PROPERTIES FROM THESE BLOCS