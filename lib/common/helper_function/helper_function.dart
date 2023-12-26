import 'package:permission_handler/permission_handler.dart';

class HelperFunction {
  static getPermission() async {
    var status = await Permission.audio.status;
    if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      await Permission.audio.request();
    }
  }
}
