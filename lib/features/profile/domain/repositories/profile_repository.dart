import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, String>> signOutUser();
  Future<Either<Failure, AppUser>> changeProfilePicture({
    required String userId,
    required String pictureFilePathFromFirebase,
    required File profilePicture,
    required String fileName,
  });
}
