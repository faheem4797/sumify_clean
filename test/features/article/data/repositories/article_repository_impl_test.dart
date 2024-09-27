import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';
import 'package:sumify_clean/features/article/data/datasources/article_local_datasource.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/data/models/article_model.dart';
import 'package:sumify_clean/features/article/data/repositories/article_repository_impl.dart';

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockArticleRemoteDatasource extends Mock
    implements ArticleRemoteDatasource {}

class MockArticleLocalDatasource extends Mock
    implements ArticleLocalDatasource {}

class MockPermissionRequest extends Mock implements PermissionRequest {}

void main() {
  late MockConnectionChecker mockConnectionChecker;
  late MockArticleLocalDatasource mockArticleLocalDatasource;
  late MockArticleRemoteDatasource mockArticleRemoteDatasource;
  late MockPermissionRequest mockPermissionRequest;
  late ArticleRepositoryImpl articleRepositoryImpl;

  setUp(() {
    mockConnectionChecker = MockConnectionChecker();
    mockArticleLocalDatasource = MockArticleLocalDatasource();
    mockArticleRemoteDatasource = MockArticleRemoteDatasource();
    mockPermissionRequest = MockPermissionRequest();
    articleRepositoryImpl = ArticleRepositoryImpl(
      connectionChecker: mockConnectionChecker,
      articleRemoteDatasource: mockArticleRemoteDatasource,
      articleLocalDatasource: mockArticleLocalDatasource,
      permissionRequest: mockPermissionRequest,
    );
  });

  void setUpMockConnectionToBool(bool trueOrFalse) {
    when(() => mockConnectionChecker.isConnected)
        .thenAnswer((_) async => trueOrFalse);
  }

  void setUpMockConnectionToException() {
    when(() => mockConnectionChecker.isConnected)
        .thenThrow(Exception('Unexpected error'));
  }

  group('setArticle', () {
    const tArticleText = 'Article Text';
    const tArticleTitle = 'Article Title';
    const tSummary = 'Article Summary';
    const tReport = 'Article Report';
    const List<String> tComments = [];
    const tArticleModel = ArticleModel(
        article: tArticleText,
        title: tArticleTitle,
        summary: tSummary,
        report: tReport,
        comments: tComments);

    const tServerExceptionMessage = 'Server Exception';
    test(
      'should return article when internet is connected and setUserArticle returns an ArticleModel',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockArticleRemoteDatasource.setUserArticle(
                articleText: any(named: 'articleText')))
            .thenAnswer((_) async => tArticleModel);

        //act
        final result =
            await articleRepositoryImpl.setArticle(article: tArticleText);

        //assert
        expect(result, const Right(tArticleModel));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verify(() => mockArticleRemoteDatasource.setUserArticle(
            articleText: tArticleText)).called(1);
      },
    );

    test(
      'should return failure when internet is not connected',
      () async {
        //arrange
        setUpMockConnectionToBool(false);

        //act
        final result =
            await articleRepositoryImpl.setArticle(article: tArticleText);

        //assert
        expect(result, const Left(Failure(Constants.noConnectionErrorMessage)));
        verify(() => mockConnectionChecker.isConnected).called(1);
        verifyNever(() => mockArticleRemoteDatasource.setUserArticle(
            articleText: any(named: 'articleText')));
      },
    );

    test(
      'should return failure with a proper message when setUserArticle throws a Server Exception',
      () async {
        //arrange
        setUpMockConnectionToBool(true);
        when(() => mockArticleRemoteDatasource.setUserArticle(
                articleText: any(named: 'articleText')))
            .thenThrow(const ServerException(tServerExceptionMessage));

        //act
        final result =
            await articleRepositoryImpl.setArticle(article: tArticleText);

        //assert
        expect(result, const Left(Failure(tServerExceptionMessage)));
      },
    );

    test(
      'should return failure when a general exception occurs',
      () async {
        //arrange
        setUpMockConnectionToException();

        //act
        final result =
            await articleRepositoryImpl.setArticle(article: tArticleText);

        //assert
        expect(result, const Left(Failure()));
      },
    );
  });
}
