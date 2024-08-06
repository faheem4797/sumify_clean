import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/current_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/forgot_password.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/login_user.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/signup_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUser _signupUser;
  final LoginUser _loginUser;
  final ForgotPassword _forgotPassword;
  final CurrentUser _currentUser;
  AuthBloc({
    required SignupUser signupUser,
    required LoginUser loginUser,
    required ForgotPassword forgotPassword,
    required CurrentUser currentUser,
  })  : _signupUser = signupUser,
        _loginUser = loginUser,
        _forgotPassword = forgotPassword,
        _currentUser = currentUser,
        super(AuthInitial(null)) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_authSignUp);
    on<AuthLogin>(_authLogin);
    on<AuthForgotPassword>(_authForgotPassword);
    on<AuthIsUserLoggedIn>(_authIsUserLoggedIn);
  }

  FutureOr<void> _authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _signupUser(SignupUserParams(
        name: event.name, email: event.email, password: event.password));
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }

  FutureOr<void> _authLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final response = await _loginUser(
        LoginUserParams(email: event.email, password: event.password));
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }

  FutureOr<void> _authForgotPassword(
      AuthForgotPassword event, Emitter<AuthState> emit) async {
    final response =
        await _forgotPassword(ForgotPasswordParams(email: event.email));
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthInitial(r)),
    );
  }

  FutureOr<void> _authIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final response = await _currentUser(NoParams());
    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }
}
