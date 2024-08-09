part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpFullNameChanged extends SignUpEvent {
  final String fullName;
  const SignUpFullNameChanged({required this.fullName});
  @override
  List<Object> get props => [fullName];
}

final class SignUpEmailChanged extends SignUpEvent {
  final String email;
  const SignUpEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

final class SignUpPasswordChanged extends SignUpEvent {
  final String password;
  const SignUpPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

final class SignUpConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;
  const SignUpConfirmPasswordChanged({required this.confirmPassword});
  @override
  List<Object> get props => [confirmPassword];
}

final class SignUpPasswordObscurePressed extends SignUpEvent {
  @override
  List<Object> get props => [];
}

final class SignUpConfirmPasswordObscurePressed extends SignUpEvent {
  @override
  List<Object> get props => [];
}

final class SignUpButtonPressed extends SignUpEvent {
  @override
  List<Object> get props => [];
}
