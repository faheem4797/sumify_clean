import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/authentication/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<Either<Failure, User>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, User>> currentUser();
}
