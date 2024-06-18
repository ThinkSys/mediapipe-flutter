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
   // private var messenger: FlutterBinaryMessenger

    override init() {
      //  self.messenger = messenger
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
            arguments: args
           // binaryMessenger: messenger
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
        arguments args: Any?
      //  binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _camerViewController = CameraViewController()
//        _view = CameraView()
        _view = _camerViewController.view
        super.init()
        // iOS views can be created here
      //  createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
    }
}
