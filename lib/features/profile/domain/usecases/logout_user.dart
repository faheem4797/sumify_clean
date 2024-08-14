import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';

class LogoutUser implements UseCase<String, NoParams> {
  final ProfileRepository profileRepository;
  LogoutUser({required this.profileRepository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await profileRepository.signOutUser();
  }
}
