import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  Chat({
    this.firstUserId,
    this.open,
    this.secondUserId,
    this.firstUserName,
    this.secondUserName,
    this.firstUserImagePath,
    this.secondUserImagePath,
    this.lastSender,
    this.lastMessage,
    this.lastMessageTime,
    this.firstReceiverNotificationToken,
    this.secondReceiverNotificationToken,
  });

  Chat.fromSnapshot(DocumentSnapshot snapshot)
      : firstUserId = snapshot.data()['firstUserId'],
        open = snapshot.data()['open'],
        secondUserId = snapshot.data()['secondUserId'],
        firstUserName = snapshot.data()['firstUserName'],
        secondUserName = snapshot.data()['secondUserName'],
        firstUserImagePath = snapshot.data()['firstUserImagePath'],
        secondUserImagePath = snapshot.data()['secondUserImagePath'],
        lastSender = snapshot.data()['lastSender'],
        lastMessage = snapshot.data()['lastMessage'],
        lastMessageTime = snapshot.data()['lastMessageTime'],
        firstReceiverNotificationToken = snapshot.data()['firstReceiverNotificationToken'],
        secondReceiverNotificationToken = snapshot.data()['secondReceiverNotificationToken'];

  Map<String, dynamic> toJson() {
    return {
      'firstUserId': firstUserId,
      'open': open,
      'secondUserId': secondUserId,
      'firstUserName': firstUserName,
      'secondUserName': secondUserName,
      'firstUserImagePath': firstUserImagePath,
      'secondUserImagePath': secondUserImagePath,
      'lastSender': lastSender,
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
  String lastSender;
  String lastMessage;
  bool open;
  Timestamp lastMessageTime;
}
