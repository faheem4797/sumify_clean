class FirebaseDataFailure implements Exception {
  const FirebaseDataFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory FirebaseDataFailure.fromCode(code) {
    switch (code) {
      case 'invalid-argument':
        return const FirebaseDataFailure(
          'Invalid argument.',
        );
      case 'not-found':
        return const FirebaseDataFailure(
          'Document not found.',
        );
      case 'permission-denied':
        return const FirebaseDataFailure(
          'Permission denied.',
        );
      case 'out-of-range':
        return const FirebaseDataFailure(
          'Operation out of range.',
        );
      default:
        return const FirebaseDataFailure();
    }
  }

  /// The associated error message.
  final String message;
}
