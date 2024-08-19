import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';

abstract interface class ArticleRepository {
  Future<Either<Failure, Article>> setArticle({required String article});
}
