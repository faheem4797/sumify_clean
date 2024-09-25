import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';

class DeleteAccount implements UseCase<String, DeleteAccountParams> {
  final ProfileRepository profileRepository;

  DeleteAccount({required this.profileRepository});
  @override
  Future<Either<Failure, String>> call(DeleteAccountParams params) async {
    return await profileRepository.deleteAccount(
      email: params.email,
      password: params.password,
      appUser: params.appUser,
    );
  }
}

class DeleteAccountParams extends Equatable {
  final String email;
  final String password;
  final AppUser appUser;

  const DeleteAccountParams(
      {required this.email, required this.password, required this.appUser});

  @override
  List<Object?> get props => [email, password, appUser];
}
