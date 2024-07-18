//
//  PoseDetectionView.swift
//  Runner
//
//  Created by Anchal Singh on 24/05/24.
//

import Foundation


import Flutter
import UIKit


class PoseDetectionView: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _camerViewController : CameraViewController
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _camerViewController = CameraViewController(messenger: messenger!)
//        _view = CameraView()
        _view = _camerViewController.view


        super.init()
    }

    func view() -> UIView {
        return _view
    }
    
    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
           if call.method == "getData" {
               let data = "Data from native view"
               result(data)
           } else {
               result(FlutterMethodNotImplemented)
           }
       }
}
