import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late AuthRemoteDatasourceImpl authRemoteDatasourceImpl;
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;

  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(
        firebaseAuth: mockFirebaseAuth, firebaseFirestore: fakeFirestore);
  });

  const tUsersCollectionPath = 'users';
  const tId = '123';
  const tName = 'Test User';
  const tEmail = 'test@gmail.com';
  const tPassword = '12345678';

  const tUserNotFoundError = 'User not found';
  const tPermissionDeniedErrorCode = 'permission-denied';
  const tPermissionDeniedErrorMessage = 'Permission denied.';
  const tInvalidEmailErrorCode = 'invalid-email';
  const tInvalidEmailErrorMessage = 'Email is not valid or badly formatted.';

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

  void setUpFuncToReturnNullUser(
      Future<UserCredential> Function(
              {required String email, required String password})
          function) {
    when(() => function(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);
    when(() => mockUserCredential.user).thenReturn(null);
  }

  void setUpFuncToReturnUID(
      Future<UserCredential> Function(
              {required String email, required String password})
          function) {
    when(() => function(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => mockUserCredential);

    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn(tId);
  }

  void setUpFunctToThrowFirebaseAuthExceptionWithCode(
      Future<UserCredential> Function(
              {required String email, required String password})
          function) {
    when(() => function(
            email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(FirebaseAuthException(code: tInvalidEmailErrorCode));
  }

  void setUpAuthFuncToThrowException(
      Future<UserCredential> Function(
              {required String email, required String password})
          authFunction) {
    when(() => authFunction(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception());
  }

  void setUpFirestoreFuncToThrowException(Symbol symbol) {
    final tDocReference =
        fakeFirestore.collection(tUsersCollectionPath).doc(tId);

    whenCalling(Invocation.method(symbol, null))
        .on(tDocReference)
        .thenThrow(Exception());
  }

  void setUpFuncToThrowFirebaseException(Symbol symbol) {
    final tDocReference =
        fakeFirestore.collection(tUsersCollectionPath).doc(tId);

    whenCalling(Invocation.method(symbol, null)).on(tDocReference).thenThrow(
        FirebaseException(
            plugin: 'firestore', code: tPermissionDeniedErrorCode));
  }

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
        final result = await authRemoteDatasourceImpl.getUserData(id: tId);

        // Assert
        expect(result, tUserModel);
      },
    );

    test(
        'should throw FirebaseDataFailure with User Not Found when no such document exists ',
        () async {
      //Act
      final resultCall = authRemoteDatasourceImpl.getUserData;
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
      final resultCall = authRemoteDatasourceImpl.getUserData;
      //Assert
      expect(() async => await resultCall(id: tId),
          throwsA(const FirebaseDataFailure(tUserNotFoundError)));
    });

    test(
      'should throw FirebaseDataFailure with proper message when FirebaseException occurs while getting data',
      () async {
        // Arrange:
        setUpFuncToThrowFirebaseException(#get);

        //Act
        final resultCall = authRemoteDatasourceImpl.getUserData;

        //Assert
        expect(() async => await resultCall(id: tId),
            throwsA(const FirebaseDataFailure(tPermissionDeniedErrorMessage)));
      },
    );
    test(
      'should throw FirebaseDataFailure when a general exception occurs while getting data',
      () async {
        // Arrange:
        setUpFirestoreFuncToThrowException(#get);

        //Act
        final resultCall = authRemoteDatasourceImpl.getUserData;

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
        await authRemoteDatasourceImpl.setUserData(userModel: tUserModel);

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
        setUpFuncToThrowFirebaseException(#set);

        //Act
        final resultCall = authRemoteDatasourceImpl.setUserData;

        //Assert
        expect(() async => await resultCall(userModel: tUserModel),
            throwsA(const FirebaseDataFailure(tPermissionDeniedErrorMessage)));
      },
    );

    test(
      'should throw FirebaseDataFailure when a general exception occurs while setting data',
      () async {
        // Arrange:
        setUpFirestoreFuncToThrowException(#set);

        //Act
        final resultCall = authRemoteDatasourceImpl.setUserData;

        //Assert
        expect(() async => await resultCall(userModel: tUserModel),
            throwsA(const FirebaseDataFailure()));
      },
    );
  });

  group('loginWithEmailAndPassword', () {
    test(
      'should return uid of user when signInWithEmailAndPassword is a success',
      () async {
        //arrange
        setUpFuncToReturnUID(mockFirebaseAuth.signInWithEmailAndPassword);

        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn(tId);

        //act
        final result = await authRemoteDatasourceImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result, tId);
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
      },
    );

    test(
      'should throw SignInWithEmailAndPasswordFailure when user is null',
      () async {
        //arrange
        setUpFuncToReturnNullUser(mockFirebaseAuth.signInWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.loginWithEmailAndPassword;
        //assert
        expect(() async => await result(email: tEmail, password: tPassword),
            throwsA(const SignInWithEmailAndPasswordFailure('User is null!')));
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
      },
    );
    test(
      'should throw SignInWithEmailAndPasswordFailure with a proper message when FirebaseAuthException occurs',
      () async {
        //arrange
        setUpFunctToThrowFirebaseAuthExceptionWithCode(
            mockFirebaseAuth.signInWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.loginWithEmailAndPassword;
        //assert
        expect(
            () async => await result(email: tEmail, password: tPassword),
            throwsA(const SignInWithEmailAndPasswordFailure(
                tInvalidEmailErrorMessage)));
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verifyNever(() => mockUserCredential.user);
      },
    );

    test(
      'should throw SignInWithEmailAndPasswordFailure when a general exception occurs',
      () async {
        //arrange

        // final a = mockFirebaseAuth.signInWithEmailAndPassword;
        setUpAuthFuncToThrowException(
            mockFirebaseAuth.signInWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.loginWithEmailAndPassword;
        //assert
        expect(() async => await result(email: tEmail, password: tPassword),
            throwsA(const SignInWithEmailAndPasswordFailure()));
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verifyNever(() => mockUserCredential.user);
      },
    );
  });

  group('signupWithEmailAndPassword', () {
    test(
      'should return uid of user when signupWithEmailAndPassword is a success',
      () async {
        //arrange
        setUpFuncToReturnUID(mockFirebaseAuth.createUserWithEmailAndPassword);

        //act
        final result = await authRemoteDatasourceImpl
            .signupWithEmailAndPassword(email: tEmail, password: tPassword);

        //assert
        expect(result, tId);
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
      },
    );

    test(
      'should throw SignUpWithEmailAndPasswordFailure when user is null',
      () async {
        //arrange
        setUpFuncToReturnNullUser(
            mockFirebaseAuth.createUserWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.signupWithEmailAndPassword;
        //assert
        expect(() async => await result(email: tEmail, password: tPassword),
            throwsA(const SignUpWithEmailAndPasswordFailure('User is null!')));
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
      },
    );
    test(
      'should throw SignUpWithEmailAndPasswordFailure with a proper message when FirebaseAuthException occurs',
      () async {
        //arrange
        setUpFunctToThrowFirebaseAuthExceptionWithCode(
            mockFirebaseAuth.createUserWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.signupWithEmailAndPassword;
        //assert
        expect(
            () async => await result(email: tEmail, password: tPassword),
            throwsA(const SignUpWithEmailAndPasswordFailure(
                tInvalidEmailErrorMessage)));
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verifyNever(() => mockUserCredential.user);
      },
    );

    test(
      'should throw SignUpWithEmailAndPasswordFailure when a general exception occurs',
      () async {
        //arrange
        setUpAuthFuncToThrowException(
            mockFirebaseAuth.createUserWithEmailAndPassword);

        //act
        final result = authRemoteDatasourceImpl.signupWithEmailAndPassword;
        //assert
        expect(() async => await result(email: tEmail, password: tPassword),
            throwsA(const SignUpWithEmailAndPasswordFailure()));
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verifyNever(() => mockUserCredential.user);
      },
    );
  });
}
