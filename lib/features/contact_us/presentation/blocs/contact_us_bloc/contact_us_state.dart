part of 'contact_us_bloc.dart';

final class ContactUsState extends Equatable {
  const ContactUsState({
    this.firstName = const FullName.pure(),
    this.lastName = const FullName.pure(),
    this.email = const Email.pure(),
    this.message = const FullName.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });
  final FullName firstName;
  final FullName lastName;
  final Email email;
  final FullName message;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [firstName, lastName, email, message, status, isValid, errorMessage];

  ContactUsState copyWith({
    FullName? firstName,
    FullName? lastName,
    Email? email,
    FullName? message,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return ContactUsState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      message: message ?? this.message,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
