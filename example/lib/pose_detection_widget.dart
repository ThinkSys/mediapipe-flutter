import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinksys_mediapipe_plugin_example/landmarks_filter_options.dart';

class PoseDetectionWidget extends StatefulWidget {
  const PoseDetectionWidget({super.key});

  @override
  State<PoseDetectionWidget> createState() => _PoseDetectionWidgetState();
}

class _PoseDetectionWidgetState extends State<PoseDetectionWidget> {
  String viewType = 'com.thinksys.pose_detection';
  static const platform = MethodChannel('com.thinksys.pose_detection/filters');
  EventChannel? getPoseLandmarks;

  Map<String, bool> selectedFilters = {
    'Face': true,
    'Left Arm': true,
    'Right Arm': true,
    'Torso': true,
    'Left Leg': true,
    'Right Leg': true,
  };

  void _updateFilters(Map<String, bool> filters) {
    setState(() {
      selectedFilters = filters;
    });
    _sendFiltersToNative();
  }

  Future<void> _sendFiltersToNative() async {
    try {
      await platform.invokeMethod('updateFilters', selectedFilters);
    } on PlatformException catch (e) {
      print("Failed to update filters: '${e.message}'.");
    }
  }

  Stream<dynamic> poseLandmarksDataStream() {
    return getPoseLandmarks!.receiveBroadcastStream().map((event) => event);
  }

  @override
  void initState() {
    super.initState();
    getPoseLandmarks = EventChannel(viewType);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Camera View"),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => LandmarksFilterOptions(onFilterChange: _updateFilters)));
                },
                child: Icon(Icons.settings_input_component_sharp))
          ],
        ),
        body: cameraWidget(),
      ),
    );
  }

  Widget cameraWidget() {
    // This is used in the platform side to register the view.

    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'width': MediaQuery.of(context).size.width,
      'height': MediaQuery.of(context).size.height * 0.5,
    };

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const Center(
          child: Text("This platform is not supported yet."),
        );
      // return Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Container(
      //       color: Colors.yellow,
      //      width: MediaQuery.of(context).size.width,
      //       height: MediaQuery.of(context).size.height * 0.5,
      //       padding: const EdgeInsets.all(20),
      //       child: AndroidView(
      //         viewType: viewType,
      //         layoutDirection: TextDirection.ltr,
      //         creationParams: creationParams,
      //         creationParamsCodec: const StandardMessageCodec(),
      //         onPlatformViewCreated: (viewId){
      //           print("platform view created : $viewId");
      //         },
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () {
      //         Navigator.pop(context);
      //       },
      //       child: Container(
      //         height: 50,
      //         color: Colors.blue,
      //         margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      //         child: const Center(
      //             child: Text(
      //               "Submit",
      //               style: TextStyle(color: Colors.white),
      //             )),
      //       ),
      //     )
      //   ],
      // );
      case TargetPlatform.iOS:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              child: UiKitView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (id) {
                  poseLandmarksDataStream().listen((data) {
                    // print("Data $data");
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                color: Colors.blue,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: const Center(
                    child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            )
          ],
        );
      default:
        return const Center(
          child: Text("This platform is not supported yet."),
        );
    }
  }
}
