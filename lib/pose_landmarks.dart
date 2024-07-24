import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinksys_mediapipe_plugin/pose_landmark_options.dart';

class PoseLandmarks extends StatefulWidget {
  PoseLandmarkOptions? options;
  Function(dynamic)? scanLandmarks;

  PoseLandmarks({super.key, this.options, this.scanLandmarks}) {
    options ??= PoseLandmarkOptions();
  }

  @override
  State<PoseLandmarks> createState() => _PoseLandmarksState();
}

class _PoseLandmarksState extends State<PoseLandmarks> {
  String viewType = 'com.thinksys.pose_detection';
  static const platform = MethodChannel('com.thinksys.pose_detection/filters');
  EventChannel? poseLandmarksChannel;

  /// TODO: enable realtime filters
  // void _updateFilters(Map<String, bool> filters) {
  //   setState(() {
  //     selectedFilters = filters;
  //   });
  //   _sendFiltersToNative();
  // }
  //
  // Future<void> _sendFiltersToNative() async {
  //   try {
  //     await platform.invokeMethod('updateFilters', selectedFilters);
  //   } on PlatformException catch (e) {
  //     print("Failed to update filters: '${e.message}'.");
  //   }
  // }

  Stream<dynamic> poseLandmarksDataStream() {
    return poseLandmarksChannel!.receiveBroadcastStream().map((event) => event);
  }

  @override
  void initState() {
    super.initState();
    poseLandmarksChannel = EventChannel(viewType);
  }

  @override
  Widget build(BuildContext context) {
    return cameraWidget();
  }

  Widget cameraWidget() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const Center(
          child: Text("This platform is not supported yet."),
        );

      ///TODO: Enable AndroidView after implementation in android pose detection
      // return AndroidView(
      //   viewType: viewType,
      //   layoutDirection: TextDirection.ltr,
      //   creationParams: creationParams,
      //   creationParamsCodec: const StandardMessageCodec(),
      //   onPlatformViewCreated: (viewId) {
      //     print("platform view created : $viewId");
      //   },
      // );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: widget.options?.toJson(),
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            poseLandmarksDataStream().listen((data) {
              if (widget.scanLandmarks != null) {
                widget.scanLandmarks!(data);
              }

              // print("Data $data");
            });
          },
        );
      default:
        return const Center(
          child: Text("This platform is not supported yet."),
        );
    }
  }
}
