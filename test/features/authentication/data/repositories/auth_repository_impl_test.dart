import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/firebase_auth_exceptions.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:sumify_clean/features/authentication/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  late MockAuthRemoteDatasource mockAuthRemoteDatasource;
  late MockConnectionChecker mockConnectionChecker;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDatasource = MockAuthRemoteDatasource();
    mockConnectionChecker = MockConnectionChecker();
    authRepositoryImpl = AuthRepositoryImpl(
        authRemoteDatasource: mockAuthRemoteDatasource,
        connectionChecker: mockConnectionChecker);
  });

  void setUpMockConnectionToTrue() {
    when(() => mockConnectionChecker.isConnected).thenAnswer((_) async => true);
  }

  group('forgotUserPassword', () {
    const tEmail = 'test@gmail.com';
    const tSuccess = 'Success';
    const tFailureMessage = 'Failed to send password reset email';
    test(
      'should return a string message when forgotPassword function completes correctly when internet is connected',
      () async {
        //arrange
        when(() => mockConnectionChecker.isConnected)
            .thenAnswer((_) async => true);
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
        when(() => mockConnectionChecker.isConnected)
            .thenAnswer((_) async => false);

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
        setUpMockConnectionToTrue();
        when(() => mockAuthRemoteDatasource.forgotUserPassword(
                email: any(named: 'email')))
            .thenThrow(const SendPasswordResetEmailFailure(tFailureMessage));

        //act
        final result =
            await authRepositoryImpl.forgotUserPassword(email: tEmail);

        //assert
        expect(result, isA<Left<Failure, String>>());
        result.fold((l) => expect(l.message, tFailureMessage),
            (_) => fail('Expected a Left containing a Failure'));

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
        when(() => mockConnectionChecker.isConnected)
            .thenThrow(Exception('Unexpected error'));
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
}
