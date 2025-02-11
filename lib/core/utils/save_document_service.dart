import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:file/file.dart' as file;

import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class SaveDocumentService {
  bool get isAndroid;
  Future<String> get getExternalDownloadDirectory;
  Future<Directory> get getAppsDocumentsDirectory;
  file.FileSystem get getFileSystem;
  Future<String?> getSaveFileExternalPath(String fileName);
}

class SaveDocumentServiceImpl implements SaveDocumentService {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  Future<String?> getSaveFileExternalPath(String fileName) async {
    String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save As PDF',
      fileName: fileName,
      // type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return savePath;
  }

  // await ExternalPath.getExternalStoragePublicDirectory(
  //     ExternalPath.DIRECTORY_DOWNLOADS);

  @override
  Future<String> get getExternalDownloadDirectory async =>
      await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);

  @override
  Future<Directory> get getAppsDocumentsDirectory async =>
      getApplicationDocumentsDirectory();

  @override
  file.FileSystem get getFileSystem => const LocalFileSystem();
}
