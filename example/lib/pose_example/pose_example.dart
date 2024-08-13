import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thinksys_mediapipe_plugin/pose_detection.dart';

import 'package:thinksys_mediapipe_plugin_example/pose_example/landmarks_filter_options.dart';

class PoseExample extends StatefulWidget {
  const PoseExample({super.key});

  @override
  State<PoseExample> createState() => _PoseExampleState();
}

class _PoseExampleState extends State<PoseExample> {
  PoseLandmarkOptions options = PoseLandmarkOptions(
      face: true, leftArm: true, rightArm: true, leftLeg: true, torso: true, rightLeg: true);

  void _updateFilters(String key, bool value) {
    switch (key) {
      case "face":
        options.face = value;
        break;
      case "leftArm":
        options.leftArm = value;
        break;
      case "rightArm":
        options.rightArm = value;
        break;
      case "torso":
        options.torso = value;
        break;
      case "leftLeg":
        options.leftLeg = value;
        break;
      case "rightLeg":
        options.rightLeg = value;
        break;
      case "rightWrist":
        options.rightWrist = value;
        break;
      case "leftWrist":
        options.leftWrist = value;
        break;
      case "rightAnkle":
        options.rightAnkle = value;
        break;
      case "leftAnkle":
        options.leftAnkle = value;
        break;
    }
    setState(() {
      // print("Updated key : $key, $value");
    });
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
                        builder: (_) => LandmarksFilterOptions(
                              onFilterChange: _updateFilters,
                              defaultFilters: options.toJson(),
                            )));
                  },
                  child: const Icon(Icons.settings_input_component_sharp))
            ],
          ),
          body: poseLandmarks()),
    );
  }

  Widget poseLandmarks() {
    return OrientationBuilder(builder: (_, orientation) {
      return PoseLandmarks(
        key: UniqueKey(),
        options: PoseLandmarkOptions(
            cameraFacing: CameraFacing.front,
            cameraOrientation: orientation == Orientation.portrait
                ? CameraOrientation.portrait
                : CameraOrientation.landscape,
            face: true,
            leftLeg: true,
            rightLeg: true,
            leftArm: true,
            rightArm: true,
            torso: true,
            rightAnkle: true,
            leftAnkle: true,
            rightWrist: true,
            leftWrist: true),
        poseLandmarks: (value) {
          //  print("Received Landmarks : $value");
        },
      );
    });
  }
}
