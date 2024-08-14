import 'package:flutter_test/flutter_test.dart';
import 'package:thinksys_mediapipe_plugin/thinksys_mediapipe_plugin.dart';
import 'package:thinksys_mediapipe_plugin/thinksys_mediapipe_plugin_platform_interface.dart';
import 'package:thinksys_mediapipe_plugin/thinksys_mediapipe_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThinksysMediapipePluginPlatform
    with MockPlatformInterfaceMixin
    implements ThinksysMediapipePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ThinksysMediapipePluginPlatform initialPlatform = ThinksysMediapipePluginPlatform.instance;

  test('$MethodChannelThinksysMediapipePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThinksysMediapipePlugin>());
  });

  test('getPlatformVersion', () async {
    ThinksysMediapipePlugin thinksysMediapipePlugin = ThinksysMediapipePlugin();
    MockThinksysMediapipePluginPlatform fakePlatform = MockThinksysMediapipePluginPlatform();
    ThinksysMediapipePluginPlatform.instance = fakePlatform;

    expect(await thinksysMediapipePlugin.getPlatformVersion(), '42');
  });
}
