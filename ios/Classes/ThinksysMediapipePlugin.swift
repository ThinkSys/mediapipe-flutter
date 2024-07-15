import Flutter
import UIKit

public class ThinksysMediapipePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {

      let factory = PoseDetectionView()
          registrar.register(factory, withId: "com.thinksys.pose_detection")
    
//
//      let channel = FlutterMethodChannel(name: "thinksys_mediapipe_plugin", binaryMessenger: registrar.messenger())
//    let instance = ThinksysMediapipePlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
