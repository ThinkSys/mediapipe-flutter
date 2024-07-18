# thinksys_mediapipe_plugin


A Thinksys plugin for pose detection for Flutter framework.

## Getting Started

1. Take the pull from https://gitlab.thinksys.com/mediapipe/mediapipe-flutter.git repository
2. For plugin git checkout plugin-implementation
3. Navigate to ios folder in example directory : cd example/ios
4. do pod install
5. This will install the required pods but will through an error  "[!] The 'Pods-Runner' target has frameworks with conflicting names: mediapipetaskscommon.xcframework and mediapipetasksvision.xcframework."
6. Since pods installed in the example project but dependencies required in the plugin also so to remove this issue
     a. Open the plugin/ios folder in finder & delete the mediapipetaskscommon.xcframework and mediapipetasksvision.xcframework
     b. now again do pod install in example/ios
7. Now open the example/ios project in xcode
8. Now you need to move the  pods file of mediapipetaskscommon.xcframework & mediapipetasksvision.xcframework
9. Expand the Pods/Pods. This directory will have pods of  MediapipeTasksCommon & MediapipeTasksVision
10. Expand those directories mediapipetaskscommon.xcframework & mediapipetasksvision.xcframework 
11. Now, also expand Pods/Development Pods/thinksys_mediapipe_plugin/../../example/ios/.symlinks/plugin/thinksys_mediapipe_plugin/ios & this will have assets & classes folder
12. Next to move the mediapipetaskscommon.xcframework & mediapipetasksvision.xcframework one by one to ios folder which you expanded in previous step
13. Now, again do pod install or pod update in example/ios
14. Run the build in physical device
15. You can make plugin code changes in Pods/Development Pods/thinksys_mediapipe_plugin/../../example/ios/.symlinks/plugin/thinksys_mediapipe_plugin/ios/Classes folder


This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

