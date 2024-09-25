import 'package:equatable/equatable.dart';

class ContactUs extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  const ContactUs({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, message];
}
