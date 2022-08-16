import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/models/chat_model.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/utils/cesar_cripto.dart';
import 'package:tiutiu/utils/string_extension.dart';

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
    required BuildContext context,
    required TiutiuUser firstUser,
    required TiutiuUser secondUser,
  }) {
    Navigator.pushNamed(
      context,
      Routes.chat,
      arguments: {
        'chatId': GenerateHashKey.cesar(firstUser.uid!, secondUser.uid!),
        'receiverNotificationToken': secondUser.notificationToken,
        'chatTitle': secondUser.displayName,
        'receiverId': secondUser.uid,
        'message': Chat(
          lastMessageTime: Timestamp.now(),
          secondUser: secondUser,
          firstUser: firstUser,
          lastMessage: '',
          lastSender: '',
          id: '',
        ),
      },
    );
  }

  static List<Chat> searchChat(
      List<Chat> chatList, String textToFilter, String myId) {
    List<Chat> newChat = [];
    if (textToFilter.isNotEmpty) {
      for (Chat chat in chatList) {
        if (chat.firstUser.uid != myId &&
            chat.firstUser.displayName!
                .removeAccent()
                .toLowerCase()
                .contains(textToFilter.toLowerCase())) newChat.add(chat);
        if (chat.secondUser != myId &&
            chat.secondUser.displayName!
                .removeAccent()
                .toLowerCase()
                .contains(textToFilter.toLowerCase())) newChat.add(chat);
      }
      return newChat;
    } else {
      return chatList;
    }
  }

  static List<TiutiuUser> searchUser(
      List<TiutiuUser> userList, String textToFilter) {
    List<TiutiuUser> newUserList = [];
    if (textToFilter.isNotEmpty) {
      for (TiutiuUser user in userList) {
        if (user.displayName!
            .removeAccent()
            .toLowerCase()
            .contains(textToFilter.removeAccent().toLowerCase()))
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

  static int filterOnlyMyChats(
      AsyncSnapshot<QuerySnapshot> snapshot, String uid) {
    int qtd = 0;
    List<QueryDocumentSnapshot> messagesList = [];
    if (snapshot.data != null) {
      snapshot.data!.docs.forEach((element) {
        if (TiutiuUser.fromMap(element.get('firstUser')).uid == uid ||
            TiutiuUser.fromMap(element.get('secondUser')).uid == uid)
          messagesList.add(element);
      });

      messagesList.forEach((e) {
        if (e.get('open') != null &&
            !e.get('open') &&
            e.get('lastSender') != uid) {
          qtd++;
        }
      });

      return qtd;
    }
    return qtd;
  }
}
