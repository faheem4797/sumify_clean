import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/error/local_file_saving_exception.dart';
import 'package:sumify_clean/core/utils/save_document_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

abstract interface class ArticleLocalDatasource {
  Future<String> saveDocument({required String name, required PdfDocument pdf});
}

class ArticleLocalDatasourceImpl implements ArticleLocalDatasource {
  final SaveDocumentService saveDocumentService;

  const ArticleLocalDatasourceImpl({
    required this.saveDocumentService,
  });
  @override
  Future<String> saveDocument({
    required String name,
    required PdfDocument pdf,
  }) async {
    try {
      // pdf save to the variable called bytes
      final bytes = await pdf.save();

      if (saveDocumentService.isAndroid) {
        final dir = await saveDocumentService.getExternalDocumentsDirectory;
        // final dir = await ExternalPath.getExternalStoragePublicDirectory(
        //     ExternalPath.DIRECTORY_DOCUMENTS);

        // final dir = await getApplicationDocumentsDirectory();

        debugPrint(dir);
        debugPrint('$dir/$name');

        final file = await saveDocumentService.getFileSystem
            .file('$dir/$name')
            .create(recursive: true);

        // final file = await File('$dir/$name').create(recursive: true);

        // debugPrint(file.existsSync().toString());

        debugPrint('asdasd');
        await file.writeAsBytes(bytes);

        return Constants.saveDocumentSuccessMessage;
      }
      //FOR IOS
      else {
        final dir = await saveDocumentService.getAppsDocumentsDirectory;
        // var dir = await getApplicationDocumentsDirectory();
        debugPrint(dir.path);
        final file =
            saveDocumentService.getFileSystem.file('${dir.path}/$name');
        await file.writeAsBytes(bytes);

        // reterning the file to the top most method which generates centered text.
        return Constants.saveDocumentSuccessMessage;
      }
    } on LocalFileSavingException {
      rethrow;
    } on MissingPlatformDirectoryException catch (e) {
      throw LocalFileSavingException(e.message);
    } on FileSystemException catch (e) {
      throw LocalFileSavingException(e.message);
    } catch (_) {
      throw const LocalFileSavingException();
    }
  }
}
