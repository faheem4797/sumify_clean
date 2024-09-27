import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/usecases/save_as_pdf.dart';
import 'package:sumify_clean/features/article/domain/usecases/set_article.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';

class MockSetArticle extends Mock implements SetArticle {}

class MockSaveAsPdf extends Mock implements SaveAsPdf {}

class FakeSetArticleParams extends Fake implements SetArticleParams {}

class FakeSaveAsPdfParams extends Fake implements SaveAsPdfParams {}

void main() {
  late ArticleBloc articleBloc;
  late MockSetArticle mockSetArticle;
  late MockSaveAsPdf mockSaveAsPdf;

  setUp(() {
    mockSaveAsPdf = MockSaveAsPdf();
    mockSetArticle = MockSetArticle();
    articleBloc =
        ArticleBloc(setArticle: mockSetArticle, saveAsPdf: mockSaveAsPdf);

    registerFallbackValue(FakeSetArticleParams());
    registerFallbackValue(FakeSaveAsPdfParams());
  });
  tearDown(() => articleBloc.close());

  const tArticleText = 'Article Text';
  const tArticleTitle = '"Article Title"';
  const tFilteredTitle = 'Article Title';
  const tSummary = 'Article Summary';
  const tReport = 'Article Report';
  const List<String> tComments = [];
  const tArticle = Article(
      article: tArticleText,
      title: tArticleTitle,
      summary: tSummary,
      report: tReport,
      comments: tComments);
  const tArticleWithEmptyTitle = Article(
      article: tArticleText,
      title: '',
      summary: tSummary,
      report: tReport,
      comments: tComments);
  const tArticleWithEmptyReport = Article(
      article: tArticleText,
      title: tArticleTitle,
      summary: tSummary,
      report: '',
      comments: tComments);

  const tSuccessMessage = 'Success';

  test(
    'should be a valid initial state',
    () async {
      //assert
      expect(
        articleBloc.state,
        isA<ArticleState>()
            .having((state) => state.articleText, 'articleText', '')
            .having((state) => state.article, 'article', Article.empty)
            .having((state) => state.status, 'status', ArticleStatus.initial)
            .having((state) => state.reportStatus, 'reportStatus',
                ReportSaveStatus.initial)
            .having((state) => state.errorMessage, 'errorMessage', null)
            .having(
                (state) => state.reportErrorMessage, 'reportErrorMessage', null)
            .having((state) => state.reportSuccessMessage,
                'reportSuccessMessage', null),
      );
    },
  );

  group('ArticleTextChanged', () {
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state with articleText when ArticleTextChanged is added.',
      build: () => articleBloc,
      act: (bloc) =>
          bloc.add(const ArticleTextChanged(articleText: tArticleText)),
      expect: () => const <ArticleState>[
        ArticleState(
          articleText: tArticleText,
          article: Article.empty,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        )
      ],
    );
  });

  group('SetArticleButtonPressed', () {
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when ArticleTextChanged is added and setArticle usecase returns an article.',
      build: () => articleBloc,
      setUp: () => when(() => mockSetArticle(any()))
          .thenAnswer((_) async => const Right(tArticle)),
      wait: const Duration(milliseconds: 210),
      seed: () => const ArticleState(articleText: tArticleText),
      act: (bloc) => bloc.add(SetArticleButtonPressed()),
      expect: () => const <ArticleState>[
        ArticleState(
          articleText: tArticleText,
          article: Article.empty,
          status: ArticleStatus.loading,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.success,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        )
      ],
      verify: (bloc) {
        verify(() =>
                mockSetArticle(const SetArticleParams(article: tArticleText)))
            .called(1);
      },
    );

    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when ArticleTextChanged is added and setArticle usecase returns a failure.',
      build: () => articleBloc,
      setUp: () => when(() => mockSetArticle(any()))
          .thenAnswer((_) async => const Left(Failure())),
      wait: const Duration(milliseconds: 210),
      seed: () => const ArticleState(articleText: tArticleText),
      act: (bloc) => bloc.add(SetArticleButtonPressed()),
      expect: () => <ArticleState>[
        const ArticleState(
          articleText: tArticleText,
          article: Article.empty,
          status: ArticleStatus.loading,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: Article.empty,
          status: ArticleStatus.failure,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: const Failure().message,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: Article.empty,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: const Failure().message,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        )
      ],
    );
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when ArticleTextChanged is added and articleText is empty.',
      build: () => articleBloc,
      act: (bloc) => bloc.add(SetArticleButtonPressed()),
      expect: () => const <ArticleState>[
        ArticleState(
          articleText: '',
          article: Article.empty,
          status: ArticleStatus.loading,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: '',
          article: Article.empty,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
      ],
      verify: (bloc) {
        verifyNever(() =>
            mockSetArticle(const SetArticleParams(article: tArticleText)));
      },
    );
  });

  group('SaveAsPdfButtonPressed', () {
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when SaveAsPdfButtonPressed is added and saveAsPdf usecase returns a success string.',
      build: () => articleBloc,
      seed: () => const ArticleState(
        articleText: tArticleText,
        article: tArticle,
        status: ArticleStatus.initial,
        reportStatus: ReportSaveStatus.initial,
      ),
      wait: const Duration(milliseconds: 210),
      setUp: () => when(() => mockSaveAsPdf(any()))
          .thenAnswer((_) async => const Right(tSuccessMessage)),
      act: (bloc) => bloc.add(SaveAsPdfButtonPressed()),
      expect: () => const <ArticleState>[
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.loading,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.success,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: tSuccessMessage,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: tSuccessMessage,
        ),
      ],
      verify: (bloc) => verify(() => mockSaveAsPdf(SaveAsPdfParams(
          report: tArticle.report, fileName: tFilteredTitle))).called(1),
    );
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when SaveAsPdfButtonPressed is added and saveAsPdf usecase returns a failure.',
      build: () => articleBloc,
      seed: () => const ArticleState(
        articleText: tArticleText,
        article: tArticle,
        status: ArticleStatus.initial,
        reportStatus: ReportSaveStatus.initial,
      ),
      wait: const Duration(milliseconds: 210),
      setUp: () => when(() => mockSaveAsPdf(any()))
          .thenAnswer((_) async => const Left(Failure())),
      act: (bloc) => bloc.add(SaveAsPdfButtonPressed()),
      expect: () => <ArticleState>[
        const ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.loading,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.failure,
          errorMessage: null,
          reportErrorMessage: const Failure().message,
          reportSuccessMessage: null,
        ),
        ArticleState(
          articleText: tArticleText,
          article: tArticle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: const Failure().message,
          reportSuccessMessage: null,
        ),
      ],
      verify: (bloc) => verify(() => mockSaveAsPdf(SaveAsPdfParams(
          report: tArticle.report, fileName: tFilteredTitle))).called(1),
    );
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when SaveAsPdfButtonPressed is added and article.report or article.title is empty',
      build: () => articleBloc,
      seed: () => const ArticleState(
        articleText: tArticleText,
        article: tArticleWithEmptyTitle,
        status: ArticleStatus.initial,
        reportStatus: ReportSaveStatus.initial,
      ),
      // wait: const Duration(milliseconds: 210),
      // setUp: () => when(() => mockSaveAsPdf(any()))
      //     .thenAnswer((_) async => const Left(Failure())),
      act: (bloc) => bloc.add(SaveAsPdfButtonPressed()),
      expect: () => <ArticleState>[
        const ArticleState(
          articleText: tArticleText,
          article: tArticleWithEmptyTitle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.loading,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        const ArticleState(
          articleText: tArticleText,
          article: tArticleWithEmptyTitle,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
      ],
      verify: (bloc) => verifyZeroInteractions(mockSaveAsPdf),
    );
    blocTest<ArticleBloc, ArticleState>(
      'emits updated state when SaveAsPdfButtonPressed is added and article.report or article.report is empty',
      build: () => articleBloc,
      seed: () => const ArticleState(
        articleText: tArticleText,
        article: tArticleWithEmptyReport,
        status: ArticleStatus.initial,
        reportStatus: ReportSaveStatus.initial,
      ),
      // wait: const Duration(milliseconds: 210),
      // setUp: () => when(() => mockSaveAsPdf(any()))
      //     .thenAnswer((_) async => const Left(Failure())),
      act: (bloc) => bloc.add(SaveAsPdfButtonPressed()),
      expect: () => <ArticleState>[
        const ArticleState(
          articleText: tArticleText,
          article: tArticleWithEmptyReport,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.loading,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
        const ArticleState(
          articleText: tArticleText,
          article: tArticleWithEmptyReport,
          status: ArticleStatus.initial,
          reportStatus: ReportSaveStatus.initial,
          errorMessage: null,
          reportErrorMessage: null,
          reportSuccessMessage: null,
        ),
      ],
      verify: (bloc) => verifyZeroInteractions(mockSaveAsPdf),
    );
  });
}
