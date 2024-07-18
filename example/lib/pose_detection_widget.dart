import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PoseDetectionWidget extends StatefulWidget {
  const PoseDetectionWidget({super.key});

  @override
  State<PoseDetectionWidget> createState() => _PoseDetectionWidgetState();
}

class _PoseDetectionWidgetState extends State<PoseDetectionWidget> {
   String viewType = 'com.thinksys.pose_detection';
   EventChannel? getPoseLandmarks;


  Stream<dynamic>  poseLandmarksDataStream() {
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
                onPlatformViewCreated: (id){
                  poseLandmarksDataStream().listen((data){
                    print("Data $data");
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
