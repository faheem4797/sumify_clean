import 'package:equatable/equatable.dart';

class LocalFileSavingException extends Equatable implements Exception {
  const LocalFileSavingException([
    this.message = 'An unknown server exception occurred.',
  ]);

  final String message;

  @override
  List<Object?> get props => [message];
}
