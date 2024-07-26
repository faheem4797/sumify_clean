class AppUser {
  final String id;
  final String name;
  final String email;
  // final int freeTries;
  // final bool subscriptionEntitlement;
  // final String subscriptionPlan;
  final String? pictureFilePathFromFirebase;
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.pictureFilePathFromFirebase,
  });
}
