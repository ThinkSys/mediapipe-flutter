import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thinksys_mediapipe_plugin/thinksys_mediapipe_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelThinksysMediapipePlugin platform = MethodChannelThinksysMediapipePlugin();
  const MethodChannel channel = MethodChannel('thinksys_mediapipe_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
