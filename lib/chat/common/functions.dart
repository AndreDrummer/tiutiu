import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/backend/Model/chat_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart';
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
    required User firstUser,
    required User secondUser,
  }) {
    Navigator.pushNamed(
      context,
      Routes.chat,
      arguments: {
        'chatId': GenerateHashKey.cesar(firstUser.id!, secondUser.id!),
        'chatTitle': secondUser.name,
        'receiverNotificationToken': secondUser.notificationToken,
        'receiverId': secondUser.id,
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
        if (chat.firstUser.id != myId &&
            chat.firstUser.name!
                .removeAccent()
                .toLowerCase()
                .contains(textToFilter.toLowerCase())) newChat.add(chat);
        if (chat.secondUser != myId &&
            chat.secondUser.name!
                .removeAccent()
                .toLowerCase()
                .contains(textToFilter.toLowerCase())) newChat.add(chat);
      }
      return newChat;
    } else {
      return chatList;
    }
  }

  static List<User> searchUser(List<User> userList, String textToFilter) {
    List<User> newUserList = [];
    if (textToFilter.isNotEmpty) {
      for (User user in userList) {
        if (user.name!
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

  static int orderByName(User a, User b) {
    List<int> aname = a.name!.trim().removeAccent().codeUnits;
    List<int> bname = b.name!.trim().removeAccent().codeUnits;

    if (a.name!.isEmpty) {
      aname = 'u'.codeUnits;
    }
    if (b.name!.isEmpty) {
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
        if (User.fromMap(element.get('firstUser')).id == uid ||
            User.fromMap(element.get('secondUser')).id == uid)
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
