import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';
import 'package:sumify_clean/features/contact_us/domain/usecases/send_email.dart';

part 'contact_us_event.dart';
part 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  final SendEmail _sendEmail;
  ContactUsBloc({required SendEmail sendEmail})
      : _sendEmail = sendEmail,
        super(const ContactUsState()) {
    on<ContactUsFirstNameChanged>(_contactUsFirstNameChanged);
    on<ContactUsLastNameChanged>(_contactUsLastNameChanged);
    on<ContactUsEmailChanged>(_contactUsEmailChanged);
    on<ContactUsMessageChanged>(_contactUsMessageChanged);
    on<ContactUsSubmitButtonPressed>(_contactUsSubmitButtonPressed);
  }

  FutureOr<void> _contactUsFirstNameChanged(
      ContactUsFirstNameChanged event, Emitter<ContactUsState> emit) {
    final firstName = FullName.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        isValid: Formz.validate(
            [firstName, state.lastName, state.email, state.message]),
      ),
    );
  }

  FutureOr<void> _contactUsLastNameChanged(
      ContactUsLastNameChanged event, Emitter<ContactUsState> emit) {
    final lastName = FullName.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        isValid: Formz.validate(
            [state.firstName, lastName, state.email, state.message]),
      ),
    );
  }

  FutureOr<void> _contactUsEmailChanged(
      ContactUsEmailChanged event, Emitter<ContactUsState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
            [state.firstName, state.lastName, email, state.message]),
      ),
    );
  }

  FutureOr<void> _contactUsMessageChanged(
      ContactUsMessageChanged event, Emitter<ContactUsState> emit) {
    final message = FullName.dirty(event.message);
    emit(
      state.copyWith(
        message: message,
        isValid: Formz.validate(
            [state.firstName, state.lastName, state.email, message]),
      ),
    );
  }

  FutureOr<void> _contactUsSubmitButtonPressed(
      ContactUsSubmitButtonPressed event, Emitter<ContactUsState> emit) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final response = await _sendEmail(SendEmailParams(
      firstName: state.firstName.value,
      lastName: state.lastName.value,
      email: state.email.value,
      message: state.message.value,
    ));
    response.fold(
      (l) => emit(state.copyWith(
        errorMessage: l.message,
        status: FormzSubmissionStatus.failure,
      )),
      (r) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
    );
  }
}
