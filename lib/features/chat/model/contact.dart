import 'package:tiutiu/features/chat/model/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Contact {
  factory Contact.fromSnapshot(DocumentSnapshot snapshot) {
    return Contact(
      userReceiverReference: (snapshot.data() as Map<String, dynamic>)[ContactEnum.userReceiverReference.name],
      userSenderReference: (snapshot.data() as Map<String, dynamic>)[ContactEnum.userSenderReference.name],
      postTalkingAbout: (snapshot.data() as Map<String, dynamic>)[ContactEnum.postTalkingAbout.name],
      lastMessageTime: (snapshot.data() as Map<String, dynamic>)[ContactEnum.lastMessageTime.name],
      userReceiverId: (snapshot.data() as Map<String, dynamic>)[ContactEnum.userReceiverId.name],
      userSenderId: (snapshot.data() as Map<String, dynamic>)[ContactEnum.userSenderId.name],
      lastMessage: (snapshot.data() as Map<String, dynamic>)[ContactEnum.lastMessage.name],
      open: (snapshot.data() as Map<String, dynamic>)[ContactEnum.open.name],
      id: snapshot.id,
    );
  }
  Contact({
    this.userReceiverReference,
    this.userSenderReference,
    this.postTalkingAbout,
    this.lastMessageTime,
    this.userReceiverId,
    this.open = false,
    this.userSenderId,
    this.lastMessage,
    this.id,
  });

  Contact copyWith({
    DocumentReference? userReceiverReference,
    DocumentReference? userSenderReference,
    DocumentReference? postTalkingAbout,
    dynamic lastMessageTime,
    String? userReceiverId,
    String? userSenderId,
    String? lastMessage,
    String? id,
    bool? open,
  }) {
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact userSenderReference... $userSenderReference');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact postTalkingAbout... $postTalkingAbout');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact lastMessageTime... $lastMessageTime');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact userReceiverId... $userReceiverId');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact userSenderId... $userSenderId');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact lastMessage... $lastMessage');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact open... $open');
    if (kDebugMode) debugPrint('TiuTiuApp: Updating Contact id... $id');

    return Contact(
      userReceiverReference: userReceiverReference ?? this.userReceiverReference,
      userSenderReference: userSenderReference ?? this.userSenderReference,
      postTalkingAbout: postTalkingAbout ?? this.postTalkingAbout,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      userReceiverId: userReceiverId ?? this.userReceiverId,
      userSenderId: userSenderId ?? this.userSenderId,
      lastMessage: lastMessage ?? this.lastMessage,
      open: open ?? this.open,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ContactEnum.userReceiverReference.name: userReceiverReference,
      ContactEnum.userSenderReference.name: userSenderReference,
      ContactEnum.userSenderReference.name: userSenderReference,
      ContactEnum.postTalkingAbout.name: postTalkingAbout,
      ContactEnum.lastMessageTime.name: lastMessageTime,
      ContactEnum.userReceiverId.name: userReceiverId,
      ContactEnum.userSenderId.name: userSenderId,
      ContactEnum.lastMessage.name: lastMessage,
      ContactEnum.open.name: open,
      ContactEnum.id.name: id,
    };
  }

  DocumentReference? userReceiverReference;
  DocumentReference? userSenderReference;
  DocumentReference? postTalkingAbout;
  dynamic lastMessageTime;
  String? userReceiverId;
  String? userSenderId;
  String? lastMessage;
  String? id;
  bool open;
}
