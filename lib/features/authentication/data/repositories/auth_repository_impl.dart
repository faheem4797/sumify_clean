import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(
      {required this.authRemoteDatasource, required this.connectionChecker});

  @override
  Future<Either<Failure, String>> forgotUserPassword(
      {required String email}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }
      final message =
          await authRemoteDatasource.forgotUserPassword(email: email);
      return right(message);
    } on SendPasswordResetEmailFailure catch (e) {
      return left(Failure(e.message));
    } catch (_) {
      return left(const Failure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> currentUser() async {
    try {
      final user = authRemoteDatasource.getCurrentUser;
      if (user == null) {
        return left(const Failure(Constants.nullUserErrorMessage));
      }
      if (!await connectionChecker.isConnected) {
        return right(UserModel(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? ''));
      }

      final UserModel currentUserData =
          await authRemoteDatasource.getUserData(id: user.uid);

      return right(currentUserData);
    } on FirebaseDataFailure catch (e) {
      return left(Failure(e.message));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? const Failure().message));
    } catch (_) {
      return left(const Failure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }
      final String userId = await authRemoteDatasource
          .loginWithEmailAndPassword(email: email, password: password);
      final UserModel userModel =
          await authRemoteDatasource.getUserData(id: userId);

      return right(userModel);
    } on SignInWithEmailAndPasswordFailure catch (e) {
      return left(Failure(e.message));
    } on FirebaseDataFailure catch (e) {
      return left(Failure(e.message));
    } catch (_) {
      return left(const Failure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
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
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      return left(Failure(e.message));
    } on FirebaseDataFailure catch (e) {
      return left(Failure(e.message));
    } catch (_) {
      return left(const Failure());
    }
  }
}
