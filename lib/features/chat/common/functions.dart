import 'package:get/get.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/cesar_cripto.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:flutter/material.dart';

class CommonChatFunctions {
  static List<QueryDocumentSnapshot> orderedListByTime({
    required List<QueryDocumentSnapshot> docs,
    required String parameterOrder,
  }) {
    List<QueryDocumentSnapshot> newList = docs;
    newList.sort((a, b) {
      return b.get(parameterOrder) - a.get(parameterOrder);
    });

    return newList;
  }

  static void openChat({
    required TiutiuUser receiverUser,
    required TiutiuUser senderUser,
  }) {
    Get.toNamed(
      Routes.chat,
      arguments: {
        'chatId': GenerateHashKey.cesar(senderUser.uid!, receiverUser.uid!),
        'receiverNotificationToken': receiverUser.notificationToken,
        'chatTitle': receiverUser.displayName,
        'receiverId': receiverUser.uid,
        'message': Contact(
          lastMessageTime: Timestamp.now(),
          receiverUser: receiverUser,
          senderUser: senderUser,
          lastSenderId: '',
          lastMessage: '',
          id: '',
        ),
      },
    );
  }

  static List<Contact> searchChat(List<Contact> chatList, String textToFilter, String myId) {
    List<Contact> newChat = [];
    if (textToFilter.isNotEmpty) {
      for (Contact chat in chatList) {
        if (chat.senderUser.uid != myId &&
            chat.senderUser.displayName!.removeAccent().toLowerCase().contains(textToFilter.toLowerCase()))
          newChat.add(chat);
        if (chat.receiverUser != myId &&
            chat.receiverUser.displayName!.removeAccent().toLowerCase().contains(textToFilter.toLowerCase()))
          newChat.add(chat);
      }
      return newChat;
    } else {
      return chatList;
    }
  }

  static List<TiutiuUser> searchUser(List<TiutiuUser> userList, String textToFilter) {
    List<TiutiuUser> newUserList = [];
    if (textToFilter.isNotEmpty) {
      for (TiutiuUser user in userList) {
        if (user.displayName!.removeAccent().toLowerCase().contains(textToFilter.removeAccent().toLowerCase()))
          newUserList.add(user);
      }
      return newUserList;
    } else {
      return userList;
    }
  }

  static int orderByName(TiutiuUser a, TiutiuUser b) {
    List<int> aname = a.displayName!.trim().removeAccent().codeUnits;
    List<int> bname = b.displayName!.trim().removeAccent().codeUnits;

    if (a.displayName!.isEmpty) {
      aname = 'u'.codeUnits;
    }
    if (b.displayName!.isEmpty) {
      bname = 'u'.codeUnits;
    }

    int i = 0;
    while (i < bname.length) {
      if (bname[i] < aname[i]) {
        return 1;
      } else if (bname[i] == aname[i]) {
        i++;
        if (i >= aname.length) {
          return 1;
        }
      } else {
        return -1;
      }
    }
    return 1;
  }

  static int filterOnlyMyChats(AsyncSnapshot<QuerySnapshot> snapshot, String uid) {
    int qtd = 0;
    List<QueryDocumentSnapshot> messagesList = [];
    if (snapshot.data != null) {
      snapshot.data!.docs.forEach((element) {
        if (TiutiuUser.fromMap(element.get('senderUser')).uid == uid ||
            TiutiuUser.fromMap(element.get('receiverUser')).uid == uid) messagesList.add(element);
      });

      messagesList.forEach((e) {
        if (e.get('open') != null && !e.get('open') && e.get('lastSender') != uid) {
          qtd++;
        }
      });

      return qtd;
    }
    return qtd;
  }
}
