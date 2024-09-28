import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/features/profile/data/datasources/profile_remote_datasource.dart';

import 'package:file/memory.dart';

//Firebase Storage Mocks package was not working correctly particularly its delete functionality from refFromUrl
//So in these tests i have mocked firebase storage and other related classes myself and used mocktail

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class FakeFile extends Fake implements File {}

void main() {
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImpl;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  late MockFirebaseStorage mockFirebaseStorage;
  late MockReference mockReference;
  late MockUploadTask mockUploadTask;
  late MockTaskSnapshot mockTaskSnapshot;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();
    mockFirebaseStorage = MockFirebaseStorage();
    mockReference = MockReference();
    mockUploadTask = MockUploadTask();
    mockTaskSnapshot = MockTaskSnapshot();
    fakeFirestore = FakeFirebaseFirestore();
    profileRemoteDataSourceImpl = ProfileRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firebaseStorage: mockFirebaseStorage,
      firebaseFirestore: fakeFirestore,
    );

    registerFallbackValue(MockAuthCredential());
    registerFallbackValue(FakeFile());
  });
  const tUsersCollectionPath = 'users';

  const tEmail = 'test@example.com';
  const tId = '123';
  const tPassword = '12345678';
  const tName = 'test name';
  const tPictureFilePathFromFirebase = 'image/link';
  const tFileName = 'fileName';
  const tUpdatedProfileUrl = 'new/image/url';
  const tLocalFilename = 'someimage.png';

  const tNotFoundErrorCode = 'not-found';
  const tNotFoundErrorMessage = 'Document not found.';
  const tPermissionDeniedErrorCode = 'permission-denied';
  const tPermissionDeniedErrorMessage = 'Permission denied.';

  const tUserModel = UserModel(
      id: tId,
      name: tName,
      email: tEmail,
      pictureFilePathFromFirebase: tUpdatedProfileUrl);

  const tUserModelMap = {
    'id': tId,
    'name': tName,
    'email': tEmail,
    'pictureFilePathFromFirebase': tUpdatedProfileUrl
  };

  const String tPreviousPictureFilePath =
      'https://example.com/previousImage.png';
  const String tProfileImageUrlDownload = 'https://example.com/newImage.png';

  void setUpFirestoreFuncToThrowException(Symbol symbol, Exception exception) {
    final tDocReference =
        fakeFirestore.collection(tUsersCollectionPath).doc(tId);

    whenCalling(Invocation.method(symbol, null))
        .on(tDocReference)
        .thenThrow(exception);
  }

  void setUpMockUserSuccess() {
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.reauthenticateWithCredential(any()))
        .thenAnswer((_) async => mockUserCredential);
    when(() => mockUserCredential.user).thenReturn(mockUser);
  }

  void setUpDeleteUserAccountSuccess() {
    setUpMockUserSuccess();
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.delete()).thenAnswer((_) async {});
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
  }

  void setUpUploadProfileImageToException(Exception exception) {
    when(() => mockFirebaseStorage.ref()).thenReturn(mockReference);
    when(() => mockReference.child(any())).thenReturn(mockReference);
    when(() => mockReference.putFile(any())).thenThrow(exception);
  }

  void setUpUploadProfileImageToSuccess() {
    when(() => mockFirebaseStorage.ref()).thenReturn(mockReference);
    when(() => mockReference.child(any())).thenReturn(mockReference);
    when(() => mockReference.putFile(any())).thenAnswer((_) => mockUploadTask);
    when(() => mockUploadTask.whenComplete(any()))
        .thenAnswer((_) async => mockTaskSnapshot);
    when(() => mockTaskSnapshot.ref).thenReturn(mockReference);
    when(() => mockReference.getDownloadURL())
        .thenAnswer((_) async => tProfileImageUrlDownload);
  }

  File getFakeImageFile() {
    var fs = MemoryFileSystem();
    final image = fs.file(tLocalFilename);
    image.writeAsStringSync('contents');
    return image;
  }

  group('updateUserData', () {
    test(
      'should update the user data at the specified user id document',
      () async {
        //arrange
        await fakeFirestore
            .collection(tUsersCollectionPath)
            .doc(tId)
            .set(tUserModel.toMap());
        await profileRemoteDataSourceImpl.updateUserData(
            userId: tId, newPictureFilePathFromFirebase: tUpdatedProfileUrl);

        //act
        final result =
            await fakeFirestore.collection(tUsersCollectionPath).doc(tId).get();

        //assert
        expect(result.data(), tUserModelMap);
      },
    );

    test(
      'should throw FirebaseDataFailure when Firebase Exception occurs ',
      () async {
        //act
        final resultCall = profileRemoteDataSourceImpl.updateUserData;

        //assert
        expect(
            () async => await resultCall(
                userId: tId,
                newPictureFilePathFromFirebase: tUpdatedProfileUrl),
            throwsA(const FirebaseDataFailure(tNotFoundErrorMessage)));
      },
    );
    test(
      'should throw FirebaseDataFailure when generic Exception occurs ',
      () async {
        //arange
        setUpFirestoreFuncToThrowException(#update, Exception());
        //act
        final resultCall = profileRemoteDataSourceImpl.updateUserData;

        //assert
        expect(
            () async => await resultCall(
                userId: tId,
                newPictureFilePathFromFirebase: tUpdatedProfileUrl),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });

  group('getUserData', () {
    test(
      'should return UserModel when user document exists in Firestore',
      () async {
        // Arrange
        await fakeFirestore
            .collection(tUsersCollectionPath)
            .doc(tId)
            .set(tUserModelMap);

        // Act
        final result =
            await profileRemoteDataSourceImpl.getUserData(userId: tId);

        // Assert
        expect(result, tUserModel);
      },
    );

    test(
        'should throw FirebaseDataFailure with User Not Found when no such document exists ',
        () async {
      //Act
      final resultCall = profileRemoteDataSourceImpl.getUserData;
      //Assert
      expect(
          () async => await resultCall(userId: tId),
          throwsA(const FirebaseDataFailure(
              Constants.userDataNotFoundErrorMessage)));
    });
    test(
        'should throw FirebaseDataFailure with User Not Found when an empty document exists ',
        () async {
      // Arrange:
      await fakeFirestore.collection(tUsersCollectionPath).doc(tId).set({});

      // Act
      final resultCall = profileRemoteDataSourceImpl.getUserData;
      //Assert
      expect(
          () async => await resultCall(userId: tId),
          throwsA(const FirebaseDataFailure(
              Constants.userDataNotFoundErrorMessage)));
    });

    test(
      'should throw FirebaseDataFailure with proper message when FirebaseException occurs while getting data',
      () async {
        // Arrange:
        setUpFirestoreFuncToThrowException(#get,
            FirebaseException(plugin: 'firestore', code: tNotFoundErrorCode));

        //Act
        final resultCall = profileRemoteDataSourceImpl.getUserData;

        //Assert
        expect(() async => await resultCall(userId: tId),
            throwsA(const FirebaseDataFailure(tNotFoundErrorMessage)));
      },
    );
    test(
      'should throw FirebaseDataFailure when a general exception occurs while getting data',
      () async {
        // Arrange:
        setUpFirestoreFuncToThrowException(#get, Exception());

        //Act
        final resultCall = profileRemoteDataSourceImpl.getUserData;

        //Assert
        expect(() async => await resultCall(userId: tId),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });
  group('deleteUserData', () {
    test(
      'should delete userdata from firestore and firebase storage',
      () async {
        //arrange

        when(() => mockFirebaseStorage.refFromURL(any()))
            .thenReturn(mockReference);
        when(() => mockReference.delete())
            .thenAnswer((_) async => Future.value());

        final newUserModel = UserModel(
            id: tUserModel.id,
            name: tUserModel.name,
            email: tUserModel.email,
            pictureFilePathFromFirebase: tPreviousPictureFilePath);

        await fakeFirestore
            .collection(tUsersCollectionPath)
            .doc(tId)
            .set(newUserModel.toMap());

        // act
        await profileRemoteDataSourceImpl.deleteUserData(
            userId: newUserModel.id,
            filePathFromFirebasae: newUserModel.pictureFilePathFromFirebase!);

        //assert
        final userDoc =
            await fakeFirestore.collection(tUsersCollectionPath).doc(tId).get();
        expect(userDoc.exists, false);

        verify(() => mockFirebaseStorage
            .refFromURL(newUserModel.pictureFilePathFromFirebase!)
            .delete()).called(1);
      },
    );

    test(
      'should return FirebaseDataFailure with a proper message when Firebase Exception occurs',
      () async {
        //arrange
        setUpFirestoreFuncToThrowException(#delete,
            FirebaseException(plugin: 'firestore', code: tNotFoundErrorCode));

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserData;

        //assert
        expect(
            () async => await resultCall(
                userId: tId,
                filePathFromFirebasae: tPictureFilePathFromFirebase),
            throwsA(const FirebaseDataFailure(tNotFoundErrorMessage)));
      },
    );
    test(
      'should throw a FirebaseDataFailure when a generic exception occurs',
      () async {
        //arrange
        setUpFirestoreFuncToThrowException(#delete, Exception());

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserData;

        //assert
        expect(
            () async => await resultCall(
                userId: tId,
                filePathFromFirebasae: tPictureFilePathFromFirebase),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });

  group('signOutUser', () {
    test(
      'should sign out the current user',
      () async {
        //arrange
        when(() => mockFirebaseAuth.signOut())
            .thenAnswer((_) async => Future.value());

        //act
        final result = await profileRemoteDataSourceImpl.signOutUser();

        //assert
        expect(result, Constants.userSignOutSuccessMessage);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should throw a SignOutFailure expection when a Firebase Exceptio occurs',
      () async {
        //arrange
        when(() => mockFirebaseAuth.signOut()).thenThrow(
            FirebaseException(plugin: 'firebase auth', code: 'failure'));

        //act
        final resultCall = profileRemoteDataSourceImpl.signOutUser;

        //assert
        expect(() async => await resultCall(),
            throwsA(const SignOutFailure('failure')));
      },
    );
    test(
      'should throw a SignOutFailure expection with message if exists when a Firebase Exceptio occurs',
      () async {
        //arrange
        when(() => mockFirebaseAuth.signOut()).thenThrow(FirebaseException(
            plugin: 'firebase auth',
            code: 'failure',
            message: 'failure message'));

        //act
        final resultCall = profileRemoteDataSourceImpl.signOutUser;

        //assert
        expect(() async => await resultCall(),
            throwsA(const SignOutFailure('failure message')));
      },
    );

    test(
      'should throw SignOutFailure when a generic exception occurs',
      () async {
        //arrange
        when(() => mockFirebaseAuth.signOut()).thenThrow(Exception());

        //act
        final resultCall = profileRemoteDataSourceImpl.signOutUser;

        //assert
        expect(() async => await resultCall(), throwsA(const SignOutFailure()));
      },
    );
  });

  group('deleteUserAccount', () {
    test('should call reauthenticateWithCredential with correct credentials',
        () async {
      // Arrange
      setUpDeleteUserAccountSuccess();

      // Act
      await profileRemoteDataSourceImpl.deleteUserAccount(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      final capturedAuthCredential =
          verify(() => mockUser.reauthenticateWithCredential(captureAny()))
              .captured
              .first as AuthCredential;
      expect(capturedAuthCredential, isA<EmailAuthCredential>());
      final emailCredential = capturedAuthCredential as EmailAuthCredential;
      expect(emailCredential.email, tEmail);
      expect(emailCredential.password, tPassword);
    });

    test('should delete user account when reauthentication is successful',
        () async {
      // Arrange
      setUpDeleteUserAccountSuccess();

      // Act
      await profileRemoteDataSourceImpl.deleteUserAccount(
          email: tEmail, password: tPassword);

      // Assert
      verify(() => mockUser.reauthenticateWithCredential(any())).called(1);
      verify(() => mockUser.delete()).called(1);
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
    test(
      'should throw ReauthenticateUserFailure with proper message when current user returns null',
      () async {
        //arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserAccount;

        //assert
        expect(
            () async => await resultCall(email: tEmail, password: tPassword),
            throwsA(const ReauthenticateUserFailure(
                Constants.retryAfterLoggingInErrorMessage)));
      },
    );

    test(
      'should throw ReauthenticationUserFailure with proper message when reauthenticated email does not match the provided email',
      () async {
        //arrange
        setUpMockUserSuccess();
        when(() => mockUser.email).thenReturn('wrongEmail@gmail.com');

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserAccount;

        //assert
        expect(
            () async => await resultCall(email: tEmail, password: tPassword),
            throwsA(const ReauthenticateUserFailure(
                Constants.userMatchNotFoundErrorMessage)));
      },
    );

    test(
      'should throw ReAuthenticationFailure when Firebase Exception occurs',
      () async {
        //arrange
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.reauthenticateWithCredential(any())).thenThrow(
            FirebaseException(code: 'user-mismatch', plugin: 'auth'));

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserAccount;

        //assert
        expect(
            () async => await resultCall(email: tEmail, password: tPassword),
            throwsA(ReauthenticateUserFailure(
                ReauthenticateUserFailure.fromCode('user-mismatch').message)));
      },
    );

    test(
      'should throw ReauthenticateUserFailure when a generic exception occurs',
      () async {
        //arrange
        when(() => mockFirebaseAuth.currentUser).thenThrow(Exception());

        //act
        final resultCall = profileRemoteDataSourceImpl.deleteUserAccount;

        //assert
        expect(() async => await resultCall(email: tEmail, password: tPassword),
            throwsA(const ReauthenticateUserFailure()));
      },
    );
  });

  group('uploadProfileImage', () {
    test('should upload image and return profile image URL', () async {
      // Arrange
      final tFakeImageFile = getFakeImageFile();
      setUpUploadProfileImageToSuccess();
      when(() => mockFirebaseStorage.refFromURL(any()))
          .thenReturn(mockReference);
      when(() => mockReference.delete())
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await profileRemoteDataSourceImpl.uploadProfileImage(
        image: tFakeImageFile,
        fileName: tFileName,
        userId: tId,
        previousPictureFilePathFromFirebase: tPreviousPictureFilePath,
      );

      // Assert
      expect(result, tProfileImageUrlDownload);
      verify(() => mockReference.putFile(any())).called(1);
      verify(() => mockReference.getDownloadURL()).called(1);
      verify(() => mockReference.delete()).called(1);
    });
    test(
      'should not make a call to firebaseStorage for deletion when previous image is empty',
      () async {
        //arrange
        final tFakeImageFile = getFakeImageFile();
        setUpUploadProfileImageToSuccess();

        //act
        final result = await profileRemoteDataSourceImpl.uploadProfileImage(
          image: tFakeImageFile,
          fileName: tFileName,
          userId: tId,
          previousPictureFilePathFromFirebase: '',
        );

        //assert
        expect(result, tProfileImageUrlDownload);
        verify(() => mockReference.putFile(any())).called(1);
        verify(() => mockReference.getDownloadURL()).called(1);
        verifyNever(() => mockReference.delete());
      },
    );

    test(
      'should throw FirebaseDataFailure with a proper message when Firebase Exception occurs',
      () async {
        //arrange
        final tFakeImageFile = getFakeImageFile();
        setUpUploadProfileImageToException(FirebaseException(
            plugin: 'firebase_storage', code: tPermissionDeniedErrorCode));

        //act
        final resultCall = profileRemoteDataSourceImpl.uploadProfileImage;

        //assert

        expect(
          () async => await resultCall(
            image: tFakeImageFile,
            fileName: tFileName,
            userId: tId,
            previousPictureFilePathFromFirebase: tPreviousPictureFilePath,
          ),
          throwsA(const FirebaseDataFailure(tPermissionDeniedErrorMessage)),
        );
      },
    );
    test(
      'should throw FirebaseDataFailure when a generic exception occurs',
      () async {
        //arrange
        final tFakeImageFile = getFakeImageFile();
        setUpUploadProfileImageToException(Exception());

        //act
        final resultCall = profileRemoteDataSourceImpl.uploadProfileImage;

        //assert

        expect(
          () async => await resultCall(
            image: tFakeImageFile,
            fileName: tFileName,
            userId: tId,
            previousPictureFilePathFromFirebase: tPreviousPictureFilePath,
          ),
          throwsA(const FirebaseDataFailure()),
        );
      },
    );
  });
}
