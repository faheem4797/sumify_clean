import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
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

class SignupUserParams extends Equatable {
  final String name;
  final String email;
  final String password;
  const SignupUserParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
