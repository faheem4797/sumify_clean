part of 'contact_us_bloc.dart';

sealed class ContactUsEvent extends Equatable {
  const ContactUsEvent();

  @override
  List<Object> get props => [];
}

final class ContactUsFirstNameChanged extends ContactUsEvent {
  final String firstName;

  const ContactUsFirstNameChanged({required this.firstName});
  @override
  List<Object> get props => [firstName];
}

final class ContactUsLastNameChanged extends ContactUsEvent {
  final String lastName;

  const ContactUsLastNameChanged({required this.lastName});
  @override
  List<Object> get props => [lastName];
}

final class ContactUsEmailChanged extends ContactUsEvent {
  final String email;

  const ContactUsEmailChanged({required this.email});
  @override
  List<Object> get props => [email];
}

final class ContactUsMessageChanged extends ContactUsEvent {
  final String message;

  const ContactUsMessageChanged({required this.message});
  @override
  List<Object> get props => [message];
}

final class ContactUsSubmitButtonPressed extends ContactUsEvent {}
