import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/core/utils/generate_pdf.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';
import 'package:sumify_clean/features/article/data/datasources/article_local_datasource.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ConnectionChecker connectionChecker;
  final ArticleRemoteDatasource articleRemoteDatasource;
  final ArticleLocalDatasource articleLocalDatasource;
  final PermissionRequest permissionRequest;

  ArticleRepositoryImpl({
    required this.connectionChecker,
    required this.articleRemoteDatasource,
    required this.articleLocalDatasource,
    required this.permissionRequest,
  });

  @override
  Future<Either<Failure, Article>> setArticle({required String article}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }
      final articleModel =
          await articleRemoteDatasource.setUserArticle(articleText: article);

      return right(articleModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (_) {
      return left(const Failure());
    }
  }

  @override
  Future<Either<Failure, String>> saveAsPdf(
      {required String report, required String fileName}) async {
    try {
      final permissionChecker = await permissionRequest
          .requestPermission(Permission.manageExternalStorage);

      if (permissionChecker) {
        final document = await generatePdf(report);
        int randomNumber = Random().nextInt(100) + 100;

        final message = await articleLocalDatasource.saveDocument(
            name: '$fileName$randomNumber.pdf', pdf: document);
        if (message == 'Success') {
          return right('Successfully saved as pdf.');
        } else {
          return left(const Failure());
        }
      } else {
        return left(const Failure('Permission denied!'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
