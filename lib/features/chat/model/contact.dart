import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

enum ContactEnum {
  lastMessageTime,
  lastSenderId,
  lastMessage,
  receiverUser,
  senderUser,
  open,
  id,
}

class Contact {
  factory Contact.fromSnapshot(DocumentSnapshot snapshot) {
    return Contact(
      receiverUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ContactEnum.receiverUser.name]),
      senderUser: TiutiuUser.fromMap((snapshot.data() as Map<String, dynamic>)[ContactEnum.senderUser.name]),
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
    required this.receiverUser,
    required this.senderUser,
    this.open = false,
    required this.id,
  });

  factory Contact.initial() {
    return Contact(
      receiverUser: TiutiuUser(),
      senderUser: TiutiuUser(),
      lastMessageTime: null,
      lastSenderId: null,
      lastMessage: null,
      open: null,
      id: null,
    );
  }

  Contact copyWith({
    dynamic lastMessageTime,
    TiutiuUser? receiverUser,
    TiutiuUser? senderUser,
    String? lastMessage,
    String? lastSenderId,
    String? id,
    bool? open,
  }) {
    debugPrint('<> Updating Contact lastMessageTime... $lastMessageTime');
    debugPrint('<> Updating Contact receiverUser... $receiverUser');
    debugPrint('<> Updating Contact senderUser... $senderUser');
    debugPrint('<> Updating Contact lastMessage... $lastMessage');
    debugPrint('<> Updating Contact lastSenderId... $lastSenderId');
    debugPrint('<> Updating Contact id... $id');
    debugPrint('<> Updating Contact open... $open');

    return Contact(
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessage: lastMessage ?? this.lastMessage,
      receiverUser: receiverUser ?? this.receiverUser,
      senderUser: senderUser ?? this.senderUser,
      open: open ?? this.open,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ContactEnum.receiverUser.name: receiverUser.toMap(),
      ContactEnum.lastMessageTime.name: lastMessageTime,
      ContactEnum.senderUser.name: senderUser.toMap(),
      ContactEnum.lastSenderId.name: lastSenderId,
      ContactEnum.lastMessage.name: lastMessage,
      ContactEnum.lastMessage.name: lastMessage,
      ContactEnum.open.name: open,
      ContactEnum.id.name: id,
    };
  }

  dynamic lastMessageTime;
  TiutiuUser receiverUser;
  TiutiuUser senderUser;
  String? lastSenderId;
  String? lastMessage;
  String? id;
  bool? open;
}
