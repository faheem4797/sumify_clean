import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositpryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final ConnectionChecker connectionChecker;

  ProfileRepositpryImpl(
      {required this.profileRemoteDataSource, required this.connectionChecker});
  @override
  Future<Either<Failure, AppUser>> changeProfilePicture(
      {required String userId,
      required String pictureFilePathFromFirebase,
      required File profilePicture,
      required String fileName}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }

      String newProfilePictureUrl =
          await profileRemoteDataSource.uploadProfileImage(
        image: profilePicture,
        fileName: fileName,
        userId: userId,
        previousPictureFilePathFromFirebase: pictureFilePathFromFirebase,
      );

      await profileRemoteDataSource.updateUserData(
          userId: userId, newPictureFilePathFromFirebase: newProfilePictureUrl);

      UserModel userModel =
          await profileRemoteDataSource.getUserData(userId: userId);

      return right(userModel);
    } on FirebaseDataFailure catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signOutUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }
      final messageString = await profileRemoteDataSource.signOutUser();

      return right(messageString);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount(
      {required String email,
      required String password,
      required AppUser appUser}) async {
    if (email == appUser.email) {
      try {
        if (!await connectionChecker.isConnected) {
          return left(const Failure(Constants.noConnectionErrorMessage));
        }
        await profileRemoteDataSource.deleteUserAccount(
            email: email, password: password);

        await profileRemoteDataSource.deleteUserData(
            userId: appUser.id,
            filePathFromFirebasae: appUser.pictureFilePathFromFirebase ?? '');
        return right('Account Deleted Successfully!');
      } on ReauthenticateUserFailure catch (e) {
        return left(Failure(e.message));
      } on FirebaseDataFailure catch (e) {
        return left(Failure(e.message));
      } catch (e) {
        return left(Failure(e.toString()));
      }
    }
    return left(const Failure('Wrong Email!'));
  }
}
