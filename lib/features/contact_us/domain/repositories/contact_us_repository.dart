import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';

abstract interface class ContactUsRepository {
  Future<Either<Failure, String>> sendEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String message,
  });
}
