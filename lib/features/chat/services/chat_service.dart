import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';

class ChatService extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream myContacts(String userId) {
    return _pathToChats(userId).orderBy('createdAt', descending: true).snapshots();
  }

  CollectionReference<Map<String, dynamic>> _pathToChats(String userId) {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.chats)
        .collection(userId);
  }

  DocumentReference<Map<String, dynamic>> _pathToChat(String chatId) {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.chats)
        .collection(FirebaseEnvPath.chats)
        .doc(chatId);
  }
}
