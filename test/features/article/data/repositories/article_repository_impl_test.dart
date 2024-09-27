import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';
import 'package:sumify_clean/features/article/data/datasources/article_local_datasource.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/data/models/article_model.dart';
import 'package:sumify_clean/features/article/data/repositories/article_repository_impl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockArticleRemoteDatasource extends Mock
    implements ArticleRemoteDatasource {}

class MockArticleLocalDatasource extends Mock
    implements ArticleLocalDatasource {}

class MockPermissionRequest extends Mock implements PermissionRequest {}

class MockRandom extends Mock implements Random {}

class FakePermission extends Fake implements Permission {}

class FakePdfDocument extends Fake implements PdfDocument {}

void main() {
  late MockConnectionChecker mockConnectionChecker;
  late MockArticleLocalDatasource mockArticleLocalDatasource;
  late MockArticleRemoteDatasource mockArticleRemoteDatasource;
  late MockPermissionRequest mockPermissionRequest;
  late MockRandom mockRandom;
  late ArticleRepositoryImpl articleRepositoryImpl;

  setUp(() {
    mockConnectionChecker = MockConnectionChecker();
    mockArticleLocalDatasource = MockArticleLocalDatasource();
    mockArticleRemoteDatasource = MockArticleRemoteDatasource();
    mockPermissionRequest = MockPermissionRequest();
    mockRandom = MockRandom();
    articleRepositoryImpl = ArticleRepositoryImpl(
      connectionChecker: mockConnectionChecker,
      articleRemoteDatasource: mockArticleRemoteDatasource,
      articleLocalDatasource: mockArticleLocalDatasource,
      permissionRequest: mockPermissionRequest,
      random: mockRandom,
    );

    registerFallbackValue(FakePermission());
    registerFallbackValue(FakePdfDocument());
  });

  void setUpMockConnectionToBool(bool trueOrFalse) {
    when(() => mockConnectionChecker.isConnected)
        .thenAnswer((_) async => trueOrFalse);
  }

  void setUpMockConnectionToException() {
    when(() => mockConnectionChecker.isConnected)
        .thenThrow(Exception('Unexpected error'));
  }

  void setUpSaveAsPdfWithMessage(String message) {
    when(() => mockPermissionRequest.requestPermission(any()))
        .thenAnswer((_) async => true);
    when(() => mockRandom.nextInt(any())).thenReturn(10);
    when(() => mockArticleLocalDatasource.saveDocument(
        name: any(named: 'name'),
        pdf: any(named: 'pdf'))).thenAnswer((_) async => message);
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

  group('saveAsPdf', () {
    const tFileName = 'fileName';
    const tReport = 'Article Report';

    test(
      'should return a success string when report is successfully saved as PDF',
      () async {
        //arrange
        setUpSaveAsPdfWithMessage(Constants.saveDocumentSuccessMessage);

        //act
        final result = await articleRepositoryImpl.saveAsPdf(
            report: tReport, fileName: tFileName);

        //assert
        expect(result, right(Constants.savedAsPDFsuccessMessage));
        verify(() => mockPermissionRequest
            .requestPermission(Permission.manageExternalStorage)).called(1);
        verify(() => mockRandom.nextInt(100)).called(1);
        verify(() => mockArticleLocalDatasource.saveDocument(
            name: '${tFileName}110.pdf', pdf: any(named: 'pdf'))).called(1);
      },
    );
    test(
      'should return failure with a proper message when permissionChecker returns false',
      () async {
        //arrange
        when(() => mockPermissionRequest.requestPermission(any()))
            .thenAnswer((_) async => false);

        //act
        final result = await articleRepositoryImpl.saveAsPdf(
            report: tReport, fileName: tFileName);

        //assert
        expect(result,
            left(const Failure(Constants.permissionDeniedFailureMessage)));
        verifyZeroInteractions(mockRandom);
        verifyZeroInteractions(mockArticleLocalDatasource);
      },
    );
    test(
      'should return failure with a proper message when saveDocument does not return a success message',
      () async {
        //arrange
        setUpSaveAsPdfWithMessage('');

        //act
        final result = await articleRepositoryImpl.saveAsPdf(
            report: tReport, fileName: tFileName);

        //assert
        expect(result, left(const Failure(Constants.saveAsPdfFailureMessage)));
      },
    );

    test(
      'should return failure when a generic exception occurs',
      () async {
        //arrange
        when(() => mockPermissionRequest.requestPermission(any()))
            .thenThrow(Exception());

        //act
        final result = await articleRepositoryImpl.saveAsPdf(
            report: tReport, fileName: tFileName);

        //assert
        expect(result, left(const Failure()));
      },
    );
  });
}
