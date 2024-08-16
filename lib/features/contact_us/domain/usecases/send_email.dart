import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/contact_us/domain/repositories/contact_us_repository.dart';

class SendEmail implements UseCase<String, SendEmailParams> {
  final ContactUsRepository contactUsRepository;

  SendEmail({required this.contactUsRepository});
  @override
  Future<Either<Failure, String>> call(SendEmailParams params) async {
    return await contactUsRepository.sendEmail(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      message: params.message,
    );
  }
}

class SendEmailParams {
  final String firstName;
  final String lastName;
  final String email;
  final String message;

  SendEmailParams(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.message});
}
