import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Messages extends StatelessWidget {
  Messages({
    this.chatId = 'NmCCTS278fS56PzdutXj',
  });

  final String chatId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection('Chats').doc(chatId).collection('messages').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final chatDocs = snapshot.data.documents;
        return ListView.builder(
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Text(
              chatDocs[index].get('text'),
            );
          },
        );
      },
    );
  }
}
