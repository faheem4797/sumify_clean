import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/authentication/domain/repositories/auth_repository.dart';
import 'package:sumify_clean/features/authentication/domain/usecases/current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CurrentUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CurrentUser(authRepository: mockAuthRepository);
  });

  const tAppUser = AppUser(id: '1', name: 'testName', email: 'testEmail');

  test(
    'should return the current App User from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.currentUser())
          .thenAnswer((_) async => const Right(tAppUser));
      //act
      final result = await usecase(NoParams());

      //assert
      expect(result, const Right(tAppUser));
      verify(() => mockAuthRepository.currentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
  test(
    'should return a Failure from the repository',
    () async {
      //arrange
      when(() => mockAuthRepository.currentUser())
          .thenAnswer((_) async => const Left(Failure()));
      //act
      final result = await usecase(NoParams());

      //assert
      expect(result, const Left(Failure()));
      verify(() => mockAuthRepository.currentUser()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
