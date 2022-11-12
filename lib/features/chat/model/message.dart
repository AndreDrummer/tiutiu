import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageEnum {
  createdAt,
  senderId,
  text,
  id,
}

class Message {
  Message({
    required this.createdAt,
    required this.senderId,
    required this.text,
    required this.id,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    return Message(
      createdAt: (snapshot.data() as Map<String, dynamic>)[MessageEnum.createdAt.name],
      senderId: (snapshot.data() as Map<String, dynamic>)[MessageEnum.senderId.name],
      text: (snapshot.data() as Map<String, dynamic>)[MessageEnum.text.name],
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MessageEnum.createdAt.name: createdAt,
      MessageEnum.senderId.name: senderId,
      MessageEnum.text.name: text,
      MessageEnum.id.name: id,
    };
  }

  dynamic createdAt;
  String? senderId;
  String? text;
  String? id;
}
