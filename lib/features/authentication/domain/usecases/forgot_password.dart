import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';

class ForgotPassword implements UseCase<String, ForgotPasswordParams> {
  final AuthRepository authRepository;
  ForgotPassword({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) async {
    return await authRepository.forgotUserPassword(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}
