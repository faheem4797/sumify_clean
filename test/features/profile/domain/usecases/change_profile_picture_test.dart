import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/profile/domain/repositories/profile_repository.dart';
import 'package:sumify_clean/features/profile/domain/usecases/change_profile_picture.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeFile extends Fake implements File {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late ChangeProfilePicture usecase;
  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = ChangeProfilePicture(profileRepository: mockProfileRepository);
    registerFallbackValue(FakeFile());
  });

  const tEmail = 'test@example.com';
  const tId = '123';
  const tName = 'test name';
  const tPictureFilePathFromFirebase = 'image/link';
  const tFilePath = 'filePath';
  const tFileName = 'fileName';
  final tProfilePicture = File(tFilePath);
  const tAppUser = AppUser(id: tId, name: tName, email: tEmail);

  test(
    'should return AppUser from profile repository when no error occurs',
    () async {
      //arrange
      when(() => mockProfileRepository.changeProfilePicture(
              userId: any(named: 'userId'),
              pictureFilePathFromFirebase:
                  any(named: 'pictureFilePathFromFirebase'),
              profilePicture: any(named: 'profilePicture'),
              fileName: any(named: 'fileName')))
          .thenAnswer((_) async => const Right(tAppUser));

      //act
      final result = await usecase(ChangeProfilePictureParams(
        userId: tId,
        pictureFilePathFromFirebase: tPictureFilePathFromFirebase,
        profilePicture: tProfilePicture,
        fileName: tFileName,
      ));

      //assert
      expect(result, const Right(tAppUser));
      verify(() => mockProfileRepository.changeProfilePicture(
            userId: tId,
            pictureFilePathFromFirebase: tPictureFilePathFromFirebase,
            profilePicture: tProfilePicture,
            fileName: tFileName,
          )).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );

  test(
    'should return Failure from profile repository when some error occurs',
    () async {
      //arrange
      when(() => mockProfileRepository.changeProfilePicture(
              userId: any(named: 'userId'),
              pictureFilePathFromFirebase:
                  any(named: 'pictureFilePathFromFirebase'),
              profilePicture: any(named: 'profilePicture'),
              fileName: any(named: 'fileName')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result = await usecase(ChangeProfilePictureParams(
        userId: tId,
        pictureFilePathFromFirebase: tPictureFilePathFromFirebase,
        profilePicture: tProfilePicture,
        fileName: tFileName,
      ));

      //assert
      expect(result, const Left(Failure()));
      verify(() => mockProfileRepository.changeProfilePicture(
            userId: tId,
            pictureFilePathFromFirebase: tPictureFilePathFromFirebase,
            profilePicture: tProfilePicture,
            fileName: tFileName,
          )).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );
}
