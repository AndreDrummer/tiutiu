import 'package:tiutiu/core/utils/cesar_cripto.dart';
import 'package:tiutiu/features/chat/services/chat_service.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ChatController extends GetxController {
  ChatController({required ChatService chatService}) : _chatService = chatService;

  final ChatService _chatService;

  final Rx<Contact> _contactChatingWith = Contact.initial().obs;
  final RxString _textGlobalChatSearch = ''.obs;
  final RxString _textChatSearch = ''.obs;
  final RxBool _isSearching = false.obs;
  final RxInt _currentlyTabChat = 0.obs;

  String get textGlobalChatSearch => _textGlobalChatSearch.value;
  int get currentlyTabChat => _currentlyTabChat.value;
  String get textChatSearch => _textChatSearch.value;
  bool get isSearching => _isSearching.value;

  void set contactChatingWith(Contact contact) => _contactChatingWith(contact);
  void set textGlobalChatSearch(String value) => _textGlobalChatSearch(value);
  void set textChatSearch(String value) => _textChatSearch(value);
  void set currentlyTabChat(int tab) => _currentlyTabChat(tab);
  void set isSearching(bool value) => _isSearching(value);

  Stream<List<Message>> messages(String chatId) => _chatService.messages(chatId, _generateChatId());

  Stream<List<Contact>> contacts(String userId) => _chatService.contacts(userId);

  void createFirstMessage(String chatId, Contact contact) {
    // firestore.collection('Chats').doc(chatId).set(chat.toJson(), SetOptions(merge: true));
  }

  void sendNewMessage(String chatId, Message message) {
    // firestore.collection('Chats').doc(chatId).collection('chat').add(message.toJson());
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

  String _generateChatId() {
    return GenerateHashKey.generateUniqueChatHash(
      tiutiuUserController.tiutiuUser.uid!,
      tiutiuUserController.tiutiuUser.uid!,
      // _contactChatingWith.value.id!,
    );
  }
}
