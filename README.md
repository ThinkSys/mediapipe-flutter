
# Thinksys Mediapipe Plugin

A Thinksys plugin for pose detection for Flutter framework.

<div style="text-align: center;">
  <a href="https://ibb.co/TtfW8PF">
    <img src="https://i.ibb.co/L1FNt92/thinksys-logo.png" alt="thinksys-logo" border="0" style="width: 200px; height: 100px;">
  </a>
</div>


## Setup Steps

1. Take the pull from https://gitlab.thinksys.com/mediapipe/mediapipe-flutter.git repository
2. For plugin ``git checkout plugin-implementation``
3. First add the dependency in pubspec.yaml file & do run flutter pub get in terminal
     ````
   thinksys_mediapipe_plugin:
          path: "path_of_plugin_in_system"
     ````
4. Add ``NSCameraUsageDescription`` permission in Info.plist in example/ios or in your project
5. Run the example/main.dart or run the main.dart of your project

## Code

````
PoseLandmarks(
key: UniqueKey(),
poseLandmarks: (value) {
//  print("Received Landmarks : $value");
},
)
````

You can provide the options to enable/disable the landmarks on different parts of body :

````
PoseLandmarks(
          key: UniqueKey(),
          options: PoseLandmarkOptions(
            face: true,
            leftLeg: false,
            rightLeg: false,
            leftArm: true,
            rightArm: true,
            torso: true
          ),
          poseLandmarks: (value) {
            //  print("Received Landmarks : $value");
          },
        )
````

