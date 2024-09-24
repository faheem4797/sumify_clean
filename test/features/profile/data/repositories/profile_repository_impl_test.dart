import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/domain/entities/app_user.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sumify_clean/features/profile/data/repositories/profile_repository_impl.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class FakeFile extends Fake implements File {}

void main() {
  late ProfileRepositpryImpl profileRepositpryImpl;
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;
  late MockConnectionChecker mockConnectionChecker;
  setUp(() {
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    mockConnectionChecker = MockConnectionChecker();
    profileRepositpryImpl = ProfileRepositpryImpl(
        profileRemoteDataSource: mockProfileRemoteDataSource,
        connectionChecker: mockConnectionChecker);

    registerFallbackValue(FakeFile());
  });

  const tEmail = 'test@example.com';
  const tId = '123';
  const tPassword = '12345678';
  const tName = 'test name';
  const tPictureFilePathFromFirebase = 'image/link';
  const tFilePath = 'filePath';
  const tFileName = 'fileName';
  final tProfilePicture = File(tFilePath);
  const tUpdatedProfileUrl = 'new/image/url';

  const tUserModel = UserModel(
      id: tId,
      name: tName,
      email: tEmail,
      pictureFilePathFromFirebase: tUpdatedProfileUrl);

  void setUpMockConnectionToBool(bool trueOrFalse) {
    when(() => mockConnectionChecker.isConnected)
        .thenAnswer((_) async => trueOrFalse);
  }

  void setUpMockConnectionToException() {
    when(() => mockConnectionChecker.isConnected)
        .thenThrow(Exception('Unexpected error'));
  }

  void setUpDeleteUserAccountSuccess() {
    when(() => mockProfileRemoteDataSource.deleteUserAccount(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => Future.value());
  }

  void verifyUploadProfileImageCalled() {
    verify(() => mockProfileRemoteDataSource.uploadProfileImage(
            image: tProfilePicture,
            fileName: tFileName,
            userId: tId,
            previousPictureFilePathFromFirebase: tPictureFilePathFromFirebase))
        .called(1);
  }

  void verifyUpdateUserDataAndGetUserDataNeverCalled() {
    verifyNever(() => mockProfileRemoteDataSource.updateUserData(
        userId: any(named: 'userId'),
        newPictureFilePathFromFirebase:
            any(named: 'newPictureFilePathFromFirebase')));
    verifyNever(() =>
        mockProfileRemoteDataSource.getUserData(userId: any(named: 'userId')));
  }

  Future<Either<Failure, AppUser>> actCallForChangeProfilePicture() async {
    return await profileRepositpryImpl.changeProfilePicture(
      userId: tId,
      pictureFilePathFromFirebase: tPictureFilePathFromFirebase,
      profilePicture: tProfilePicture,
      fileName: tFileName,
    );
  }

  group('signOutUser', () {
    const tSuccessMessage = 'Success';
    const tSignOutFailureMessage = 'sign out failuer';

    test(
      'should return a string when internet is connected and function completed normally',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockProfileRemoteDataSource.signOutUser())
            .thenAnswer((_) async => tSuccessMessage);

        //act
        final result = await profileRepositpryImpl.signOutUser();

        //assert
        expect(result, const Right(tSuccessMessage));
        verify(() => mockProfileRemoteDataSource.signOutUser()).called(1);
        verify(() => mockConnectionChecker.isConnected).called(1);
      },
    );

    test(
      'should return a failure with specfic message when internet is not available',
      () async {
        //arrange
        setUpMockConnectionToBool(false);
        //act
        final result = await profileRepositpryImpl.signOutUser();

        //assert
        expect(result, left(const Failure(Constants.noConnectionErrorMessage)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(() => mockProfileRemoteDataSource.signOutUser());
      },
    );

    test(
      'should return failure when signOutUser function throws a SignOutFailure',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockProfileRemoteDataSource.signOutUser())
            .thenThrow(const SignOutFailure(tSignOutFailureMessage));

        //act
        final result = await profileRepositpryImpl.signOutUser();

        //assert
        expect(result, left(const Failure(tSignOutFailureMessage)));
        verify(() => mockProfileRemoteDataSource.signOutUser()).called(1);
        verify(() => mockConnectionChecker.isConnected).called(1);
      },
    );

    test(
      'should return failure when a generic exception happens',
      () async {
        //arrange
        setUpMockConnectionToException();

        //act
        final result = await profileRepositpryImpl.signOutUser();

        //assert
        expect(result, left(const Failure()));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(() => mockProfileRemoteDataSource.signOutUser());
      },
    );
  });

  group('changeProfilePicture', () {
    test(
      'should return appUser when internet is connected and no error occurs',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockProfileRemoteDataSource.uploadProfileImage(
                image: any(named: 'image'),
                fileName: any(named: 'fileName'),
                userId: any(named: 'userId'),
                previousPictureFilePathFromFirebase:
                    any(named: 'previousPictureFilePathFromFirebase')))
            .thenAnswer((_) async => tUpdatedProfileUrl);

        when(() => mockProfileRemoteDataSource.updateUserData(
                userId: any(named: 'userId'),
                newPictureFilePathFromFirebase:
                    any(named: 'newPictureFilePathFromFirebase')))
            .thenAnswer((_) async => Future.value());
        when(
          () => mockProfileRemoteDataSource.getUserData(userId: tId),
        ).thenAnswer((_) async => tUserModel);
        //act
        final result = await actCallForChangeProfilePicture();

        //assert
        expect(result, const Right(tUserModel));
        verifyUploadProfileImageCalled();
        verify(() => mockProfileRemoteDataSource.updateUserData(
            userId: tId,
            newPictureFilePathFromFirebase: tUpdatedProfileUrl)).called(1);
        verify(() => mockProfileRemoteDataSource.getUserData(userId: tId))
            .called(1);
      },
    );

    test(
      'should return a failure when firebaseDataFailure is thrown ',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockProfileRemoteDataSource.uploadProfileImage(
                image: any(named: 'image'),
                fileName: any(named: 'fileName'),
                userId: any(named: 'userId'),
                previousPictureFilePathFromFirebase:
                    any(named: 'previousPictureFilePathFromFirebase')))
            .thenThrow(const FirebaseDataFailure('firebase data failure'));

        //act
        final result = await actCallForChangeProfilePicture();

        //assert
        expect(result, left(const Failure('firebase data failure')));
        verifyUploadProfileImageCalled();
        verifyUpdateUserDataAndGetUserDataNeverCalled();
      },
    );

    test(
      'should return failure when a generic exception occurs',
      () async {
        //arrange
        setUpMockConnectionToException();

        //act
        final result = await actCallForChangeProfilePicture();

        //assert

        expect(result, left(const Failure()));
        verifyNever(() => mockProfileRemoteDataSource.uploadProfileImage(
            image: any(named: 'image'),
            fileName: any(named: 'fileName'),
            userId: any(named: 'userId'),
            previousPictureFilePathFromFirebase:
                any(named: 'previousPictureFilePathFromFirebase')));
        verifyUpdateUserDataAndGetUserDataNeverCalled();
      },
    );
  });

  group('deleteAccount', () {
    const tDifferentEmail = 'test@gmail.com';
    const tDatabaseFailureMessage = 'Firebase Data Failure';
    const tReAuthenticationFailureMessage = 'ReAuthentication Failure';

    test(
      'should return a success String when internet is connected, deleteUserAccount and deleteUserData functions complete successfully',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        setUpDeleteUserAccountSuccess();
        when(() => mockProfileRemoteDataSource.deleteUserData(
                userId: any(named: 'userId'),
                filePathFromFirebasae: any(named: 'filePathFromFirebasae')))
            .thenAnswer((_) => Future.value());

        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result, const Right(Constants.accountDeleteSuccessMessage));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockProfileRemoteDataSource.deleteUserAccount(
            email: tEmail, password: tPassword)).called(1);
        verify(() => mockProfileRemoteDataSource.deleteUserData(
            userId: tId, filePathFromFirebasae: tUpdatedProfileUrl));
        verifyNoMoreInteractions(mockProfileRemoteDataSource);
        verifyNoMoreInteractions(mockConnectionChecker);
      },
    );

    test(
      'should return a failure with a proper message when emails are different',
      () async {
        //arrange

        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tDifferentEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result,
            left(const Failure(Constants.deleteAccountWrongEmailErrorMessage)));
        verifyZeroInteractions(mockConnectionChecker);
        verifyZeroInteractions(mockProfileRemoteDataSource);
      },
    );

    test(
      'should return a failure with connection error message when internet is not available',
      () async {
        //arrange
        setUpMockConnectionToBool(false);

        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result, left(const Failure(Constants.noConnectionErrorMessage)));
        verifyZeroInteractions(mockProfileRemoteDataSource);
      },
    );

    test(
      'should return a failure when deleteUserAccount function throws a ReauthenticateUserFailure',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() =>
            mockProfileRemoteDataSource.deleteUserAccount(
                email: any(named: 'email'),
                password: any(named: 'password'))).thenThrow(
            const ReauthenticateUserFailure(tReAuthenticationFailureMessage));
        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result, left(const Failure(tReAuthenticationFailureMessage)));

        verifyNever(() => mockProfileRemoteDataSource.deleteUserData(
            userId: tId, filePathFromFirebasae: tUpdatedProfileUrl));
      },
    );

    test(
      'should return a failure when deleteUserData function throws a FirebaseDataFailure',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        setUpDeleteUserAccountSuccess();
        when(() => mockProfileRemoteDataSource.deleteUserData(
                userId: any(named: 'userId'),
                filePathFromFirebasae: any(named: 'filePathFromFirebasae')))
            .thenThrow(const FirebaseDataFailure(tDatabaseFailureMessage));

        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result, left(const Failure(tDatabaseFailureMessage)));
      },
    );
    test(
      'should return a failure when a generic exception occurs',
      () async {
        //arrange
        setUpMockConnectionToException();

        //act
        final result = await profileRepositpryImpl.deleteAccount(
            email: tEmail, password: tPassword, appUser: tUserModel);

        //assert
        expect(result, left(const Failure()));
      },
    );
  });
}
