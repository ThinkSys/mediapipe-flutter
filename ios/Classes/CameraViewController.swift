// Copyright 2023 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AVFoundation
import MediaPipeTasksVision
import UIKit
import Flutter

protocol InferenceResultDeliveryDelegate: AnyObject {
    func didPerformInference(result: ResultBundle?)
}

protocol InterfaceUpdatesDelegate: AnyObject {
    func shouldClicksBeEnabled(_ isEnabled: Bool)
}


/**
 * The view controller is responsible for performing detection on incoming frames from the live camera and presenting the frames with the
 * landmark of the landmarked poses to the user.
 */
class CameraViewController: UIViewController, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var filters: [String: Bool] = ["rightLeg": true, "rightArm": true, "leftArm": true, "torso": true, "leftLeg": true, "face": true, "leftWrist": true, "rightWrist": true,"leftAnkle": true, "rightAnkle": true, "isFrontCamera" : true]
    
    
    private struct Constants {
        static let edgeOffset: CGFloat = 2.0
    }
    
    weak var inferenceResultDeliveryDelegate: InferenceResultDeliveryDelegate?
    weak var interfaceUpdatesDelegate: InterfaceUpdatesDelegate?
    
    private var previewView: UIView!
    private var cameraUnavailableLabel: UILabel!
    private var resumeButton: UIButton!
    private var overlayView: OverlayView!
    
    private var isSessionRunning = false
    private var isObserving = false
    private let backgroundQueue = DispatchQueue(label: "com.google.mediapipe.cameraController.backgroundQueue")
    
    // MARK: Controllers that manage functionality
    // Handles all the camera related functionality
    private lazy var cameraFeedService = CameraFeedService(previewView: previewView, isFrontCamera: filters["isFrontCamera"] ?? true, isPortrait: filters["isPortrait"] ?? true)
    
    private let poseLandmarkerServiceQueue = DispatchQueue(
        label: "com.google.mediapipe.cameraController.poseLandmarkerServiceQueue",
        attributes: .concurrent)
    
    // Queuing reads and writes to poseLandmarkerService using the Apple recommended way
    // as they can be read and written from multiple threads and can result in race conditions.
    private var _poseLandmarkerService: PoseLandmarkerService?
    private var poseLandmarkerService: PoseLandmarkerService? {
        get {
            poseLandmarkerServiceQueue.sync {
                return self._poseLandmarkerService
            }
        }
        set {
            poseLandmarkerServiceQueue.async(flags: .barrier) {
                self._poseLandmarkerService = newValue
            }
        }
    }
    
    init(messenger: FlutterBinaryMessenger, arguments args: Any?) {
        super.init(nibName: nil, bundle: nil)
        setupEventChannel(messenger: messenger)
        if(args != nil){
            self.filters =  args as! [String: Bool]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
#if !targetEnvironment(simulator)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializePoseLandmarkerServiceOnSessionResumption()
        cameraFeedService.startLiveCameraSession {[weak self] cameraConfiguration in
            DispatchQueue.main.async {
                switch cameraConfiguration {
                case .failed:
                    self?.presentVideoConfigurationErrorAlert()
                case .permissionDenied:
                    self?.presentCameraPermissionsDeniedAlert()
                default:
                    break
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraFeedService.stopSession()
        clearPoseLandmarkerServiceOnSessionInterruption()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cameraFeedService.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraFeedService.updateVideoPreviewLayer(toFrame: previewView.bounds)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cameraFeedService.updateVideoPreviewLayer(toFrame: previewView.bounds)
    }
#endif
    
    private func setupEventChannel(messenger: FlutterBinaryMessenger) {
        /// Event channel to pass pose landmarks
        let eventChannel = FlutterEventChannel(name: "com.thinksys.pose_detection", binaryMessenger: messenger)
        eventChannel.setStreamHandler(self)
        
        /// Method channel to update pose landmarks filters
        let filtersChannel = FlutterMethodChannel(name: "com.thinksys.pose_detection/filters", binaryMessenger: messenger)
        filtersChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                guard let strongSelf = self else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Weak self is nil", details: nil))
                    return
                }
                if call.method == "updateFilters" {
                    if let filters = call.arguments as? [String: Bool] {
                        self?.updateFilters(filters: filters)
                        result(nil)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid filter options", details: nil))
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
        
    }
    
    private func updateFilters(filters: [String: Bool]) {
//       self.filters = filters
//        print("Items : \(filters)")
        self.filters = filters
        self.initializePoseLandmarkerServiceOnSessionResumption()
       // Implement filter update logic
     }
    
  
    
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Start sending events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    private func sendPoseLandmarks(data: [String: Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.eventSink?(data)
        }
        
    }
    
    private func setupUI() {
        previewView = UIView()
        previewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewView)
        
        cameraUnavailableLabel = UILabel()
        cameraUnavailableLabel.text = "Camera Unavailable"
        cameraUnavailableLabel.textAlignment = .center
        cameraUnavailableLabel.isHidden = true
        cameraUnavailableLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraUnavailableLabel)
        
        resumeButton = UIButton(type: .system)
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.isHidden = true
        resumeButton.addTarget(self, action: #selector(onClickResume(_:)), for: .touchUpInside)
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resumeButton)
        
        overlayView = OverlayView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        // Assuming all the views are already created
        previewView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        cameraUnavailableLabel.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // SafeArea trailing constraint
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: cameraUnavailableLabel.trailingAnchor, constant: 10)
        ])
        // PreviewView constraints
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // OverlayView constraints
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // CameraUnavailableLabel constraints
        NSLayoutConstraint.activate([
            cameraUnavailableLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cameraUnavailableLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // ResumeButton constraints
        NSLayoutConstraint.activate([
            resumeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resumeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
    }
    
    // Resume camera session when click button resume
    @objc func onClickResume(_ sender: Any) {
        cameraFeedService.resumeInterruptedSession {[weak self] isSessionRunning in
            if isSessionRunning {
                self?.resumeButton.isHidden = true
                self?.cameraUnavailableLabel.isHidden = true
                self?.initializePoseLandmarkerServiceOnSessionResumption()
            }
        }
    }
    
    private func presentCameraPermissionsDeniedAlert() {
        let alertController = UIAlertController(
            title: "Camera Permissions Denied",
            message:
                "Camera permissions have been denied for this app. You can change this by going to Settings",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentVideoConfigurationErrorAlert() {
        let alert = UIAlertController(
            title: "Camera Configuration Failed",
            message: "There was an error while configuring camera.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func initializePoseLandmarkerServiceOnSessionResumption() {
        clearAndInitializePoseLandmarkerService()
        startObserveConfigChanges()
    }
    
    @objc private func clearAndInitializePoseLandmarkerService() {
        poseLandmarkerService = nil
        poseLandmarkerService = PoseLandmarkerService
            .liveStreamPoseLandmarkerService(
                modelPath: InferenceConfigurationManager.sharedInstance.model.modelPath,
                numPoses: InferenceConfigurationManager.sharedInstance.numPoses,
                minPoseDetectionConfidence: InferenceConfigurationManager.sharedInstance.minPoseDetectionConfidence,
                minPosePresenceConfidence: InferenceConfigurationManager.sharedInstance.minPosePresenceConfidence,
                minTrackingConfidence: InferenceConfigurationManager.sharedInstance.minTrackingConfidence,
                liveStreamDelegate: self,
                delegate: InferenceConfigurationManager.sharedInstance.delegate)
//        print("Overlayservice : " + (InferenceConfigurationManager.sharedInstance.model.modelPath ?? "No path"))
    }
    
    private func clearPoseLandmarkerServiceOnSessionInterruption() {
        stopObserveConfigChanges()
        poseLandmarkerService = nil
    }
    
    private func startObserveConfigChanges() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(clearAndInitializePoseLandmarkerService),
                         name: InferenceConfigurationManager.notificationName,
                         object: nil)
        isObserving = true
    }
    
    private func stopObserveConfigChanges() {
        if isObserving {
            NotificationCenter.default
                .removeObserver(self,
                                name:InferenceConfigurationManager.notificationName,
                                object: nil)
        }
        isObserving = false
    }
    
    func navigateBackToFlutter() {
        //           guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController else {
        //               return
        //           }
        
        //           let methodChannel = FlutterMethodChannel(name: "mediapipe_detection", binaryMessenger: rootViewController.binaryMessenger)
        //           methodChannel.invokeMethod("navigateBack", arguments: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Call this method when you want to navigate back, e.g., on a button tap
    @objc func backButtonTapped() {
        navigateBackToFlutter()
    }
    
}

extension CameraViewController: CameraFeedServiceDelegate {
    
    func didOutput(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation) {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        // Pass the pixel buffer to mediapipe
        backgroundQueue.async { [weak self] in
            self?.poseLandmarkerService?.detectAsync(
                sampleBuffer: sampleBuffer,
                orientation: orientation,
                timeStamps: Int(currentTimeMs))
        }
    }
    
    // MARK: Session Handling Alerts
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        // Updates the UI when session is interupted.
        if resumeManually {
            resumeButton.isHidden = false
        } else {
            cameraUnavailableLabel.isHidden = false
        }
        clearPoseLandmarkerServiceOnSessionInterruption()
    }
    
    func sessionInterruptionEnded() {
        // Updates UI once session interruption has ended.
        cameraUnavailableLabel.isHidden = true
        resumeButton.isHidden = true
        initializePoseLandmarkerServiceOnSessionResumption()
    }
    
    func didEncounterSessionRuntimeError() {
        // Handles session run time error by updating the UI and providing a button if session can be
        // manually resumed.
        resumeButton.isHidden = false
        clearPoseLandmarkerServiceOnSessionInterruption()
    }
}

// MARK: PoseLandmarkerServiceLiveStreamDelegate
extension CameraViewController: PoseLandmarkerServiceLiveStreamDelegate {
    
    func poseLandmarkerService(
        _ poseLandmarkerService: PoseLandmarkerService,
        didFinishDetection result: ResultBundle?,
        error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.inferenceResultDeliveryDelegate?.didPerformInference(result: result)
            
            guard let poseLandmarkerResult = result?.poseLandmarkerResults.first as? PoseLandmarkerResult else {
//                print("No pose landmarks found")
                return
            }
            
            if let landmarks = poseLandmarkerResult.landmarks.first {
                var landmarksArray: [[String: Any]] = []
                var worldLandmarksArray: [[String: Any]] = []
                
                for landmark in landmarks {
                    let landmarkData: [String: Any] = [
                        "x": landmark.x,
                        "y": landmark.y,
                        "z": landmark.z,
                        "visibility": landmark.visibility?.floatValue ?? 0.0,
                        "presence": landmark.presence?.floatValue ?? 0.0
                    ]
                    landmarksArray.append(landmarkData)
                }
                
                if let worldLandmarks = poseLandmarkerResult.worldLandmarks.first {
                    for landmark in worldLandmarks {
                        let landmarkData: [String: Any] = [
                            "x": landmark.x,
                            "y": landmark.y,
                            "z": landmark.z,
                            "visibility": landmark.visibility?.floatValue ?? 0.0,
                            "presence": landmark.presence?.floatValue ?? 0.0
                        ]
                        worldLandmarksArray.append(landmarkData)
                    }
                }
                
                var swiftDict: [String: Any] = [
                    "landmarks": landmarksArray,
                    "worldLandmarks": worldLandmarksArray,
                ]
                self?.sendPoseLandmarks(data: swiftDict)
//                weakSelf.onLandmark?(swiftDict)
            } else {
//                print("No landmarks found")
            }
            
            let imageSize = weakSelf.cameraFeedService.videoResolution
            let poseOverlays = OverlayView.poseOverlays(
                fromMultiplePoseLandmarks: poseLandmarkerResult.landmarks,
                inferredOnImageOfSize: imageSize,
                ovelayViewSize: weakSelf.overlayView.bounds.size,
                imageContentMode: weakSelf.overlayView.imageContentMode,
                andOrientation: UIImage.Orientation.from(deviceOrientation: UIDevice.current.orientation),
                filters: self?.filters
            )
            
            weakSelf.overlayView.draw(poseOverlays: poseOverlays,
                                      inBoundsOfContentImageOfSize: imageSize,
                                      imageContentMode: weakSelf.cameraFeedService.videoGravity.contentMode, isPortrait: (self?.filters["isPortrait"])!)
        }
    }
}

// MARK: - AVLayerVideoGravity Extension
extension AVLayerVideoGravity {
    var contentMode: UIView.ContentMode {
        switch self {
        case .resizeAspectFill:
            return .scaleAspectFill
        case .resizeAspect:
            return .scaleAspectFit
        case .resize:
            return .scaleToFill
        default:
            return .scaleAspectFill
        }
    }
}
