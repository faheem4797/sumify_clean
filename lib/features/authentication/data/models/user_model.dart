import 'dart:convert';

import 'package:sumify_clean/core/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.pictureFilePathFromFirebase,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? pictureFilePathFromFirebase,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      pictureFilePathFromFirebase:
          pictureFilePathFromFirebase ?? this.pictureFilePathFromFirebase,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'pictureFilePathFromFirebase': pictureFilePathFromFirebase,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pictureFilePathFromFirebase: map['pictureFilePathFromFirebase'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
