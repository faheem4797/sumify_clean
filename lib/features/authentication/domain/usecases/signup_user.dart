import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/entities/app_user.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class SignupUser implements UseCase<AppUser, SignupUserParams> {
  final AuthRepository authRepository;
  SignupUser({required this.authRepository});

  @override
  Future<Either<Failure, AppUser>> call(SignupUserParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignupUserParams {
  final String name;
  final String email;
  final String password;
  SignupUserParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
