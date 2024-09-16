import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/login_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUser usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUser(authRepository: mockAuthRepository);
  });

  const String tEmail = 'test@example.com';
  const String tPassword = '12345678';
  const tAppUser = AppUser(id: '1', name: 'testName', email: tEmail);

  test(
    'should return an AppUser from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.loginWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => const Right(tAppUser));

      //act
      final result =
          await usecase(LoginUserParams(email: tEmail, password: tPassword));

      //assert
      verify(() => mockAuthRepository.loginWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Right(tAppUser));
    },
  );

  test(
    'should return a Failure from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.loginWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result =
          await usecase(LoginUserParams(email: tEmail, password: tPassword));

      //assert
      verify(() => mockAuthRepository.loginWithEmailAndPassword(
          email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Left(Failure()));
    },
  );
}
