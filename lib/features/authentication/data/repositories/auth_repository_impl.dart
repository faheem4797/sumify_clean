import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/features/authentication/domain/entities/app_user.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDatasource authRemoteDatasource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(
      {required this.authRemoteDatasource, required this.connectionChecker});
  @override
  Future<Either<Failure, AppUser>> currentUser() async {
    final user = authRemoteDatasource.getCurrentUser;
    if (user == null) {
      return left(Failure('User not logged in'));
    }
    if (!await connectionChecker.isConnected) {
      // if (user.displayName == null || user.email == null) {
      //   return left(Failure('User not logged in'));
      // }
      return right(UserModel(
          id: user.uid, name: user.displayName ?? '', email: user.email ?? ''));
    }

    final currentUserData =
        await authRemoteDatasource.getUserData(id: user.uid);
    if (currentUserData == null) {
      return left(Failure('Failed to retreieve user data'));
    }
    return right(currentUserData);
  }

  @override
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final String userId = await authRemoteDatasource
          .loginWithEmailAndPassword(email: email, password: password);
      final UserModel? userModel =
          await authRemoteDatasource.getUserData(id: userId);
      if (userModel == null) {
        return left(Failure('User is null'));
      } else {
        return right(userModel);
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final String userId = await authRemoteDatasource
          .signupWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userId,
          name: name,
          email: email,
          pictureFilePathFromFirebase: '');
      await authRemoteDatasource.setUserData(userModel: userModel);

      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
