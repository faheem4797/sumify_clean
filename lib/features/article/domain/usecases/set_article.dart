import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/usecase/usecase.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';

class SetArticle implements UseCase<Article, SetArticleParams> {
  final ArticleRepository articleRepository;

  SetArticle({required this.articleRepository});
  @override
  Future<Either<Failure, Article>> call(SetArticleParams params) async {
    return await articleRepository.setArticle(article: params.article);
  }
}

class SetArticleParams {
  final String article;

  SetArticleParams({required this.article});
}
