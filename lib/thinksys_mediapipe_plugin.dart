
import 'thinksys_mediapipe_plugin_platform_interface.dart';

class ThinksysMediapipePlugin {
  Future<String?> getPlatformVersion() {
    return ThinksysMediapipePluginPlatform.instance.getPlatformVersion();
  }
}
