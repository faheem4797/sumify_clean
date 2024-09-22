import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/forgot_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ForgotPassword usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = ForgotPassword(authRepository: mockAuthRepository);
  });

  const String tSuccess = 'Success';
  const String tEmail = 'test@example.com';

  test(
    'should return a String from the repository',
    () async {
      //arrange
      when(() =>
              mockAuthRepository.forgotUserPassword(email: any(named: 'email')))
          .thenAnswer((_) async => const Right(tSuccess));

      //act
      final result = await usecase(const ForgotPasswordParams(email: tEmail));

      //assert
      verify(() => mockAuthRepository.forgotUserPassword(email: tEmail))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Right(tSuccess));
    },
  );

  test(
    'should return a Failure from the repository',
    () async {
      //arrange
      when(() =>
              mockAuthRepository.forgotUserPassword(email: any(named: 'email')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result = await usecase(const ForgotPasswordParams(email: tEmail));

      //assert
      verify(() => mockAuthRepository.forgotUserPassword(email: tEmail))
          .called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Left(Failure()));
    },
  );
}
