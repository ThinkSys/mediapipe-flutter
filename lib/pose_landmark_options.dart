import 'package:equatable/equatable.dart';

class PoseLandmarkOptions  extends Equatable {
  bool face;
  bool leftArm;
  bool rightArm;
  bool torso;
  bool leftLeg;
  bool rightLeg;

   PoseLandmarkOptions(
      {this.face = true,
      this.leftArm = true,
      this.rightArm = true,
      this.torso = true,
      this.leftLeg = true,
      this.rightLeg = true});

  Map<String, bool> toJson() => {
        'Face': face,
        'Left Arm': leftArm,
        'Right Arm': rightArm,
        'Torso': torso,
        'Left Leg': leftLeg,
        'Right Leg': rightLeg,
      };

  @override
  List<Object?> get props => [face, leftLeg, leftArm, rightArm, torso, leftLeg, rightLeg];
}
