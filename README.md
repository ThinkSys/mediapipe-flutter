
# ThinkSys Mediapipe Plugin

The ThinkSys Mediapipe Plugin brings pose detection to Flutter apps, filling a gap for iOS developers. It offers real-time tracking, easy integration, and customizable options for fitness and healthcare apps. By connecting MediaPipe's capabilities with Flutter's framework, we're enabling developers to build engaging, motion-based iOS apps easily.

<p align="center">
<img src="https://i.ibb.co/L1FNt92/thinksys-logo.png" height="100" alt="Thinksys" />
</p>

## Setup

1. First add the dependency in ```pubspec.yaml``` file & do run ```flutter pub get``` in terminal
     ```
     dependencies:
        thinksys_mediapipe_plugin: ^0.0.13

     ```
2. Add camera usage permission in Info.plist in example/ios
    ```
    <key>NSCameraUsageDescription</key>
	<string>This app uses camera to get pose landmarks that appear in the camera feed.</string>
    ```
   
3. Run ```cd ios && pod install```

4. Run ``` flutter pub get ```

## Properties

| Properties        | Description                                                                                     |
|-------------|-------------------------------------------------------------------------------------------------|
| `cameraFacing`     | Defines which camera to use (front or back). Affects the data provided by `cameraFacing`.                                                                      |
| `cameraOrientation`    | Sets the camera orientation (portrait or landscape). Affects the data provided by `cameraOrientation`.                                                                |
| `onLandmark`| Callback function to retrieve body landmark data.  |                                              |
| `face`      | Toggles visibility of the face in the body model. Affects the data provided by `face`.      |
| `leftArm`   | Toggles visibility of the left arm in the body model. Affects the data provided by `leftArm`.  |
| `rightArm`  | Toggles visibility of the right arm in the body model. Affects the data provided by `rightArm`. |
| `leftWrist` | Toggles visibility of the left wrist in the body model. Affects the data provided by `leftWrist`.|
| `rightWrist`| Toggles visibility of the right wrist in the body model. Affects the data provided by `rightWrist`.|
| `torso`     | Toggles visibility of the torso in the body model. Affects the data provided by `torso`.     |
| `leftLeg`   | Toggles visibility of the left leg in the body model. Affects the data provided by `leftLeg`.  |
| `rightLeg`  | Toggles visibility of the right leg in the body model. Affects the data provided by `rightLeg`. |
| `leftAnkle` | Toggles visibility of the left ankle in the body model. Affects the data provided by `leftAnkle`.|
| `rightAnkle`| Toggles visibility of the right ankle in the body model. Affects the data provided by `rightAnkle`.|


## Usage

### Basic Usage
For basic usage of the PoseLandmarks widget without any props:

```
import 'package:thinksys_mediapipe_plugin/pose_detection.dart';

PoseLandmarks(
  key: UniqueKey(),
)

```
### Usage with Camera Facing Option

To specify which camera to use (front or back):

```

PoseLandmarks(
  key: UniqueKey(),
  cameraFacing: CameraFacing.front,
)

```
### Usage with Orientation Handling

To handle orientation changes (portrait or landscape):

```

PoseLandmarks(
  key: UniqueKey(),
  options: PoseLandmarkOptions(
    cameraOrientation: orientation == Orientation.portrait
        ? CameraOrientation.portrait
        : CameraOrientation.landscape,
  ),
)

```
### Usage with Body Properties

To customize which body parts are tracked using properties like face, leftArm, rightLeg, etc.:

```

PoseLandmarks(
  key: UniqueKey(),
  options: PoseLandmarkOptions(
    face: true,
    leftArm: true,
    rightArm: true,
    leftLeg: true,
    rightLeg: true,
    torso: true,
  ),
)

```
### Usage with onLandmark Properties

To capture and process the pose landmarks detected:

````
PoseLandmarks(
  key: UniqueKey(),
  options: PoseLandmarkOptions(
    poseLandmarks: (value) {
      print("Received Landmarks: $value");
    },
  ),
)

````

## 🔗 Links
[![thinksys](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://thinksys.com/)

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://in.linkedin.com/company/thinksys-inc)

## License

This project is licensed under a custom MIT License with restrictions - see the [LICENSE](LICENSE) file for details.

