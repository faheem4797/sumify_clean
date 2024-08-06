import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<AppUser, LoginUserParams> {
  final AuthRepository authRepository;
  LoginUser({required this.authRepository});
  @override
  Future<Either<Failure, AppUser>> call(LoginUserParams params) async {
    return await authRepository.loginWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}
