import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_forgotPasswordEmailChanged);
    on<ForgotPasswordButtonPressed>(_forgotPasswordButtonPressed);
  }

  FutureOr<void> _forgotPasswordEmailChanged(
      ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  FutureOr<void> _forgotPasswordButtonPressed(
      ForgotPasswordButtonPressed event, Emitter<ForgotPasswordState> emit) {
    final email = Email.dirty(state.email.value);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }
}
