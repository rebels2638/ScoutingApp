import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scouting_app_2024/debug.dart';

class DeviceEnv {
  static late Directory saveLocation;

  static Future<void> initItems() async {
    saveLocation = await getApplicationCacheDirectory();
  }

  static Future<String> initializeAppSaveLocale() async {
    Debug().info(
        "Found the storage location at ${saveLocation.path}. Now asking for perms?");
    if (Platform.isAndroid || Platform.isIOS) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
    if (!Directory(saveLocation.path).existsSync()) {
      Directory(saveLocation.path).createSync(recursive: true);
      Debug().info(
          "Created the storage location at ${saveLocation.path}");
    }
    return saveLocation.path;
  }
}
