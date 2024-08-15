part of 'edit_profile_image_bloc.dart';

sealed class EditProfileImageEvent extends Equatable {
  const EditProfileImageEvent();

  @override
  List<Object> get props => [];
}

final class EditUserProfileImageEvent extends EditProfileImageEvent {
  final String userId;
  final String pictureFilePathFromFirebase;
  final File profileImage;
  final String fileName;

  const EditUserProfileImageEvent({
    required this.userId,
    required this.pictureFilePathFromFirebase,
    required this.profileImage,
    required this.fileName,
  });
  @override
  List<Object> get props => [
        userId,
        pictureFilePathFromFirebase,
        profileImage,
        fileName,
      ];
}
