import 'dart:convert';

import 'package:sumify_clean/features/contact_us/domain/entities/contact_us.dart';

class ContactUsModel extends ContactUs {
  ContactUsModel(
      {required super.firstName,
      required super.lastName,
      required super.email,
      required super.message});

  ContactUsModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? message,
  }) {
    return ContactUsModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'message': message,
    };
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> map) {
    return ContactUsModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactUsModel.fromJson(String source) =>
      ContactUsModel.fromMap(json.decode(source));
}
