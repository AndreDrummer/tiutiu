import 'package:cloud_firestore/cloud_firestore.dart';

class CommonFunctions {
  static List<QueryDocumentSnapshot> orderedListByTime(List<QueryDocumentSnapshot> docs, {String parameterOrder}) {
    List<QueryDocumentSnapshot> newList = docs;
    newList.sort((a, b) {
      return b.get(parameterOrder) - a.get(parameterOrder);
    });

    return newList;
  }
}
