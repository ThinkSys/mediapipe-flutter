import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'thinksys_mediapipe_plugin_platform_interface.dart';

/// An implementation of [ThinksysMediapipePluginPlatform] that uses method channels.
class MethodChannelThinksysMediapipePlugin extends ThinksysMediapipePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('thinksys_mediapipe_plugin');

}
