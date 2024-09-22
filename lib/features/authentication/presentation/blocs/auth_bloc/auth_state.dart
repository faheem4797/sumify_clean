part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {}

final class AuthInitial extends AuthState {
  final String? message;
  AuthInitial(this.message);

  @override
  List<Object?> get props => [message];
}

final class AuthLoading extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthSuccess extends AuthState {
  final AppUser user;
  AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
