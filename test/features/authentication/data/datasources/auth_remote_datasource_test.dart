import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  late AuthRemoteDatasourceImpl authRemoteDatasource;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();

    authRemoteDatasource = AuthRemoteDatasourceImpl(
        firebaseAuth: mockFirebaseAuth, firebaseFirestore: fakeFirestore);
  });

  const tUsersCollectionPath = 'users';
  const tId = '123';
  const tName = 'Test User';
  const tEmail = 'test@gmail.com';

  const tUserNotFoundError = 'User not found';
  const tNotFoundErrorCode = 'not-found';
  const tNotFoundErrorMessage = 'Document not found.';
  const tPermissionDeniedErrorCode = 'permission-denied';
  const tPermissionDeniedErrorMessage = 'Permission denied.';

  const tUserModel = UserModel(
    id: tId,
    name: tName,
    email: tEmail,
    pictureFilePathFromFirebase: '',
  );

  const tUserModelMap = {
    'id': tId,
    'name': tName,
    'email': tEmail,
    'pictureFilePathFromFirebase': '',
  };

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
        final result = await authRemoteDatasource.getUserData(id: tId);

        // Assert
        expect(result, tUserModel);
      },
    );

    test(
        'should throw FirebaseDataFailure with User Not Found when no such document exists ',
        () async {
      //Act
      final resultCall = authRemoteDatasource.getUserData;
      //Assert
      expect(() async => await resultCall(id: tId),
          throwsA(const FirebaseDataFailure(tUserNotFoundError)));
    });
    test(
        'should throw FirebaseDataFailure with User Not Found when an empty document exists ',
        () async {
      // Arrange:
      await fakeFirestore.collection(tUsersCollectionPath).doc(tId).set({});

      // Act
      final resultCall = authRemoteDatasource.getUserData;
      //Assert
      expect(() async => await resultCall(id: tId),
          throwsA(const FirebaseDataFailure(tUserNotFoundError)));
    });

    test(
      'should throw FirebaseDataFailure with proper message when FirebaseException occurs while getting data',
      () async {
        // Arrange:
        final tDocReference =
            fakeFirestore.collection(tUsersCollectionPath).doc(tId);

        whenCalling(Invocation.method(#get, null)).on(tDocReference).thenThrow(
            FirebaseException(plugin: 'firestore', code: tNotFoundErrorCode));

        //Act
        final resultCall = authRemoteDatasource.getUserData;

        //Assert
        expect(() async => await resultCall(id: tId),
            throwsA(const FirebaseDataFailure(tNotFoundErrorMessage)));
      },
    );
    test(
      'should throw FirebaseDataFailure when a general exception occurs while getting data',
      () async {
        // Arrange:
        final tDocReference =
            fakeFirestore.collection(tUsersCollectionPath).doc(tId);

        whenCalling(Invocation.method(#get, null))
            .on(tDocReference)
            .thenThrow(Exception());

        //Act
        final resultCall = authRemoteDatasource.getUserData;

        //Assert
        expect(() async => await resultCall(id: tId),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });

  group('setUserData', () {
    test(
      'should set UserModel into firestore',
      () async {
        //arrange
        await authRemoteDatasource.setUserData(userModel: tUserModel);

        //act

        final result = await fakeFirestore
            .collection(tUsersCollectionPath)
            .doc(tUserModel.id)
            .get();

        //assert
        expect(result.data(), tUserModelMap);
      },
    );

    test(
      'should throw FirebaseDataFailure with proper message when FirebaseException occurs while setting data',
      () async {
        // Arrange:
        final tDocReference =
            fakeFirestore.collection(tUsersCollectionPath).doc(tId);

        whenCalling(Invocation.method(#set, null)).on(tDocReference).thenThrow(
            FirebaseException(
                plugin: 'firestore', code: tPermissionDeniedErrorCode));

        //Act
        final resultCall = authRemoteDatasource.setUserData;

        //Assert
        expect(() async => await resultCall(userModel: tUserModel),
            throwsA(const FirebaseDataFailure(tPermissionDeniedErrorMessage)));
      },
    );

    test(
      'should throw FirebaseDataFailure when a general exception occurs while setting data',
      () async {
        // Arrange:
        final tDocReference =
            fakeFirestore.collection(tUsersCollectionPath).doc(tId);

        whenCalling(Invocation.method(#set, null))
            .on(tDocReference)
            .thenThrow(Exception());

        //Act
        final resultCall = authRemoteDatasource.setUserData;

        //Assert
        expect(() async => await resultCall(userModel: tUserModel),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });
}
