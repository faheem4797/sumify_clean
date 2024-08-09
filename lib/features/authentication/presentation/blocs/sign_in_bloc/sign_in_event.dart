part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class SignInEmailChanged extends SignInEvent {
  final String email;
  const SignInEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

final class SignInPasswordChanged extends SignInEvent {
  final String password;
  const SignInPasswordChanged({required this.password});
  @override
  List<Object> get props => [password];
}

final class SignInPasswordObscurePressed extends SignInEvent {
  @override
  List<Object> get props => [];
}

final class SignInButtonPressed extends SignInEvent {
  @override
  List<Object> get props => [];
}
