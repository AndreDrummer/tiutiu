import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/features/chat/model/message.dart';

class ChatService extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> messages(String userId, String contactId) {
    return _pathToContact(userId, contactId).orderBy('createdAt', descending: true).snapshots().asyncMap((snapshot) {
      return snapshot.docs.map((favorite) => Message.fromSnapshot(favorite)).toList();
    });
  }

  Stream<List<Contact>> contacts(String userId) {
    return _pathToContacts(userId).orderBy('createdAt', descending: true).snapshots().asyncMap((snapshot) {
      return snapshot.docs.map((favorite) => Contact.fromSnapshot(favorite)).toList();
    });
  }

  CollectionReference<Map<String, dynamic>> _pathToContacts(String userId) {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.contacts)
        .collection(userId);
  }

  CollectionReference<Map<String, dynamic>> _pathToContact(String userId, String contactId) {
    return _firestore
        .collection(FirebaseEnvPath.projectName)
        .doc(FirebaseEnvPath.env)
        .collection(FirebaseEnvPath.environment)
        .doc(FirebaseEnvPath.contacts)
        .collection(userId)
        .doc(contactId)
        .collection(FirebaseEnvPath.messages);
  }
}
