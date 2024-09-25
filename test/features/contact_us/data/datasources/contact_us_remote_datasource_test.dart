import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/secrets/app_secrets.dart';
import 'package:sumify_clean/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:sumify_clean/features/contact_us/data/models/contact_us_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late ContactUsRemoteDatasourceImpl contactUsRemoteDatasourceImpl;
  late MockHttpClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockHttpClient();
    contactUsRemoteDatasourceImpl =
        ContactUsRemoteDatasourceImpl(client: mockHttpClient);
    registerFallbackValue(FakeUri());
  });
  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response('Success', 200),
    );
  }

  void setUpMockHttpClientFailureCode(int code) {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response('Something Went Wrong', code),
    );
  }

  void setUpMockHttpClientException() {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'))).thenThrow(Exception());
  }

  const tFirstName = 'first name';
  const tLastName = 'last name';
  const tEmail = 'test@example.com';
  const tMessage = 'Message';

  const tContactUsModel = ContactUsModel(
    firstName: tFirstName,
    lastName: tLastName,
    email: tEmail,
    message: tMessage,
  );

  test('''should perform a POST request on a URL with number 
        being the endpoint and with application/json headers''', () async {
    setUpMockHttpClientSuccess200();
    contactUsRemoteDatasourceImpl.sendContactEmail(
        contactUsModel: tContactUsModel);
    verify(
      (() => mockHttpClient.post(
            Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
            headers: {
              'origin': 'http://localhost',
              'Content-Type': 'application/json'
            },
            body: json.encode({
              'service_id': AppSecrets.serviceId,
              'template_id': AppSecrets.templateId,
              'user_id': AppSecrets.userId,
              'template_params': {
                'user_name':
                    '${tContactUsModel.firstName} ${tContactUsModel.lastName}',
                'from_email': tContactUsModel.email,
                'user_message': tContactUsModel.message
              }
            }),
          )),
    );
  });

  test('should return a success string when the response code is 200(success)',
      () async {
    setUpMockHttpClientSuccess200();
    final result = await contactUsRemoteDatasourceImpl.sendContactEmail(
        contactUsModel: tContactUsModel);
    expect(result, Constants.contactUsEmailSentSuccessMessage);
  });

  test(
      'should throw a ServerException with a message for specific status code when the response code is not 200',
      () async {
    setUpMockHttpClientFailureCode(404);
    final resultCall = contactUsRemoteDatasourceImpl.sendContactEmail;
    expect(() => resultCall(contactUsModel: tContactUsModel),
        throwsA(const ServerException(Constants.notFoundFailureMessage)));
  });
  test(
      'should throw a ServerException when response code is some unknown status code',
      () async {
    setUpMockHttpClientFailureCode(501);
    final resultCall = contactUsRemoteDatasourceImpl.sendContactEmail;
    expect(() => resultCall(contactUsModel: tContactUsModel),
        throwsA(const ServerException()));
  });
  test('should throw a ServerException when a generic exception occurs',
      () async {
    setUpMockHttpClientException();
    final resultCall = contactUsRemoteDatasourceImpl.sendContactEmail;
    expect(() => resultCall(contactUsModel: tContactUsModel),
        throwsA(const ServerException()));
  });
}
