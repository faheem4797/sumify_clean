import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:sumify_clean/features/contact_us/data/models/contact_us_model.dart';
import 'package:sumify_clean/features/contact_us/data/repositories/contact_us_repository_impl.dart';

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockContactUsRemoteDatasource extends Mock
    implements ContactUsRemoteDatasource {}

class FakeContactUsModel extends Fake implements ContactUsModel {}

void main() {
  late ContactUsRepositoryImpl contactUsRepositoryImpl;
  late MockConnectionChecker mockConnectionChecker;
  late MockContactUsRemoteDatasource mockContactUsRemoteDatasource;

  setUp(() {
    mockConnectionChecker = MockConnectionChecker();
    mockContactUsRemoteDatasource = MockContactUsRemoteDatasource();
    contactUsRepositoryImpl = ContactUsRepositoryImpl(
        connectionChecker: mockConnectionChecker,
        contactUsRemoteDatasource: mockContactUsRemoteDatasource);

    registerFallbackValue(FakeContactUsModel());
  });

  const tSuccessMessage = 'Success';
  const tServerException = 'Server Exception';
  const tFirstName = 'first name';
  const tLastName = 'last name';
  const tEmail = 'test@example.com';
  const tMessage = 'Message';

  const tContactUsModel = ContactUsModel(
      firstName: tFirstName,
      lastName: tLastName,
      email: tEmail,
      message: tMessage);
  test(
    'should return a success string when internet is connected and remote datasource returns a string successfully',
    () async {
      //arrange
      when(() => mockConnectionChecker.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockContactUsRemoteDatasource.sendContactEmail(
              contactUsModel: any(named: 'contactUsModel')))
          .thenAnswer((_) async => tSuccessMessage);

      //act
      final result = await contactUsRepositoryImpl.sendEmail(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        message: tMessage,
      );

      //assert
      expect(result, const Right(tSuccessMessage));
      verify(() => mockConnectionChecker.isConnected).called(1);
      verify(() => mockContactUsRemoteDatasource.sendContactEmail(
          contactUsModel: tContactUsModel)).called(1);
    },
  );

  test(
    'should return a failure when internet is not available',
    () async {
      //arrange
      when(() => mockConnectionChecker.isConnected)
          .thenAnswer((_) async => false);

      //act
      final result = await contactUsRepositoryImpl.sendEmail(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        message: tMessage,
      );

      //assert
      expect(result, const Left(Failure(Constants.noConnectionErrorMessage)));
      verifyNever(() => mockContactUsRemoteDatasource.sendContactEmail(
          contactUsModel: tContactUsModel));
    },
  );

  test(
    'should return failure with a proper message when a server exception occurs',
    () async {
      //arrange
      when(() => mockConnectionChecker.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockContactUsRemoteDatasource.sendContactEmail(
              contactUsModel: any(named: 'contactUsModel')))
          .thenThrow(const ServerException(tServerException));

      //act
      final result = await contactUsRepositoryImpl.sendEmail(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        message: tMessage,
      );

      //assert
      expect(result, const Left(Failure(tServerException)));
    },
  );

  test(
    'should return failure when a server exception occurs',
    () async {
      //arrange
      when(() => mockConnectionChecker.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockContactUsRemoteDatasource.sendContactEmail(
              contactUsModel: any(named: 'contactUsModel')))
          .thenThrow(const ServerException());

      //act
      final result = await contactUsRepositoryImpl.sendEmail(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        message: tMessage,
      );

      //assert
      expect(result, Left(Failure(const ServerException().message)));
    },
  );

  test(
    'should return failure when a general exception occurs',
    () async {
      //arrange
      when(() => mockConnectionChecker.isConnected).thenThrow(Exception());

      //act
      final result = await contactUsRepositoryImpl.sendEmail(
        firstName: tFirstName,
        lastName: tLastName,
        email: tEmail,
        message: tMessage,
      );

      //assert
      expect(result, const Left(Failure()));
    },
  );
}
