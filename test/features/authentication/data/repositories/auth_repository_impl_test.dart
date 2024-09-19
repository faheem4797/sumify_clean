import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/error/firebase_firestore_exceptions.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/models/user_model.dart';
import 'package:sumify_clean/features/authentication/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockAuthUser extends Mock implements User {}

void main() {
  late MockAuthRemoteDatasource mockAuthRemoteDatasource;
  late MockConnectionChecker mockConnectionChecker;
  late MockAuthUser mockAuthUser;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDatasource = MockAuthRemoteDatasource();
    mockConnectionChecker = MockConnectionChecker();
    mockAuthUser = MockAuthUser();

    authRepositoryImpl = AuthRepositoryImpl(
        authRemoteDatasource: mockAuthRemoteDatasource,
        connectionChecker: mockConnectionChecker);
  });

  void setUpMockConnectionToBool(bool trueOrFalse) {
    when(() => mockConnectionChecker.isConnected)
        .thenAnswer((_) async => trueOrFalse);
  }

  void setUpMockConnectionToException() {
    when(() => mockConnectionChecker.isConnected)
        .thenThrow(Exception('Unexpected error'));
  }

  void setUpMockAuthUser() {
    when(() => mockAuthRemoteDatasource.getCurrentUser)
        .thenReturn(mockAuthUser);
    when(() => mockAuthUser.uid).thenReturn('123');
    when(() => mockAuthUser.displayName).thenReturn('Test User');
    when(() => mockAuthUser.email).thenReturn('test@example.com');
  }

  void setUpGetCurrentUserToFirebaseAuthException(
      String tFirebaseAuthExceptionErrorCode,
      String? tFirebaseAuthExceptionErrorMessage) {
    when(() => mockAuthRemoteDatasource.getCurrentUser).thenThrow(
        FirebaseAuthException(
            code: tFirebaseAuthExceptionErrorCode,
            message: tFirebaseAuthExceptionErrorMessage));
  }

  void setUpLoginToUID(String tId) {
    when(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'))).thenAnswer((_) async => tId);
  }

  void setUpGetUserDataToUserModel(UserModel userModel) {
    when(() => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')))
        .thenAnswer((_) async => userModel);
  }

  void setUpGetUserDataToFirebaseDataFailure() {
    when(() => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')))
        .thenThrow(const FirebaseDataFailure());
  }

  group('forgotUserPassword', () {
    const tEmail = 'test@gmail.com';
    const tSuccess = 'Success';
    test(
      'should return a string message when forgotPassword function completes correctly when internet is connected',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockAuthRemoteDatasource.forgotUserPassword(
            email: any(named: 'email'))).thenAnswer((_) async => tSuccess);

        //act
        final result =
            await authRepositoryImpl.forgotUserPassword(email: tEmail);

        //assert
        expect(result, right(tSuccess));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.forgotUserPassword(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(mockConnectionChecker);
        verifyNoMoreInteractions(mockAuthRemoteDatasource);
      },
    );
    test(
      'should return a failure when internet is not connected',
      () async {
        //arrange
        setUpMockConnectionToBool(false);

        //act
        final result =
            await authRepositoryImpl.forgotUserPassword(email: tEmail);

        //assert
        expect(result, left(const Failure(Constants.noConnectionErrorMessage)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(
            () => mockAuthRemoteDatasource.forgotUserPassword(email: tEmail));
        verifyNoMoreInteractions(mockConnectionChecker);
      },
    );
    test(
      'should return a failure when SendPasswordResetEmailFailure is thrown by authRemoteDatasource',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockAuthRemoteDatasource.forgotUserPassword(
                email: any(named: 'email')))
            .thenThrow(const SendPasswordResetEmailFailure());

        //act
        final result =
            await authRepositoryImpl.forgotUserPassword(email: tEmail);

        //assert
        expect(result,
            Left(Failure(const SendPasswordResetEmailFailure().message)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.forgotUserPassword(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(mockConnectionChecker);
        verifyNoMoreInteractions(mockAuthRemoteDatasource);
      },
    );
    test(
      'should return a failure when function throws any other exception',
      () async {
        //arrange
        setUpMockConnectionToException();
        //act
        final result =
            await authRepositoryImpl.forgotUserPassword(email: tEmail);

        //assert
        expect(result, isA<Left<Failure, String>>());
        result.fold(
          (l) => expect(l.message, const Failure().message),
          (_) => fail('Expected Left containing Failure'),
        );
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(
            () => mockAuthRemoteDatasource.forgotUserPassword(email: tEmail));
        verifyNoMoreInteractions(mockConnectionChecker);
      },
    );
  });

  group('currentUser', () {
    const tAppUserModel = UserModel(
      id: '123',
      name: 'Test User',
      email: 'test@example.com',
      pictureFilePathFromFirebase: null,
    );
    const tFirebaseAuthExceptionErrorCode = 'too-many-requests';
    const tFirebaseAuthExceptionErrorMessage = 'too-many-requests-message';

    test(
      'should return AppUser when user is logged in, internet is connected and correct user data is retrieved from Database',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        setUpMockAuthUser();
        setUpGetUserDataToUserModel(tAppUserModel);

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Right(tAppUserModel));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verify(() => mockAuthRemoteDatasource.getUserData(id: tAppUserModel.id))
            .called(1);
      },
    );

    test(
      'should return Failure when authRemoteDatasource.getCurrentUser returns null',
      () async {
        //arrange
        when(() => mockAuthRemoteDatasource.getCurrentUser).thenReturn(null);

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Left(Failure(Constants.nullUserErrorMessage)));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verifyNever(() => mockConnectionChecker.isConnected);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );

    test(
      '''should return UserModel when internet is not available
       and authRemoteDatasource.getCurrentUser does not returns null''',
      () async {
        //arrange
        setUpMockAuthUser();
        setUpMockConnectionToBool(false);

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Right(tAppUserModel));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );

    test(
      'should return Failure when authRemoteDatasource.getUserData throws a FirebaseDataFailure Exception',
      () async {
        //arrange
        setUpMockAuthUser();
        setUpMockConnectionToBool(true);
        setUpGetUserDataToFirebaseDataFailure();

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, Left(Failure(const FirebaseDataFailure().message)));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.getUserData(id: tAppUserModel.id))
            .called(1);
      },
    );

    test(
      'should return Failure when authRemoteDatasource.getCurrentUser throws a FirebaseAuthException with a message',
      () async {
        //arrange
        setUpGetCurrentUserToFirebaseAuthException(
            tFirebaseAuthExceptionErrorCode,
            tFirebaseAuthExceptionErrorMessage);

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Left(Failure(tFirebaseAuthExceptionErrorMessage)));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verifyNever(() => mockConnectionChecker.isConnected);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );
    test(
      'should return Failure when authRemoteDatasource.getCurrentUser throws a FirebaseAuthException with no message',
      () async {
        //arrange
        setUpGetCurrentUserToFirebaseAuthException(
            tFirebaseAuthExceptionErrorCode, null);

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Left(Failure()));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verifyNever(() => mockConnectionChecker.isConnected);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );

    test(
      'should return Failure when exception happens',
      () async {
        //arrange
        setUpMockAuthUser();
        setUpMockConnectionToException();

        //act
        final result = await authRepositoryImpl.currentUser();

        //assert
        expect(result, const Left(Failure()));
        verify(() => mockAuthRemoteDatasource.getCurrentUser).called(1);
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );
  });

  group('loginWithEmailAndPassword', () {
    const tEmail = 'test@gmail.com';
    const tPassword = '12345678';
    const tId = '123';
    const tName = 'Test User';
    const tUserModel = UserModel(id: tId, name: tName, email: tEmail);

    test(
      'should return Right(AppUser) when internet is available, and correct userModel is retreived from firebase',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        setUpLoginToUID(tId);
        setUpGetUserDataToUserModel(tUserModel);

        //act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result, const Right(tUserModel));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verify(() => mockAuthRemoteDatasource.getUserData(id: tId)).called(1);
      },
    );

    test(
      'should return Left(Failure) when internet is not availble',
      () async {
        //arrange
        setUpMockConnectionToBool(false);
        //act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result, const Left(Failure(Constants.noConnectionErrorMessage)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')));
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );

    test(
      'should return Left(Failure) when SignInWithEmailAndPasswordFailure exception is thrown by authRemoteDatasource.loginWithEmailAndPassword',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenThrow(const SignInWithEmailAndPasswordFailure());

        //act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result,
            Left(Failure(const SignInWithEmailAndPasswordFailure().message)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );
    test(
      'should return Left(Failure) when FirebaseDataFailure exception is thrown by authRemoteDatasource.getUserData',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        setUpLoginToUID(tId);
        setUpGetUserDataToFirebaseDataFailure();

        //act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result, Left(Failure(const FirebaseDataFailure().message)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
            email: tEmail, password: tPassword)).called(1);
        verify(() => mockAuthRemoteDatasource.getUserData(id: tId)).called(1);
      },
    );
    test(
      'should return Left(Failure) when any general exception is thrown',
      () async {
        //arrange
        setUpMockConnectionToException();

        //act
        final result = await authRepositoryImpl.loginWithEmailAndPassword(
            email: tEmail, password: tPassword);

        //assert
        expect(result, Left(Failure(const Failure().message)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(() => mockAuthRemoteDatasource.loginWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password')));
        verifyNever(
            () => mockAuthRemoteDatasource.getUserData(id: any(named: 'id')));
      },
    );
  });
}
