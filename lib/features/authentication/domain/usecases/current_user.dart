import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/entities/app_user.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class CurrentUser implements UseCase<AppUser, NoParams> {
  final AuthRepository authRepository;
  CurrentUser({required this.authRepository});
  @override
  Future<Either<Failure, AppUser>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
