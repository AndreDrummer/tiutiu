import 'dart:convert';

import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/services/chat_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/cesar_cripto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ChatController({required ChatService chatService}) : _chatService = chatService;

  final ChatService _chatService;

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

  TiutiuUser userChatingWith = TiutiuUser();

  Stream<List<Message>> messages(String chatId) {
    return _chatService.messages(
      chatId,
      _getChatId(
        receiverUserId: userChatingWith.uid!,
        senderUserId: tiutiuUserController.tiutiuUser.uid!,
      ),
    );
  }

  Stream<List<Contact>> contacts() => _chatService.contacts(tiutiuUserController.tiutiuUser.uid!);

  Future<void> sendNewMessage(Message message) async {
    final contact = Contact(
      userReceiverReference: await tiutiuUserController.getUserReferenceById(message.receiver.uid!),
      userSenderReference: await tiutiuUserController.getUserReferenceById(message.sender.uid!),
      id: _getChatId(senderUserId: message.sender.uid!, receiverUserId: message.receiver.uid!),
      userReceiverId: message.receiver.uid!,
      lastMessageTime: message.createdAt,
      userSenderId: message.sender.uid,
      lastMessage: message.text,
      open: false,
    );

    _chatService.sendMessageAndUpdateContact(message, contact);
  }

  Future<void> setupInteractedMessage([RemoteMessage? initialMessage]) async {
    print('77 To ligado..');
    // Get any messages which caused the application to open from
    // a terminated state.
    initialMessage ??= await FirebaseMessaging.instance.getInitialMessage();

    print('77 To ligado.. $initialMessage');

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      onNotificationMessageTapped(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationMessageTapped);
  }

  Future<void> markMessageAsRead(Contact contact) async {
    final myUserId = tiutiuUserController.tiutiuUser.uid;
    final userSenderId = contact.userSenderId;

    if (myUserId != userSenderId) _chatService.markMessageAsRead(contact, myUserId!);
  }

  Stream<TiutiuUser> receiverUser(Contact contact) {
    final userReference = getCorrectUserReceiverReference(contact);

    return userReference.snapshots().asyncMap((doc) {
      TiutiuUser user = TiutiuUser.fromMap(doc.data() as Map<String, dynamic>);

      return user;
    });
  }

  DocumentReference getCorrectUserReceiverReference(Contact contact) {
    if (tiutiuUserController.tiutiuUser.uid == contact.userReceiverId) return contact.userSenderReference!;
    if (tiutiuUserController.tiutiuUser.uid == contact.userSenderId) return contact.userReceiverReference!;
    return contact.userReceiverReference!;
  }

  String getCorrectUserReceiverId(Contact contact) {
    if (tiutiuUserController.tiutiuUser.uid == contact.userReceiverId) return contact.userSenderId!;
    if (tiutiuUserController.tiutiuUser.uid == contact.userSenderId) return contact.userReceiverId!;
    return contact.userReceiverId!;
  }

  String _getChatId({required String senderUserId, required String receiverUserId}) {
    final hash = GenerateHashKey.generateUniqueChatHash(senderUserId, receiverUserId);

    debugPrint('<> Generated Hash $hash');

    return hash;
  }

  void startsChatWith(TiutiuUser? user) {
    userChatingWith = user ?? TiutiuUser();

    Get.toNamed(Routes.chat);
  }

  void onNotificationMessageTapped(RemoteMessage message) {
    print('77 Euuu ${jsonDecode(message.data['data'])['sender']}');
    TiutiuUser sender = TiutiuUser.fromMap(jsonDecode(message.data['data'])[MessageEnum.sender.name]);

    startsChatWith(sender);
  }

  void resetUserChatingWith() {
    userChatingWith = TiutiuUser();
  }
}
