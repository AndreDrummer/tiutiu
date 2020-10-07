import 'package:cloud_firestore/cloud_firestore.dart';

class InterestedModel {

  InterestedModel({
    this.position,
    this.userLat,
    this.userLog,
    this.userReference,
    this.interestedAt,
    this.sinalized = false
  });

  InterestedModel.fromSnapshot(DocumentSnapshot snapshot) {
    position = snapshot.data()['position'];
    userLat = snapshot.data()['userLat'];
    userLog = snapshot.data()['userLog'];
    userReference = snapshot.data()['userReference'];
    interestedAt = snapshot.data()['interestedAt'];
    sinalized = snapshot.data()['sinalized'];
  }

  InterestedModel.fromMap(Map<String, dynamic> map) {
    position = map['position'];
    userLat = map['userLat'];
    userLog = map['userLog'];
    userReference = map['userReference'];
    interestedAt = map['interestedAt'];
    sinalized = map['sinalized'];
  }

  int position;
  double userLat;
  bool sinalized;
  double userLog;
  String interestedAt;
  DocumentReference userReference;

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'userLat': userLat,
      'userLog': userLog,
      'userReference': userReference,
      'interestedAt': interestedAt,
      'sinalized': sinalized,
    };      
  }
}
