import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

abstract interface class ArticleLocalDatasource {
  Future<String> saveDocument({required String name, required PdfDocument pdf});
}

class ArticleLocalDatasourceImpl implements ArticleLocalDatasource {
  @override
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

        return Constants.saveDocumentSuccessMessage;
      }
      //FOR IOS
      else {
        var dir = await getApplicationDocumentsDirectory();
        debugPrint(dir.path);
        final file = File('${dir.path}/$name');
        await file.writeAsBytes(bytes);

        // reterning the file to the top most method which generates centered text.
        return Constants.saveDocumentSuccessMessage;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
