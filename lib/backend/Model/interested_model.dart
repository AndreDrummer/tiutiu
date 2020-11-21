import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/utils/constantes.dart';

class InterestedModel {
  InterestedModel({
    this.position,
    this.lastNotificationSend,
    this.userLat,
    this.userLog,
    this.userReference,
    this.interestedAt,
    this.sinalized = false,
    this.gaveup = false,
    this.donated = false,
    this.interestedName,
    this.infoDetails,
    this.petName,
  });

  InterestedModel.fromSnapshot(DocumentSnapshot snapshot) {
    position = snapshot.data()['position'];
    lastNotificationSend = snapshot.data()['lastNotificationSend'] ?? Constantes.APP_BIRTHDAY;
    userLat = snapshot.data()['userLat'];
    userLog = snapshot.data()['userLog'];
    userReference = snapshot.data()['userReference'];
    interestedAt = snapshot.data()['interestedAt'];
    sinalized = snapshot.data()['sinalized'];
    gaveup = snapshot.data()['gaveup'];
    donated = snapshot.data()['donated'];
    interestedName = snapshot.data()['interestedName'];
    petName = snapshot.data()['petName'];
    infoDetails = snapshot.data()['infoDetails'];
  }

  InterestedModel.fromMap(Map<String, dynamic> map) {
    position = map['position'];
    lastNotificationSend = map['lastNotificationSend'] ?? Constantes.APP_BIRTHDAY;
    userLat = map['userLat'];
    userLog = map['userLog'];
    userReference = map['userReference'];
    interestedAt = map['interestedAt'];
    sinalized = map['sinalized'];
    gaveup = map['gaveup'];
    donated = map['donated'];
    petName = map['petName'];
    infoDetails = map['infoDetails'];
    interestedName = map['interestedName'];
  }

  int position;
  String lastNotificationSend;
  double userLat;
  bool sinalized;
  bool gaveup;
  bool donated;
  double userLog;
  String interestedAt;
  String interestedName;
  String petName;
  String infoDetails;
  DocumentReference userReference;

  Map<String, dynamic> toJson() {
    return {
      'interestedName': interestedName,
      'infoDetails': infoDetails,
      'petName': petName,
      'position': position,
      'lastNotificationSend': lastNotificationSend,
      'userLat': userLat,
      'userLog': userLog,
      'userReference': userReference,
      'interestedAt': interestedAt,
      'sinalized': sinalized,
      'gaveup': gaveup,
    };
  }
}
