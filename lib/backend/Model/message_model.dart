import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/backend/Model/user_model.dart';

class Message {
  Message({
    required this.receiverNotificationToken,
    required this.notificationType,
    required this.userReference,
    required this.receiverId,
    required this.createdAt,
    required this.userId,
    required this.user,
    required this.text,
  });

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : text = (snapshot.data() as Map<String, dynamic>)['text'],
        createdAt = (snapshot.data() as Map<String, dynamic>)['createdAt'],
        userId = (snapshot.data() as Map<String, dynamic>)['userId'],
        user = User.fromMap((snapshot.data() as Map<String, dynamic>)['user']),
        receiverId = (snapshot.data() as Map<String, dynamic>)['receiverId'],
        receiverNotificationToken = (snapshot.data()
            as Map<String, dynamic>)['receiverNotificationToken'],
        notificationType =
            (snapshot.data() as Map<String, dynamic>)['notificationType'],
        userReference =
            (snapshot.data() as Map<String, dynamic>)['userReference'];

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
