import 'package:cloud_firestore/cloud_firestore.dart';

class CommonFunctions {
  static List<QueryDocumentSnapshot> orderedListByTime(List<QueryDocumentSnapshot> docs, {String parameterOrder}) {
    List<QueryDocumentSnapshot> newList = docs;
    newList.sort((a, b) {
      Timestamp stampA = a.get(parameterOrder);
      Timestamp stampB = b.get(parameterOrder);
      DateTime dateA = stampA.toDate();
      DateTime dateB = stampB.toDate();
      return dateB.millisecondsSinceEpoch - dateA.millisecondsSinceEpoch;
    });

    return newList;
  }
}
