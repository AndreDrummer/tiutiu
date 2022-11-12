import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ContactEnum {
  lastMessageTime,
  lastSenderId,
  lastMessage,
  secondUser,
  firstUser,
  open,
  id,
}

class Contact {
  factory Contact.fromSnapshot(DocumentSnapshot snapshot) {
    return Contact(
      secondUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ContactEnum.secondUser.name]),
      firstUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ContactEnum.firstUser.name]),
      lastMessageTime: (snapshot.data() as Map<String, dynamic>)[ContactEnum.lastMessageTime.name],
      lastSenderId: (snapshot.data() as Map<String, dynamic>)[ContactEnum.lastSenderId.name],
      lastMessage: (snapshot.data() as Map<String, dynamic>)[ContactEnum.lastMessage.name],
      open: (snapshot.data() as Map<String, dynamic>)[ContactEnum.open.name],
      id: snapshot.id,
    );
  }
  Contact({
    required this.lastMessageTime,
    required this.lastSenderId,
    required this.lastMessage,
    required this.secondUser,
    required this.firstUser,
    this.open = false,
    required this.id,
  });

  factory Contact.initial() {
    return Contact(
      secondUser: TiutiuUser(),
      firstUser: TiutiuUser(),
      lastMessageTime: null,
      lastSenderId: null,
      lastMessage: null,
      open: null,
      id: null,
    );
  }

  Contact copyWith({
    dynamic lastMessageTime,
    TiutiuUser? secondUser,
    TiutiuUser? firstUser,
    String? lastMessage,
    String? lastSenderId,
    String? id,
    bool? open,
  }) {
    return Contact(
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessage: lastMessage ?? this.lastMessage,
      secondUser: secondUser ?? this.secondUser,
      firstUser: firstUser ?? this.firstUser,
      open: open ?? this.open,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ContactEnum.lastMessageTime.name: lastMessageTime,
      ContactEnum.secondUser.name: secondUser.toMap(),
      ContactEnum.firstUser.name: firstUser.toMap(),
      ContactEnum.lastMessage.name: lastMessage,
      ContactEnum.lastSenderId.name: lastSenderId,
      ContactEnum.open.name: open,
      ContactEnum.id.name: id,
    };
  }

  dynamic lastMessageTime;
  TiutiuUser secondUser;
  TiutiuUser firstUser;
  String? lastMessage;
  String? lastSenderId;
  String? id;
  bool? open;
}
