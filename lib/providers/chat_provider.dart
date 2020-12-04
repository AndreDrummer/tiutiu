import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiutiu/backend/Model/chat_model.dart';
import 'package:tiutiu/backend/Model/message_model.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> messagesList(String chatId) {
    return firestore.collection('Chats').doc(chatId).collection('chat').orderBy('createdAt', descending: true).snapshots();
  }

  void createFirstMessage(String chatId, Chat chat) {
    firestore.collection('Chats').doc(chatId).set(chat.toJson(), SetOptions(merge: true));
  }

  void sendNewMessage(String chatId, Message message) {
    firestore.collection('Chats').doc(chatId).collection('chat').add(message.toJson());
  }

  void updateLastMessage(String chatId, Map<String, dynamic> messageData) {
    firestore.collection('Chats').doc(chatId).set(messageData, SetOptions(merge: true));
  }

  void markMessageAsRead(String chatId) {
    firestore.collection('Chats').doc(chatId).set({'open': true}, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> newMessages() {
    return FirebaseFirestore.instance.collection('Chats').snapshots();
  }
}
