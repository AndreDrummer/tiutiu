import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
