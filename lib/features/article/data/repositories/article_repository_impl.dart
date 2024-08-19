import 'package:fpdart/fpdart.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ConnectionChecker connectionChecker;
  final ArticleRemoteDatasource articleRemoteDatasource;

  ArticleRepositoryImpl(
      {required this.connectionChecker, required this.articleRemoteDatasource});
  @override
  Future<Either<Failure, Article>> setArticle({required String article}) async {
    if (!await connectionChecker.isConnected) {
      return left(Failure(Constants.noConnectionErrorMessage));
    }
  }
}
