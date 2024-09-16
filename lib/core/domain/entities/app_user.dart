import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  // final int freeTries;
  // final bool subscriptionEntitlement;
  // final String subscriptionPlan;
  final String? pictureFilePathFromFirebase;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.pictureFilePathFromFirebase,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, email, pictureFilePathFromFirebase];
}
