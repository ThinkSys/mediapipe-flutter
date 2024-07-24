import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thinksys_mediapipe_plugin/pose_landmarks.dart';
import 'package:thinksys_mediapipe_plugin/pose_landmark_options.dart';
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
      case "Face":
        options.face = value;
        break;
      case "Left Arm":
        options.leftArm = value;
        break;
      case "Right Arm":
        options.rightArm = value;
        break;
      case "Torso":
        options.torso = value;
        break;
      case "Left Leg":
        options.leftLeg = value;
        break;
      case "Right Leg":
        options.rightLeg = value;
        break;
    }
    setState(() {
      print("Updated key : $key, $value");
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
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: PoseLandmarks(
                key: UniqueKey(),
                options: PoseLandmarkOptions(),
                scanLandmarks: (value) {
                //  print("Received Landmarks : $value");
                },
              ),
            ),
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              color: Colors.blue,
              child: Center(child: Text("Submit")),
            )
          ],
        ),
      ),
    );
  }
}
