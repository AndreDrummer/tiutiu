import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Model/user_model.dart';

class Chat {
  Chat({
    this.open,
    this.firstUser,
    this.id,
    this.secondUser,
    this.lastSender,
    this.lastMessage,
    this.lastMessageTime,
  });

  Chat.fromSnapshot(DocumentSnapshot snapshot)
      : open = snapshot.data()['open'],
        firstUser = User.fromMap(snapshot.data()['firstUser']),
        secondUser = User.fromMap(snapshot.data()['secondUser']),
        lastSender = snapshot.data()['lastSender'],
        id = snapshot.id,
        lastMessage = snapshot.data()['lastMessage'],
        lastMessageTime = snapshot.data()['lastMessageTime'];

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'id': id,
      'lastSender': lastSender,
      'firstUser': firstUser.toJson(),
      'secondUser': secondUser.toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  User firstUser;
  User secondUser;
  String lastSender;
  String lastMessage;
  String id;
  bool open;
  Timestamp lastMessageTime;
}
