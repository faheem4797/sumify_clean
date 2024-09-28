import 'dart:io';
import 'package:file/file.dart' as file;

import 'package:external_path/external_path.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class SaveDocumentService {
  bool get isAndroid;
  Future<String> get getExternalDocumentsDirectory;
  Future<Directory> get getAppsDocumentsDirectory;
  file.FileSystem get getFileSystem;
}

class SaveDocumentServiceImpl implements SaveDocumentService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  Future<String> get getExternalDocumentsDirectory async =>
      await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS);

  @override
  Future<Directory> get getAppsDocumentsDirectory async =>
      getApplicationDocumentsDirectory();

  @override
  file.FileSystem get getFileSystem => const LocalFileSystem();
}
