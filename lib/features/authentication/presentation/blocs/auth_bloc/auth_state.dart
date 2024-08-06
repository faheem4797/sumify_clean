part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  final String? message;
  AuthInitial(this.message);
}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final AppUser user;
  AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
