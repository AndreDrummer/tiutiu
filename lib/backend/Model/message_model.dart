import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Model/user_model.dart';

class Message {
  Message({
    this.text,
    this.createdAt,
    this.userId,
    this.user,
    this.receiverId,
    this.receiverNotificationToken,
    this.notificationType,
    this.userReference,
  });

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : text = snapshot.data()['text'],
        createdAt = snapshot.data()['createdAt'],
        userId = snapshot.data()['userId'],
        user = User.fromMap(snapshot.data()['user']),
        receiverId = snapshot.data()['receiverId'],
        receiverNotificationToken = snapshot.data()['receiverNotificationToken'],
        notificationType = snapshot.data()['notificationType'],
        userReference = snapshot.data()['userReference'];

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt,
      'userId': userId,
      'user': user.toJson(),
      'receiverId': receiverId,
      'receiverNotificationToken': receiverNotificationToken,
      'notificationType': notificationType,
      'userReference': userReference
    };
  }

  String text;
  dynamic createdAt;
  String userId;
  User user;
  String receiverId;
  String receiverNotificationToken;
  String notificationType;
  DocumentReference userReference;
}
