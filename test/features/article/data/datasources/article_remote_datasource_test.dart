import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/utils/open_ai_service.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';

class MockOpenAiService extends Mock implements OpenAiService {}

void main() {
  late MockOpenAiService mockOpenAiService;
  late ArticleRemoteDatasourceImpl articleRemoteDatasourceImpl;

  setUp(() {
    mockOpenAiService = MockOpenAiService();
    articleRemoteDatasourceImpl =
        ArticleRemoteDatasourceImpl(openAiService: mockOpenAiService);
  });

  const tArticleText = "This is a sample article";
  const tTitle = "Generated Title";
  const tSummary = "Generated Summary";
  const tReport = "Generated Report";
  const tCommentsString = "1. Comment 1\n2. Comment 2";
  final tComments = ["Comment 1", "Comment 2"];

  const tServerExceptionMessage = 'Server Exception';

  test(
    'should return an article model when each call to server is a success',
    () async {
      //arrange
      when(() => mockOpenAiService.openaiChatCompletion(
              150, Constants.titlePrompt, tArticleText))
          .thenAnswer((_) async => tTitle);

      when(() => mockOpenAiService.openaiChatCompletion(
              150, Constants.summarizePrompt, tArticleText))
          .thenAnswer((_) async => tSummary);

      when(() => mockOpenAiService.openaiChatCompletion(
              300, Constants.reportPrompt, tArticleText))
          .thenAnswer((_) async => tReport);

      when(() => mockOpenAiService.openaiChatCompletion(
              150, Constants.commentsPrompt, tArticleText))
          .thenAnswer((_) async => tCommentsString);

      //act
      final result = await articleRemoteDatasourceImpl.setUserArticle(
          articleText: tArticleText);

      //assert
      expect(result.title, tTitle);
      expect(result.summary, tSummary);
      expect(result.report, tReport);
      expect(result.comments, tComments);
      verifyInOrder([
        () => mockOpenAiService.openaiChatCompletion(
            150, Constants.titlePrompt, tArticleText),
        () => mockOpenAiService.openaiChatCompletion(
            150, Constants.summarizePrompt, tArticleText),
        () => mockOpenAiService.openaiChatCompletion(
            300, Constants.reportPrompt, tArticleText),
        () => mockOpenAiService.openaiChatCompletion(
            150, Constants.commentsPrompt, tArticleText),
      ]);
    },
  );

  test(
    'should throw a Server Exception with a proper message when a server call throws a Server Exception',
    () async {
      //arrange
      when(() => mockOpenAiService.openaiChatCompletion(
              150, Constants.titlePrompt, tArticleText))
          .thenThrow(const ServerException(tServerExceptionMessage));

      //act
      final resultCall = articleRemoteDatasourceImpl.setUserArticle;

      //assert
      expect(() async => await resultCall(articleText: tArticleText),
          throwsA(const ServerException(tServerExceptionMessage)));
    },
  );

  test(
    'should throw a Server Exception when a generic exception occurs',
    () async {
      //arrange
      when(() => mockOpenAiService.openaiChatCompletion(any(), any(), any()))
          .thenThrow(const ServerException());

      //act
      final resultCall = articleRemoteDatasourceImpl.setUserArticle;

      //assert
      expect(() async => await resultCall(articleText: tArticleText),
          throwsA(const ServerException()));
    },
  );
}
