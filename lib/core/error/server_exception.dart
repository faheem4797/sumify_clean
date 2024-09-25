import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException([
    this.message = 'An unknown server exception occurred.',
  ]);

  final String message;

  @override
  List<Object?> get props => [message];
}
