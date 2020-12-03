import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _messagesList = BehaviorSubject<List<QueryDocumentSnapshot>>();

  // Listening data
  Stream<List<QueryDocumentSnapshot>> get messagesList => _messagesList.stream;

  // Changing data
  void Function(List<QueryDocumentSnapshot>) get changeMessagesList => _messagesList.sink.add;

  // Getting data
  List<QueryDocumentSnapshot> get getMessagesList => _messagesList.value;

  void listOfMessages({String userId}) async {
    List<QueryDocumentSnapshot> messages = [];
    QuerySnapshot chats = await firestore.collection('Chats').get();

    chats.docs.forEach((element) {
      if (element.get('user1') == userId || element.get('user2') == userId) messages.add(element);
    });

    changeMessagesList(messages);
  }
}
