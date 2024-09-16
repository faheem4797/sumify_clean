import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/signup_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignupUser usecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignupUser(authRepository: mockAuthRepository);
  });

  const String tEmail = 'test@example.com';
  const String tPassword = '12345678';
  const String tName = 'testName';
  const tAppUser = AppUser(id: '1', name: tName, email: tEmail);

  test(
    'should return an AppUser from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(
            named: 'password',
          ))).thenAnswer((_) async => const Right(tAppUser));

      //act
      final result = await usecase(
          SignupUserParams(name: tName, email: tEmail, password: tPassword));

      //assert
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
          name: tName, email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Right(tAppUser));
    },
  );

  test(
    'should return a Failure from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
              name: any(named: 'name'),
              email: any(named: 'email'),
              password: any(named: 'password')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result = await usecase(
          SignupUserParams(name: tName, email: tEmail, password: tPassword));

      //assert
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
          name: tName, email: tEmail, password: tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
      expect(result, const Left(Failure()));
    },
  );
}
