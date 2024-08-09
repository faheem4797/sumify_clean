part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

final class ForgotPasswordButtonPressed extends ForgotPasswordEvent {
  @override
  List<Object> get props => [];
}
