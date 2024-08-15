import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';

class ChangeProfilePicture
    implements UseCase<AppUser, ChangeProfilePictureParams> {
  @override
  Future<Either<Failure, AppUser>> call(ChangeProfilePictureParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class ChangeProfilePictureParams {
  final String userId;
  final String pictureFilePathFromFirebase;
  final File profilePicture;
  final String fileName;

  ChangeProfilePictureParams({
    required this.userId,
    required this.pictureFilePathFromFirebase,
    required this.profilePicture,
    required this.fileName,
  });
}
