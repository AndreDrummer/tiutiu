import 'package:cloud_firestore/cloud_firestore.dart';

class InterestedModel {

  InterestedModel({
    this.position,
    this.userLat,
    this.userLog,
    this.userReference,
    this.interestedAt,
    this.sinalized = false,
    this.gaveup = false,
    this.donated = false,
    this.userName,
    this.infoDetails,
    this.petName
  });

  InterestedModel.fromSnapshot(DocumentSnapshot snapshot) {
    position = snapshot.data()['position'];
    userLat = snapshot.data()['userLat'];
    userLog = snapshot.data()['userLog'];
    userReference = snapshot.data()['userReference'];
    interestedAt = snapshot.data()['interestedAt'];
    sinalized = snapshot.data()['sinalized'];
    gaveup = snapshot.data()['gaveup'];
    donated = snapshot.data()['donated'];
    userName = snapshot.data()['userName'];
    petName = snapshot.data()['petName'];    
    infoDetails = snapshot.data()['infoDetails'];    
  }

  InterestedModel.fromMap(Map<String, dynamic> map) {
    position = map['position'];
    userLat = map['userLat'];
    userLog = map['userLog'];
    userReference = map['userReference'];
    interestedAt = map['interestedAt'];
    sinalized = map['sinalized'];
    gaveup = map['gaveup'];
    donated = map['donated'];
    petName = map['petName'];
    infoDetails = map['infoDetails'];
    userName = map['userName'];
  }

  int position;
  double userLat;
  bool sinalized;
  bool gaveup;
  bool donated;
  double userLog;
  String interestedAt;
  String userName;
  String petName;
  String infoDetails;
  DocumentReference userReference;

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'infoDetails': infoDetails,
      'petName': petName,
      'position': position,
      'userLat': userLat,
      'userLog': userLog,
      'userReference': userReference,
      'interestedAt': interestedAt,
      'sinalized': sinalized,
      'gaveup': gaveup,
    };      
  }
}
