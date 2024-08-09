import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<SignInEmailChanged>(_signInEmailChanged);
    on<SignInPasswordChanged>(_signInPasswordChanged);
    on<SignInPasswordObscurePressed>(_signInPasswordObscurePressed);
    on<SignInButtonPressed>(_signInButtonPressed);
  }

  FutureOr<void> _signInEmailChanged(
      SignInEmailChanged event, Emitter<SignInState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  FutureOr<void> _signInPasswordChanged(
      SignInPasswordChanged event, Emitter<SignInState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  FutureOr<void> _signInPasswordObscurePressed(
      SignInPasswordObscurePressed event, Emitter<SignInState> emit) {
    bool obscured = state.passwordObscured;
    emit(
      state.copyWith(
        passwordObscured: !obscured,
      ),
    );
  }

  FutureOr<void> _signInButtonPressed(
      SignInButtonPressed event, Emitter<SignInState> emit) {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    emit(
      state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([
          email,
          password,
        ]),
      ),
    );
  }
}
