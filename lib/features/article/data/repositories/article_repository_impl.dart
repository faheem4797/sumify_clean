import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/failure.dart';
import 'package:sumify_clean/core/error/server_exception.dart';
import 'package:sumify_clean/core/network/connection_checker.dart';
import 'package:sumify_clean/core/utils/request_permission.dart';
import 'package:sumify_clean/features/article/data/datasources/article_remote_datasource.dart';
import 'package:sumify_clean/features/article/domain/entities/article.dart';
import 'package:sumify_clean/features/article/domain/repositories/article_repository.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ConnectionChecker connectionChecker;
  final ArticleRemoteDatasource articleRemoteDatasource;

  ArticleRepositoryImpl(
      {required this.connectionChecker, required this.articleRemoteDatasource});

  @override
  Future<Either<Failure, Article>> setArticle({required String article}) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final articleModel =
          await articleRemoteDatasource.setUserArticle(articleText: article);

      return right(articleModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveAsPdf(
      {required String report, required String fileName}) async {
    try {
      final permissionChecker =
          await requestPermission(Permission.manageExternalStorage);
      if (permissionChecker) {
        final PdfDocument document = PdfDocument();
        PdfPage page = document.pages.add();

        document.pageSettings.size = PdfPageSize.a4;

        PdfFont font = PdfStandardFont(PdfFontFamily.timesRoman, 18);

        PdfTextElement(text: report, font: font).draw(
            page: page,
            bounds: Rect.fromLTWH(
                0, 0, page.getClientSize().width, page.getClientSize().height));
        int randomNumber = Random().nextInt(100) + 100;

        final message = await saveDocument(
            name: '$fileName$randomNumber.pdf', pdf: document);
        if (message == 'Success') {
          return right('Successfully saved as pdf.');
        } else {
          return left(Failure());
        }
      } else {
        return left(Failure('Permission denied!'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<String> saveDocument({
    required String name,
    required PdfDocument pdf,
  }) async {
    try {
      // pdf save to the variable called bytes
      final bytes = await pdf.save();

      if (Platform.isAndroid) {
        final dir = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOCUMENTS);

        // final dir = await getApplicationDocumentsDirectory();

        debugPrint(dir);
        debugPrint('$dir/$name');

        final file = await File('$dir/$name').create(recursive: true);

        debugPrint(file.existsSync().toString());

        debugPrint('asdasd');
        await file.writeAsBytes(bytes);

        return 'Success';
      }
      //FOR IOS
      else {
        var dir = await getApplicationDocumentsDirectory();
        debugPrint(dir.path);
        final file = File('${dir.path}/$name');
        await file.writeAsBytes(bytes);

        // reterning the file to the top most method which generates centered text.
        return 'Success';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
