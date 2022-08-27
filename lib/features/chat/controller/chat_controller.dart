import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/models/chat_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final RxString _textGlobalChatSearch = ''.obs;
  final RxString _textChatSearch = ''.obs;
  final RxBool _isSearching = false.obs;
  final RxInt _currentlyTabChat = 0.obs;

  String get textGlobalChatSearch => _textGlobalChatSearch.value;
  int get currentlyTabChat => _currentlyTabChat.value;
  String get textChatSearch => _textChatSearch.value;
  bool get isSearching => _isSearching.value;

  void set textGlobalChatSearch(String value) => _textGlobalChatSearch(value);
  void set textChatSearch(String value) => _textChatSearch(value);
  void set currentlyTabChat(int tab) => _currentlyTabChat(tab);
  void set isSearching(bool value) => _isSearching(value);

  Stream<QuerySnapshot> messagesList(String chatId) {
    return firestore
        .collection('Chats')
        .doc(chatId)
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> globalChatList() {
    return firestore.collection(FirebaseEnvPath.users).snapshots();
  }

  void createFirstMessage(String chatId, Chat chat) {
    firestore
        .collection('Chats')
        .doc(chatId)
        .set(chat.toJson(), SetOptions(merge: true));
  }

  void sendNewMessage(String chatId, Message message) {
    firestore
        .collection('Chats')
        .doc(chatId)
        .collection('chat')
        .add(message.toJson());
  }

  void updateLastMessage(String chatId, Map<String, dynamic> messageData) {
    firestore
        .collection('Chats')
        .doc(chatId)
        .set(messageData, SetOptions(merge: true));
  }

  void markMessageAsRead(String chatId) {
    firestore
        .collection('Chats')
        .doc(chatId)
        .set({'open': true}, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> newMessages() {
    return FirebaseFirestore.instance.collection('Chats').snapshots();
  }

  @override
  void dispose() {
    _textGlobalChatSearch.close();
    _textChatSearch.close();
    super.dispose();
  }
}
