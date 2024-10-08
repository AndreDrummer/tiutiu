import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/model/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.createdAt,
    required this.receiver,
    required this.sender,
    required this.text,
    required this.id,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    return Message(
      receiver: TiutiuUser.fromMap(snapshot.get(MessageEnum.receiver.name)),
      sender: TiutiuUser.fromMap(snapshot.get(MessageEnum.sender.name)),
      createdAt: snapshot.get(MessageEnum.createdAt.name),
      text: snapshot.get(MessageEnum.text.name),
      id: snapshot.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MessageEnum.receiver.name: receiver.toMap(),
      MessageEnum.sender.name: sender.toMap(),
      MessageEnum.createdAt.name: createdAt,
      MessageEnum.text.name: text,
      MessageEnum.id.name: id,
    };
  }

  TiutiuUser receiver;
  TiutiuUser sender;
  dynamic createdAt;
  String? text;
  String? id;
}
