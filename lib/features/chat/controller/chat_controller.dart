import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/chat/services/chat_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/chat/model/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/cesar_cripto.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:convert';

class ChatController extends GetxController with TiuTiuPopUp {
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
  DocumentReference? _postTalkingAbout;

  Stream<List<Message>> messages(String loggedUserId) {
    return _chatService.messages(
      loggedUserId,
      _getChatId(
        receiverUserId: userChatingWith.uid!,
        senderUserId: loggedUserId,
      ),
    );
  }

  Future<void> deleteChat(String loggedUserId) async {
    final chatId = _getChatId(
      receiverUserId: userChatingWith.uid!,
      senderUserId: loggedUserId,
    );

    await _chatService.deleteChatMessages(
      userId: loggedUserId,
      contactId: chatId,
    );

    await _chatService.deleteChat(
      userId: loggedUserId,
      contactId: chatId,
    );
  }

  Stream<Pet> postTalkingAboutData() {
    if (_postTalkingAbout != null) {
      return _chatService.postTalkingAbout(_postTalkingAbout!);
    } else {
      return Stream.value(Pet());
    }
  }

  Stream<List<Contact>> contacts() => _chatService.contacts(tiutiuUserController.tiutiuUser.uid!);

  Stream<int> newMessagesCount() {
    return contacts().asyncMap((contactList) {
      return contactList.where((message) => !message.open).toList().length;
    });
  }

  Future<void> sendNewMessage(Message message) async {
    final contact = Contact(
      userReceiverReference: await tiutiuUserController.getUserReferenceById(message.receiver.uid!),
      userSenderReference: await tiutiuUserController.getUserReferenceById(message.sender.uid!),
      id: _getChatId(senderUserId: message.sender.uid!, receiverUserId: message.receiver.uid!),
      userReceiverId: message.receiver.uid!,
      postTalkingAbout: _postTalkingAbout,
      lastMessageTime: message.createdAt,
      userSenderId: message.sender.uid,
      lastMessage: message.text,
      open: false,
    );

    _chatService.sendMessageAndUpdateContact(message, contact);
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

    if (kDebugMode) debugPrint('TiuTiuApp: Generated Hash $hash');

    return hash;
  }

  Future<void> setupInteractedMessage([RemoteMessage? initialMessage]) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    initialMessage ??= await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      await onNotificationMessageTapped(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationMessageTapped);
  }

  Future<void> onNotificationMessageTapped(RemoteMessage message) async {
    TiutiuUser myUser = TiutiuUser.fromMap(jsonDecode(message.data['data'])[MessageEnum.receiver.name]);
    TiutiuUser messageSender = TiutiuUser.fromMap(jsonDecode(message.data['data'])[MessageEnum.sender.name]);

    TiutiuUser sender = await tiutiuUserController.getUserById(messageSender.uid!);

    if (!sender.userDeleted) {
      chatController.startsChatWith(
        myUserId: myUser.uid!,
        user: sender,
      );
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  void setPostTalkingAbout(DocumentReference? reference, [String? postId]) {
    if (reference == null) {
      if (postId != null) _postTalkingAbout = PostUtils.updatePostReferenceAndReturn(postId);
    } else {
      _postTalkingAbout = reference;
    }
  }

  void startsChatWith({TiutiuUser? user, required String myUserId}) {
    userChatingWith = user ?? TiutiuUser();

    if (authController.userExists && tiutiuUserController.isAppropriatelyRegistered) {
      Get.toNamed(Routes.chat, arguments: myUserId);
    } else if (authController.userExists) {
      Get.toNamed(Routes.editProfile);
    } else {
      Get.toNamed(Routes.authHosters);
    }
  }

  void resetUserChatingWith() {
    userChatingWith = TiutiuUser();
  }

  Future<void> handleContactTapped({required ContactType contactType, required Function() openDesiredChat}) async {
    final lastTimeWatchedRewarded = await LocalStorage.getValueUnderLocalStorageKey(
      contactType == ContactType.whatsapp
          ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
          : LocalStorageKey.lastTimeWatchedChatRewarded,
    );

    final allowGoogleAds = adminRemoteConfigController.configs.allowGoogleAds;

    debugPrint(
      'TiuTiuApp: Last Time Watched a ${contactType == ContactType.whatsapp ? 'WhatsApp Rewarded' : 'Chat Rewarded'} $lastTimeWatchedRewarded',
    );

    if (!allowGoogleAds) {
      await openDesiredChat();
    } else if (lastTimeWatchedRewarded == null) {
      warningUserAboutRewarded(contactType, noPreviousData: true);
    } else {
      final minutes = DateTime.now().difference(DateTime.parse(lastTimeWatchedRewarded)).inMinutes;

      if (minutes >= adMobController.minutesFreeOfRewardedAd(contactType)) {
        if (kDebugMode) debugPrint('TiuTiuApp: Must Show Rewarded..');
        warningUserAboutRewarded(contactType);
      } else {
        await openDesiredChat();
      }
    }
  }

  Future<void> warningUserAboutRewarded(ContactType contactType, {bool noPreviousData = false}) async {
    final allowGoogleAds = adminRemoteConfigController.configs.allowGoogleAds;
    final contactTypeIsWpp = contactType == ContactType.whatsapp;

    await LocalStorage.deleteDataUnderLocalStorageKey(
      contactTypeIsWpp ? LocalStorageKey.lastTimeWatchedWhatsappRewarded : LocalStorageKey.lastTimeWatchedChatRewarded,
    );

    await showPopUp(
      message: CustomStrings.watchAnAd(contactType, noPreviousData),
      confirmText: AppLocalizations.of(Get.context!).back,
      textColor: AppColors.white,
      mainAction: () async {
        Get.back();
        await adMobController.showRewardedAd(contactType, allowGoogleAds);
      },
      secondaryAction: () {
        Get.back();
      },
      backGroundColor: contactTypeIsWpp ? AppColors.success : AppColors.secondary,
      denyText: AppLocalizations.of(Get.context!).watch,
      barrierDismissible: false,
      title: AppLocalizations.of(Get.context!).warning,
    );
  }
}
