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
    this.firstReceiverNotificationToken,
    this.secondReceiverNotificationToken,
  });

  Messages.fromSnapshot(DocumentSnapshot snapshot)
      : firstUserId = snapshot.data()['firstUserId'],
        secondUserId = snapshot.data()['secondUserId'],
        firstUserName = snapshot.data()['firstUserName'],
        secondUserName = snapshot.data()['secondUserName'],
        firstUserImagePath = snapshot.data()['firstUserImagePath'],
        secondUserImagePath = snapshot.data()['secondUserImagePath'],
        lastMessage = snapshot.data()['lastMessage'],
        lastMessageTime = snapshot.data()['lastMessageTime'],
        firstReceiverNotificationToken = snapshot.data()['firstReceiverNotificationToken'],
        secondReceiverNotificationToken = snapshot.data()['secondReceiverNotificationToken'];

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
      'firstReceiverNotificationToken': firstReceiverNotificationToken,
      'secondReceiverNotificationToken': secondReceiverNotificationToken,
    };
  }

  String firstUserId;
  String secondUserId;
  String firstUserName;
  String secondUserName;
  String firstReceiverNotificationToken;
  String secondReceiverNotificationToken;
  String firstUserImagePath;
  String secondUserImagePath;
  String lastMessage;
  Timestamp lastMessageTime;
}
