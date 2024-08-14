import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, String>> signOutUser();
}
