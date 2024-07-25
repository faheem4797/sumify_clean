class User {
  final String id;
  final String name;
  final String email;
  // final int freeTries;
  // final bool subscriptionEntitlement;
  // final String subscriptionPlan;
  final String? pictureFilePathFromFirebase;
  User({
    required this.id,
    required this.name,
    required this.email,
    this.pictureFilePathFromFirebase,
  });
}
