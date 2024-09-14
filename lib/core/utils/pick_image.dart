import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickedImage {
  final File file;
  final String name;

  PickedImage({required this.file, required this.name});
}

Future<PickedImage?> pickImage({required ImagePicker imagePicker}) async {
  try {
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final file = File(xFile.path);
      final name = xFile.name;
      return PickedImage(file: file, name: name);
    }
    return null;
  } catch (e) {
    return null;
  }
}
