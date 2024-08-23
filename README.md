
# Thinksys Mediapipe Plugin

The Thinksys Pose Detection Plugin is a Flutter package that integrates with MediaPipe to provide real-time pose detection capabilities specifically for **iOS applications**. This plugin allows developers to easily track and analyze human poses, enabling features such as fitness tracking, gesture recognition, and more. With seamless integration and high-performance detection, it's an ideal tool for building interactive and motion-based iOS applications.

<p align="center">
<img src="https://i.ibb.co/L1FNt92/thinksys-logo.png" height="100" alt="Thinksys" />
</p>

## Setup

1. First add the dependency in ```pubspec.yaml``` file & do run ```flutter pub get``` in terminal
     ```
     dependencies:
        thinksys_mediapipe_plugin: 0.0.4

     ```
2. Add camera usage permission in Info.plist in example/ios
    ```
    <key>NSCameraUsageDescription</key>
	<string>This app uses camera to get pose landmarks that appear in the camera feed.</string>
    ```
   
3. Run ```cd ios && pod install```

4. Run ``` flutter pub get ```

## Usage

```
import 'package:thinksys_mediapipe_plugin/pose_detection.dart';

PoseLandmarks(
key: UniqueKey(),
poseLandmarks: (value) {
  print("Received Landmarks : $value");
    },
)
```

You can also provide the options to enable/disable the landmarks on different parts of body :

````
PoseLandmarks(
    key: UniqueKey(),
    options: PoseLandmarkOptions(
    face: true,
    leftLeg: false,
    rightLeg: false,
    leftArm: true,
    rightArm: true,
    torso: true),
    poseLandmarks: (value) {
        print("Received Landmarks : $value");
    },
)
````

## 🔗 Links
[![thinksys](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://thinksys.com/)

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://in.linkedin.com/company/thinksys-inc)

## License

This project is licensed under a custom MIT License with restrictions - see the [LICENSE](LICENSE) file for details.

