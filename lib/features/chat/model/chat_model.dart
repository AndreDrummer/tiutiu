import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatEnum {
  lastMessageTime,
  lastSenderId,
  lastMessage,
  secondUser,
  firstUser,
  open,
  id,
}

class Chat {
  Chat({
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.lastMessage,
    required this.secondUser,
    required this.firstUser,
    this.open = false,
    required this.id,
  });

  factory Chat.fromSnapshot(DocumentSnapshot snapshot) {
    return Chat(
      secondUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ChatEnum.secondUser.name]),
      firstUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ChatEnum.firstUser.name]),
      lastMessageTime: (snapshot.data() as Map<String, dynamic>)[ChatEnum.lastMessageTime.name],
      lastSenderId: (snapshot.data() as Map<String, dynamic>)[ChatEnum.lastSenderId.name],
      lastMessage: (snapshot.data() as Map<String, dynamic>)[ChatEnum.lastMessage.name],
      open: (snapshot.data() as Map<String, dynamic>)[ChatEnum.open.name],
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ChatEnum.lastMessageTime.name: lastMessageTime,
      ChatEnum.secondUser.name: secondUser.toMap(),
      ChatEnum.firstUser.name: firstUser.toMap(),
      ChatEnum.lastMessage.name: lastMessage,
      ChatEnum.lastSenderId.name: lastSenderId,
      ChatEnum.open.name: open,
      ChatEnum.id.name: id,
    };
  }

  Timestamp? lastMessageTime;
  TiutiuUser secondUser;
  TiutiuUser firstUser;
  String? lastMessage;
  String? lastSenderId;
  String? id;
  bool? open;
}
