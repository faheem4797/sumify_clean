import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositpryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, AppUser>> changeProfilePicture(
      {required String userId,
      required String pictureFilePathFromFirebase,
      required File profilePicture,
      required String fileName}) {
    // TODO: implement changeProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signOutUser() {
    // TODO: implement signOutUser
    throw UnimplementedError();
  }
}
