import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';

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

  group('getUserData', () {
    const tId = '123';
    const tName = 'Test User';
    const tEmail = 'test@gmail.com';

    const tUserModel = UserModel(
      id: tId,
      name: tName,
      email: tEmail,
      pictureFilePathFromFirebase: '',
    );

    test(
      'should return UserModel when user document exists in Firestore',
      () async {
        // Arrange
        await fakeFirestore.collection('users').doc(tId).set({
          'id': tId,
          'name': tName,
          'email': tEmail,
          'pictureFilePathFromFirebase': '',
        });

        // Act
        final result = await authRemoteDatasource.getUserData(id: tId);

        // Assert
        expect(result, tUserModel);
      },
    );

    test(
      'should throw FirebaseDataFailure when user document does not exist in Firestore',
      () async {
        // Arrange: Make sure no user data exists in Firestore

        // Act & Assert
        expect(() async => await authRemoteDatasource.getUserData(id: tId),
            throwsA(isA<FirebaseDataFailure>()));
      },
    );

    // test(
    //   'should throw FirebaseDataFailure when there is a FirebaseException',
    //   () async {
    //     // Arrange: Simulate Firestore throwing an exception

    //     // fakeFirestore = FakeFirebaseFirestore(
    //     //   onError: (_) => throw FirebaseException(
    //     //     plugin: 'firestore',
    //     //     code: 'permission-denied',
    //     //   ),
    //     // );
    //     authRemoteDatasource = AuthRemoteDatasourceImpl(
    //         firebaseAuth: mockFirebaseAuth, firebaseFirestore: fakeFirestore);

    //     // Act & Assert
    //     expect(() async => await authRemoteDatasource.getUserData(id: tId),
    //         throwsA(isA<FirebaseDataFailure>()));
    //   },
    // );
  });
}
