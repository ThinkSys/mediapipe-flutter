import Flutter
import UIKit

public class ThinksysMediapipePlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {

      let factory = PoseDetectionView(messenger : registrar.messenger())
          registrar.register(factory, withId: "com.thinksys.pose_detection")
    

//      let channel = FlutterMethodChannel(name: "com.thinksys.pose_detection/filters", binaryMessenger: registrar.messenger())
//    let instance = ThinksysMediapipePlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
  }

//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    switch call.method {
//    case "updateFilters":
//        if let args = call.arguments as? [String: Bool] {
//                updateFilters(filters: args)
//                result(nil)
//              } else {
//                result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected map of filters", details: nil))
//              }
//    default:
//      result(FlutterMethodNotImplemented)
//    }
//  }
//    
//    private func updateFilters(filters: [String: Bool]) {
////       self.filters = filters
//        print("Items : \(filters)")
//       // Implement filter update logic
//     }
}
