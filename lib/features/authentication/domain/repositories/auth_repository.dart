import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AppUser>> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, String>> forgotUserPassword({required String email});
  Future<Either<Failure, AppUser>> currentUser();
}
