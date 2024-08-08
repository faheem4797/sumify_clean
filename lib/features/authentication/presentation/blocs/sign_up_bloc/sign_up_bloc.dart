import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/confirm_password.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpFullNameChanged>(_signUpFullNameChanged);
    on<SignUpEmailChanged>(_signUpEmailChanged);
    on<SignUpPasswordChanged>(_signUpPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_signUpConfirmPasswordChanged);
  }

  FutureOr<void> _signUpFullNameChanged(
      SignUpFullNameChanged event, Emitter<SignUpState> emit) {
    final fullName = FullName.dirty(event.fullName);
    emit(
      state.copyWith(
        fullName: fullName,
        isValid: Formz.validate(
            [fullName, state.email, state.password, state.confirmPassword]),
      ),
    );
  }

  FutureOr<void> _signUpEmailChanged(
      SignUpEmailChanged event, Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
            [state.fullName, email, state.password, state.confirmPassword]),
      ),
    );
  }

  FutureOr<void> _signUpPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate(
            [state.fullName, state.email, password, state.confirmPassword]),
      ),
    );
  }

  FutureOr<void> _signUpConfirmPasswordChanged(
      SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    final confirmPassword = ConfirmPassword.dirty(
      password: state.password.value,
      value: event.confirmPassword,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate(
            [state.fullName, state.email, state.password, confirmPassword]),
      ),
    );
  }
}
