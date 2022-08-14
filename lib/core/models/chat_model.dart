import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';

enum ChatEnum {
  lastMessageTime,
  lastMessage,
  lastSender,
  secondUser,
  firstUser,
  open,
  id,
}

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
        firstUser = TiutiuUser.fromMap(
            (snapshot.data() as Map<String, dynamic>)['firstUser']),
        secondUser = TiutiuUser.fromMap(
            (snapshot.data() as Map<String, dynamic>)['secondUser']),
        lastSender = (snapshot.data() as Map<String, dynamic>)['lastSender'],
        id = snapshot.id,
        lastMessage = (snapshot.data() as Map<String, dynamic>)['lastMessage'],
        lastMessageTime =
            (snapshot.data() as Map<String, dynamic>)['lastMessageTime'];

  Map<String, dynamic> toJson() {
    return {
      'lastMessageTime': lastMessageTime,
      'secondUser': secondUser.toMap(),
      'firstUser': firstUser.toMap(),
      'lastMessage': lastMessage,
      'lastSender': lastSender,
      'open': open,
      'id': id,
    };
  }

  Timestamp? lastMessageTime;
  TiutiuUser secondUser;
  TiutiuUser firstUser;
  String? lastMessage;
  String? lastSender;
  String? id;
  bool? open;
}
