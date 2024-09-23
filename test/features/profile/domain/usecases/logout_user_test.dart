import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';
import 'package:sumify_clean/features/profile/domain/usecases/logout_user.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late LogoutUser usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = LogoutUser(profileRepository: mockProfileRepository);
  });

  const tSuccessMessage = 'Success';

  test(
    'should return success String from profile repository',
    () async {
      //arrange
      when(() => mockProfileRepository.signOutUser())
          .thenAnswer((_) async => const Right(tSuccessMessage));

      //act
      final result = await usecase(NoParams());

      //assert
      verify(() => mockProfileRepository.signOutUser()).called(1);
      expect(result, const Right(tSuccessMessage));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );

  test(
    'should return a Failure from profile repository',
    () async {
      //arrange
      when(() => mockProfileRepository.signOutUser())
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result = await usecase(NoParams());

      //assert
      verify(() => mockProfileRepository.signOutUser()).called(1);
      expect(result, const Left(Failure()));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
