// import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:permission_handler/permission_handler.dart'
    as permission_handler show openAppSettings;

class PermissionsService {
  /// Check the status of a specific [Permission]
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  /// Open the app settings.
  Future<bool> openAppSettings() {
    return permission_handler.openAppSettings();
  }

  /// Request permissions for a single permission.
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }
}

Future<bool> requestPermission(
    PermissionsService permissionsService, Permission permission) async {
  if (await permissionsService.status(permission) == PermissionStatus.granted) {
    // debugPrint('granted');
    return true;
  } else {
    // debugPrint(' not granted');
    try {
      var result = await permissionsService.request(permission);
      // debugPrint(' requested');
      if (result == PermissionStatus.granted) {
        // debugPrint(' granted now');
        return true;
      } else {
        await permissionsService.openAppSettings();
        // debugPrint(' not granted bruh');
        return false;
      }
    } catch (e) {
      // debugPrint(e.toString());
      return false;
    }
  }
}

// Future<bool> requestPermission(Permission permission) async {
//   if (await permission.isGranted) {
//     // debugPrint('granted');
//     return true;
//   } else {
//     // debugPrint(' not granted');
//     var result = await permission.request();
//     // debugPrint(' requested');
//     if (result == PermissionStatus.granted) {
//       // debugPrint(' granted now');
//       return true;
//     } else {
//       openAppSettings();
//       // debugPrint(' not granted bruh');
//       return false;
//     }
//   }
// }
