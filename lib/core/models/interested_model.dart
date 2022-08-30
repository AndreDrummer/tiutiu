import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/constantes.dart';

class InterestedModel {
  InterestedModel({
    required this.lastNotificationSend,
    required this.interestedName,
    required this.userReference,
    required this.interestedAt,
    required this.infoDetails,
    required this.position,
    this.sinalized = false,
    required this.userLat,
    required this.userLog,
    required this.petName,
    this.donated = false,
    this.gaveup = false,
  });

  static InterestedModel fromSnapshot(DocumentSnapshot snapshot) {
    return InterestedModel(
      position: (snapshot.data() as Map<String, dynamic>)['position'],
      lastNotificationSend:
          (snapshot.data() as Map<String, dynamic>)['lastNotificationSend'] ??
              Constantes.APP_BIRTHDAY,
      userLat: (snapshot.data() as Map<String, dynamic>)['userLat'],
      userLog: (snapshot.data() as Map<String, dynamic>)['userLog'],
      userReference: (snapshot.data() as Map<String, dynamic>)['userReference'],
      interestedAt: (snapshot.data() as Map<String, dynamic>)['interestedAt'],
      sinalized: (snapshot.data() as Map<String, dynamic>)['sinalized'],
      gaveup: (snapshot.data() as Map<String, dynamic>)['gaveup'],
      donated: (snapshot.data() as Map<String, dynamic>)['donated'],
      interestedName:
          (snapshot.data() as Map<String, dynamic>)['interestedName'],
      petName: (snapshot.data() as Map<String, dynamic>)['petName'],
      infoDetails: (snapshot.data() as Map<String, dynamic>)['infoDetails'],
    );
  }

  static InterestedModel fromMap(Map<String, dynamic> map) {
    return InterestedModel(
      lastNotificationSend:
          map['lastNotificationSend'] ?? Constantes.APP_BIRTHDAY,
      interestedName: map['interestedName'],
      userReference: map['userReference'],
      interestedAt: map['interestedAt'],
      infoDetails: map['infoDetails'],
      sinalized: map['sinalized'],
      position: map['position'],
      donated: map['donated'],
      petName: map['petName'],
      userLat: map['userLat'],
      userLog: map['userLog'],
      gaveup: map['gaveup'],
    );
  }

  DocumentReference userReference;
  String lastNotificationSend;
  String interestedName;
  String interestedAt;
  String infoDetails;
  double userLat;
  bool sinalized;
  double userLog;
  String petName;
  int position;
  bool donated;
  bool gaveup;

  Map<String, dynamic> toJson() {
    return {
      'lastNotificationSend': lastNotificationSend,
      'interestedName': interestedName,
      'userReference': userReference,
      'interestedAt': interestedAt,
      'infoDetails': infoDetails,
      'sinalized': sinalized,
      'position': position,
      'userLat': userLat,
      'userLog': userLog,
      'petName': petName,
      'gaveup': gaveup,
    };
  }
}
