import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    debugPrint('granted');
    return true;
  } else {
    debugPrint(' not granted');
    var result = await permission.request();

    debugPrint(' requested');
    if (result == PermissionStatus.granted) {
      debugPrint(' granted now');
      return true;
    } else {
      openAppSettings();
      debugPrint(' not granted bruh');
      return false;
    }
  }
}
