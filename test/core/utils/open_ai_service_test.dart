import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/secrets/app_secrets.dart';
import 'package:sumify_clean/core/utils/open_ai_service.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late OpenAiService openAiService;

  setUp(() {
    mockHttpClient = MockHttpClient();
    openAiService = OpenAiService(client: mockHttpClient);

    registerFallbackValue(FakeUri());
  });

  const tArticleText = "This is a sample article";
  const tSuccessString =
      'The 2020 World Series was played in Texas at Globe Life Field in Arlington.';

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response(fixture('success_openAi_fixture.json'), 200),
    );
  }

  void setUpMockHttpClientFailureCode() {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer(
      (_) async => http.Response('Something Went Wrong', 404),
    );
  }

  void setUpMockHttpClientException() {
    when(() => mockHttpClient.post(any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'))).thenThrow(Exception());
  }

  test('''should perform a POST request on a URL 
        being the endpoint and with application/json headers''', () async {
    setUpMockHttpClientSuccess200();
    await openAiService.openaiChatCompletion(
        150, Constants.titlePrompt, tArticleText);
    verify(
      (() => mockHttpClient.post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${AppSecrets.apiKey}',
            },
            body: jsonEncode({
              'model': 'gpt-3.5-turbo-1106',
              'messages': [
                {'role': 'user', 'content': 'You: $tArticleText'},
                {'role': 'assistant', 'content': Constants.titlePrompt}
              ],
              //messages,
              'max_tokens': 150,
            }),
          )),
    );
  });
  test(
    'should return a success string when status code of response is 200',
    () async {
      //arrange
      setUpMockHttpClientSuccess200();

      //act
      final result = await openAiService.openaiChatCompletion(
          150, Constants.titlePrompt, tArticleText);

      //assert
      expect(result, tSuccessString);
    },
  );

  test(
    'should throw a server exception with proper message when status code of response is not 200',
    () async {
      //arrange
      setUpMockHttpClientFailureCode();

      //act
      final resultCall = openAiService.openaiChatCompletion;

      //assert
      expect(
          () async =>
              await resultCall(150, Constants.titlePrompt, tArticleText),
          throwsA(const ServerException(
              Constants.openAiServerExceptionFailureMessage)));
    },
  );

  test(
    'should throw a server exception when a generic exception occurs',
    () async {
      //arrange
      setUpMockHttpClientException();

      //act
      final resultCall = openAiService.openaiChatCompletion;

      //assert
      expect(
          () async =>
              await resultCall(150, Constants.titlePrompt, tArticleText),
          throwsA(const ServerException()));
    },
  );
}
