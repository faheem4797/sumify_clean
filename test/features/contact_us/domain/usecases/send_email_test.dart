import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/contact_us/domain/repositories/contact_us_repository.dart';
import 'package:sumify_clean/features/contact_us/domain/usecases/send_email.dart';

class MockContactUsRepository extends Mock implements ContactUsRepository {}

void main() {
  late SendEmail sendEmail;
  late MockContactUsRepository mockContactUsRepository;

  setUp(() {
    mockContactUsRepository = MockContactUsRepository();
    sendEmail = SendEmail(contactUsRepository: mockContactUsRepository);
  });

  const tSuccessMessage = 'Success';
  const tFirstName = 'first name';
  const tLastName = 'last name';
  const tEmail = 'test@example.com';
  const tMessage = 'Message';

  test(
    'should return a string from the contact repository',
    () async {
      //arrange
      when(() => mockContactUsRepository.sendEmail(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            message: any(named: 'message'),
          )).thenAnswer((_) async => const Right(tSuccessMessage));

      //act
      final result = await sendEmail(const SendEmailParams(
        email: tEmail,
        firstName: tFirstName,
        lastName: tLastName,
        message: tMessage,
      ));

      //assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockContactUsRepository.sendEmail(
            firstName: tFirstName,
            lastName: tLastName,
            email: tEmail,
            message: tMessage,
          )).called(1);
    },
  );

  test(
    'should return failure from the contact repository',
    () async {
      //arrange
      when(() => mockContactUsRepository.sendEmail(
            firstName: any(named: 'firstName'),
            lastName: any(named: 'lastName'),
            email: any(named: 'email'),
            message: any(named: 'message'),
          )).thenAnswer((_) async => left(const Failure()));
      //act
      final result = await sendEmail(const SendEmailParams(
        email: tEmail,
        firstName: tFirstName,
        lastName: tLastName,
        message: tMessage,
      ));

      //assert
      expect(result, const Left(Failure()));
      verify(() => mockContactUsRepository.sendEmail(
            firstName: tFirstName,
            lastName: tLastName,
            email: tEmail,
            message: tMessage,
          )).called(1);
    },
  );
}
