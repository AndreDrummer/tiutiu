import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/chat/widgets/messages.dart';
import 'package:tiutiu/chat/widgets/new_message.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatScreen extends StatelessWidget {
  ChatScreen({
    this.chatId = 'NmCCTS278fS56PzdutXj',
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Messages(chatId: chatId),
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }
}
