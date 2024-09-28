import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';
import 'package:sumify_clean/features/article/domain/usecases/set_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late SetArticle setArticle;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    setArticle = SetArticle(articleRepository: mockArticleRepository);
  });

  const tArticleText = 'Article Text';
  const tArticleTitle = 'Article Title';
  const tSummary = 'Article Summary';
  const tReport = 'Article Report';
  const List<String> tComments = [];

  const tArticle = Article(
      article: tArticleText,
      title: tArticleTitle,
      summary: tSummary,
      report: tReport,
      comments: tComments);

  test(
    'should return an article from article repository',
    () async {
      //arrange
      when(() =>
              mockArticleRepository.setArticle(article: any(named: 'article')))
          .thenAnswer((_) async => const Right(tArticle));

      //act
      final result =
          await setArticle(const SetArticleParams(article: tArticleText));

      //assert
      expect(result, const Right(tArticle));
      verify(() => mockArticleRepository.setArticle(article: tArticleText))
          .called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );

  test(
    'should return a failure from article repository',
    () async {
      //arrange
      when(() =>
              mockArticleRepository.setArticle(article: any(named: 'article')))
          .thenAnswer((_) async => const Left(Failure()));

      //act
      final result =
          await setArticle(const SetArticleParams(article: tArticleText));

      //assert
      expect(result, const Left(Failure()));
    },
  );
}
