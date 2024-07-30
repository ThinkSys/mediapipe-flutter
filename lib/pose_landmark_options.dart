import 'package:equatable/equatable.dart';

class PoseLandmarkOptions extends Equatable {
  bool face;
  bool leftArm;
  bool rightArm;
  bool leftWrist;
  bool rightWrist;
  bool torso;
  bool leftLeg;
  bool rightLeg;
  bool leftAnkle;
  bool rightAnkle;

  PoseLandmarkOptions(
      {this.face = true,
      this.leftArm = true,
      this.rightArm = true,
      this.leftWrist = true,
      this.rightWrist = true,
      this.torso = true,
      this.leftLeg = true,
      this.rightLeg = true,
      this.leftAnkle = true,
      this.rightAnkle = true});

  Map<String, bool> toJson() => {
        'face': face,
        'leftArm': leftArm,
        'rightArm': rightArm,
        "leftWrist": leftWrist,
        "rightWrist": rightWrist,
        'torso': torso,
        'leftLeg': leftLeg,
        'rightLeg': rightLeg,
        "leftAnkle": leftAnkle,
        "rightAnkle": rightAnkle
      };

  @override
  List<Object?> get props => [
        face,
        leftLeg,
        leftArm,
        leftWrist,
        rightWrist,
        rightArm,
        torso,
        leftLeg,
        rightLeg,
        leftAnkle,
        rightAnkle
      ];
}
