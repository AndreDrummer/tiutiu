import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    this.text,
    this.createdAt,
    this.userId,
    this.userName,
    this.userImage,
    this.receiverId,
    this.receiverNotificationToken,
    this.notificationType,
    this.userReference,
    this.open,
  });

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : text = snapshot.data()['text'],
        createdAt = snapshot.data()['createdAt'],
        userId = snapshot.data()['userId'],
        userName = snapshot.data()['userName'],
        userImage = snapshot.data()['userImage'],
        receiverId = snapshot.data()['receiverId'],
        receiverNotificationToken = snapshot.data()['receiverNotificationToken'],
        notificationType = snapshot.data()['notificationType'],
        userReference = snapshot.data()['userReference'],
        open = snapshot.data()['open'];

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'receiverId': receiverId,
      'receiverNotificationToken': receiverNotificationToken,
      'notificationType': notificationType,
      'userReference': userReference,
      'open': open,
    };
  }

  String text;
  dynamic createdAt;
  String userId;
  String userName;
  String userImage;
  String receiverId;
  String receiverNotificationToken;
  String notificationType;
  DocumentReference userReference;
  bool open;
}
