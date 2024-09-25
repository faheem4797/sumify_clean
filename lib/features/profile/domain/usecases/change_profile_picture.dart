import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';

class ChangeProfilePicture
    implements UseCase<AppUser, ChangeProfilePictureParams> {
  final ProfileRepository profileRepository;

  ChangeProfilePicture({required this.profileRepository});
  @override
  Future<Either<Failure, AppUser>> call(
      ChangeProfilePictureParams params) async {
    return await profileRepository.changeProfilePicture(
      userId: params.userId,
      pictureFilePathFromFirebase: params.pictureFilePathFromFirebase,
      profilePicture: params.profilePicture,
      fileName: params.fileName,
    );
  }
}

class ChangeProfilePictureParams extends Equatable {
  final String userId;
  final String pictureFilePathFromFirebase;
  final File profilePicture;
  final String fileName;

  const ChangeProfilePictureParams({
    required this.userId,
    required this.pictureFilePathFromFirebase,
    required this.profilePicture,
    required this.fileName,
  });

  @override
  List<Object?> get props =>
      [userId, pictureFilePathFromFirebase, profilePicture, fileName];
}
