import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/profile/domain/usecases/change_profile_picture.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/edit_profile_image_bloc/edit_profile_image_bloc.dart';

class MockChangeProfilePicture extends Mock implements ChangeProfilePicture {}

class FakeChangeProfilePictureParams extends Fake
    implements ChangeProfilePictureParams {}

class FakeFile extends Fake implements File {}

void main() {
  late MockChangeProfilePicture mockChangeProfilePicture;
  late EditProfileImageBloc editProfileImageBloc;

  setUp(() {
    mockChangeProfilePicture = MockChangeProfilePicture();
    editProfileImageBloc =
        EditProfileImageBloc(changeProfilePicture: mockChangeProfilePicture);
    registerFallbackValue(FakeChangeProfilePictureParams());
    registerFallbackValue(FakeFile());
  });
  tearDown(() {
    editProfileImageBloc.close();
  });

  File getFakeImageFile() {
    var fs = MemoryFileSystem();
    final image = fs.file('someimage.png');
    image.writeAsStringSync('contents');
    return image;
  }

  test(
    'should have [EditProfileImageInitial] state when editProfileImage bloc is initialized ',
    () async {
      //assert
      expect(editProfileImageBloc.state, EditProfileImageInitial());
    },
  );
  group('UserLogoutEvent', () {
    const tFailureMessage = 'Failure';
    const tId = '123';
    const tPreviousPictureFilePath = 'previous.png';
    const tNewPictureFilePath = 'new.png';
    const tName = 'test name';
    const tEmail = 'test@example.com';

    const tFileName = 'someimage';

    final fakeImageFile = getFakeImageFile();

    const tAppUser = AppUser(
        id: tId,
        name: tName,
        email: tEmail,
        pictureFilePathFromFirebase: tNewPictureFilePath);
    blocTest<EditProfileImageBloc, EditProfileImageState>(
      'emits [EditProfileImageLoading, EditProfileImageSuccess] when EditUserProfileImageEvent is added and ChangeProfilePicture returns a appUser.',
      setUp: () => when(() => mockChangeProfilePicture(any()))
          .thenAnswer((_) async => const Right(tAppUser)),
      build: () => editProfileImageBloc,
      act: (bloc) => bloc.add(EditUserProfileImageEvent(
        userId: tId,
        pictureFilePathFromFirebase: tPreviousPictureFilePath,
        profileImage: fakeImageFile,
        fileName: tFileName,
      )),
      expect: () => <EditProfileImageState>[
        EditProfileImageLoading(),
        const EditProfileImageSuccess(appUser: tAppUser)
      ],
      verify: (_) {
        verify(() => mockChangeProfilePicture(ChangeProfilePictureParams(
              userId: tId,
              pictureFilePathFromFirebase: tPreviousPictureFilePath,
              profilePicture: fakeImageFile,
              fileName: tFileName,
            ))).called(1);
      },
    );
    blocTest<EditProfileImageBloc, EditProfileImageState>(
      'emits [EditProfileImageLoading, EditProfileImageFailure] when EditUserProfileImageEvent is added and ChangeProfilePicture returns a failure.',
      setUp: () => when(() => mockChangeProfilePicture(any()))
          .thenAnswer((_) async => const Left(Failure(tFailureMessage))),
      build: () => editProfileImageBloc,
      act: (bloc) => bloc.add(EditUserProfileImageEvent(
        userId: tId,
        pictureFilePathFromFirebase: tPreviousPictureFilePath,
        profileImage: fakeImageFile,
        fileName: tFileName,
      )),
      expect: () => <EditProfileImageState>[
        EditProfileImageLoading(),
        const EditProfileImageFailure(message: tFailureMessage)
      ],
    );
  });
}
