import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/services/chat_service.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
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

  // void set contactChatingWith(Contact contact) => _contactChatingWith(contact);
  void set textGlobalChatSearch(String value) => _textGlobalChatSearch(value);
  void set textChatSearch(String value) => _textChatSearch(value);
  void set currentlyTabChat(int tab) => _currentlyTabChat(tab);
  void set isSearching(bool value) => _isSearching(value);

  Contact contactChatingWith = Contact.initial();

  void resetContactChatingWith() {
    contactChatingWith = Contact.initial();
  }

  Stream<List<Message>> messages(String chatId) {
    return _chatService.messages(
      chatId,
      _getChatId(
        receiverUserId: contactChatingWith.receiverUser.uid!,
        senderUserId: tiutiuUserController.tiutiuUser.uid!,
      ),
    );
  }

  Stream<List<Contact>> contacts() => _chatService.contacts(tiutiuUserController.tiutiuUser.uid!);

  void sendNewMessage(Message message) {
    debugPrint('<> Before Update Contact ${contactChatingWith.lastMessage}');

    contactChatingWith = contactChatingWith.copyWith(
      lastMessageTime: message.createdAt,
      lastMessage: message.text,
    );
    debugPrint('<> After Update Contact ${contactChatingWith.lastMessage}');

    _chatService.sendMessage(message, contactChatingWith);
  }

  void updateContactLastMessage(Contact contact) {
    // firestore.collection('Chats').doc(chatId).set(messageData, SetOptions(merge: true));
  }

  void markMessageAsRead(String chatId) {
    // firestore.collection('Chats').doc(chatId).set({'open': true}, SetOptions(merge: true));
  }

  void newMessages() {
    // return FirebaseFirestore.instance.collection('Chats').snapshots();
  }

  void startsChatWith(TiutiuUser user) {
    contactChatingWith = Contact(
      id: _getChatId(senderUserId: tiutiuUserController.tiutiuUser.uid!, receiverUserId: user.uid!),
      lastSenderId: tiutiuUserController.tiutiuUser.uid,
      senderUser: tiutiuUserController.tiutiuUser,
      lastMessageTime: null,
      receiverUser: user,
      lastMessage: null,
    );

    debugPrint('<> MyUser ${contactChatingWith.senderUser.uid}');
    debugPrint('<> receiverUser ${contactChatingWith.receiverUser.uid}');
    Get.toNamed(Routes.chat);
  }

  String _getChatId({required String senderUserId, required String receiverUserId}) {
    final hash = GenerateHashKey.generateUniqueChatHash(senderUserId, receiverUserId);

    debugPrint('<> Generated Hash $hash');

    return hash;
  }
}
