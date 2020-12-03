import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  Messages({
    this.firstUserId,
    this.secondUserId,
    this.firstUserName,
    this.secondUserName,
    this.firstUserImagePath,
    this.secondUserImagePath,
    this.lastMessage,
    this.lastMessageTime,
  });

  Messages.fromSnapshot(DocumentSnapshot snapshot)
      : firstUserId = snapshot.data()['firstUserId'],
        secondUserId = snapshot.data()['secondUserId'],
        firstUserName = snapshot.data()['firstUserName'],
        secondUserName = snapshot.data()['secondUserName'],
        firstUserImagePath = snapshot.data()['firstUserImagePath'],
        secondUserImagePath = snapshot.data()['secondUserImagePath'],
        lastMessage = snapshot.data()['lastMessage'],
        lastMessageTime = snapshot.data()['lastMessageTime'];

  Map<String, dynamic> toJson() {
    return {
      'firstUserId': firstUserId,
      'secondUserId': secondUserId,
      'firstUserName': firstUserName,
      'secondUserName': secondUserName,
      'firstUserImagePath': firstUserImagePath,
      'secondUserImagePath': secondUserImagePath,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  String firstUserId;
  String secondUserId;
  String firstUserName;
  String secondUserName;
  String firstUserImagePath;
  String secondUserImagePath;
  String lastMessage;
  Timestamp lastMessageTime;
}
