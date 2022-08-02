import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Model/user_model.dart';

class Chat {
  Chat({
    required this.lastMessageTime,
    required this.lastMessage,
    required this.secondUser,
    required this.lastSender,
    required this.firstUser,
    this.open = false,
    required this.id,
  });

  Chat.fromSnapshot(DocumentSnapshot snapshot)
      : open = (snapshot.data() as Map<String, dynamic>)['open'],
        firstUser = User.fromMap(
            (snapshot.data() as Map<String, dynamic>)['firstUser']),
        secondUser = User.fromMap(
            (snapshot.data() as Map<String, dynamic>)['secondUser']),
        lastSender = (snapshot.data() as Map<String, dynamic>)['lastSender'],
        id = snapshot.id,
        lastMessage = (snapshot.data() as Map<String, dynamic>)['lastMessage'],
        lastMessageTime =
            (snapshot.data() as Map<String, dynamic>)['lastMessageTime'];

  Map<String, dynamic> toJson() {
    return {
      'lastMessageTime': lastMessageTime,
      'secondUser': secondUser.toJson(),
      'firstUser': firstUser.toJson(),
      'lastMessage': lastMessage,
      'lastSender': lastSender,
      'open': open,
      'id': id,
    };
  }

  Timestamp? lastMessageTime;
  String? lastMessage;
  String? lastSender;
  User secondUser;
  User firstUser;
  String? id;
  bool? open;
}
