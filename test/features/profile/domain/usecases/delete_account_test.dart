import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';
import 'package:sumify_clean/features/profile/domain/usecases/delete_account.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeAppUser extends Fake implements AppUser {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late DeleteAccount usecase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = DeleteAccount(profileRepository: mockProfileRepository);

    registerFallbackValue(FakeAppUser());
  });

  const tEmail = 'test@example.com';
  const tPassword = '12345678';
  const tId = '123';
  const tName = 'test name';
  const tAppUser = AppUser(id: tId, name: tName, email: tEmail);

  const tSuccessMessage = 'Success';

  test(
    'should return String from profile repository when no error occurs',
    () async {
      //arrange
      when(() => mockProfileRepository.deleteAccount(
              email: any(named: 'email'),
              password: any(named: 'password'),
              appUser: any(named: 'appUser')))
          .thenAnswer((_) async => const Right(tSuccessMessage));
      //act
      final result = await usecase(const DeleteAccountParams(
          email: tEmail, password: tPassword, appUser: tAppUser));
      //assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockProfileRepository.deleteAccount(
          email: tEmail, password: tPassword, appUser: tAppUser));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );

  test(
    'should return Failure from profile repository when some error occurs',
    () async {
      //arrange
      when(() => mockProfileRepository.deleteAccount(
              email: any(named: 'email'),
              password: any(named: 'password'),
              appUser: any(named: 'appUser')))
          .thenAnswer((_) async => const Left(Failure()));
      //act
      final result = await usecase(const DeleteAccountParams(
          email: tEmail, password: tPassword, appUser: tAppUser));
      //assert
      expect(result, const Left(Failure()));
      verify(() => mockProfileRepository.deleteAccount(
          email: tEmail, password: tPassword, appUser: tAppUser));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
