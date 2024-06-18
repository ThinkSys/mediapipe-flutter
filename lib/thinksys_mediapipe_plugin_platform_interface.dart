import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'thinksys_mediapipe_plugin_method_channel.dart';

abstract class ThinksysMediapipePluginPlatform extends PlatformInterface {
  /// Constructs a ThinksysMediapipePluginPlatform.
  ThinksysMediapipePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThinksysMediapipePluginPlatform _instance = MethodChannelThinksysMediapipePlugin();

  /// The default instance of [ThinksysMediapipePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelThinksysMediapipePlugin].
  static ThinksysMediapipePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThinksysMediapipePluginPlatform] when
  /// they register themselves.
  static set instance(ThinksysMediapipePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
