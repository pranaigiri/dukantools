import 'package:package_info_plus/package_info_plus.dart';

class VersionCode {
  Future<String> getVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
