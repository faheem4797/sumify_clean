import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/features/profile/domain/usecases/change_profile_picture.dart';

part 'edit_profile_image_event.dart';
part 'edit_profile_image_state.dart';

class EditProfileImageBloc
    extends Bloc<EditProfileImageEvent, EditProfileImageState> {
  final ChangeProfilePicture _changeProfilePicture;
  EditProfileImageBloc({required ChangeProfilePicture changeProfilePicture})
      : _changeProfilePicture = changeProfilePicture,
        super(EditProfileImageInitial()) {
    on<EditProfileImageEvent>((_, emit) => emit(EditProfileImageLoading()));
    on<EditUserProfileImageEvent>(_editUserProfileImageEvent);
  }

  FutureOr<void> _editUserProfileImageEvent(EditUserProfileImageEvent event,
      Emitter<EditProfileImageState> emit) async {
    final response = await _changeProfilePicture(ChangeProfilePictureParams(
      userId: event.userId,
      pictureFilePathFromFirebase: event.pictureFilePathFromFirebase,
      profilePicture: event.profileImage,
      fileName: event.fileName,
    ));
    response.fold(
      (l) => emit(EditProfileImageFailure(message: l.message)),
      (r) => emit(EditProfileImageSuccess(appUser: r)),
    );
  }
}
