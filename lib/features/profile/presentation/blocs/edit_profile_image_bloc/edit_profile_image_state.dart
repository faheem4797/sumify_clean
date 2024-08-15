part of 'edit_profile_image_bloc.dart';

sealed class EditProfileImageState extends Equatable {
  const EditProfileImageState();

  @override
  List<Object> get props => [];
}

final class EditProfileImageInitial extends EditProfileImageState {}

final class EditProfileImageLoading extends EditProfileImageState {}

final class EditProfileImageSuccess extends EditProfileImageState {
  final AppUser appUser;

  const EditProfileImageSuccess({required this.appUser});
  @override
  List<Object> get props => [appUser];
}

final class EditProfileImageFailure extends EditProfileImageState {
  final String message;

  const EditProfileImageFailure({required this.message});
  @override
  List<Object> get props => [message];
}
