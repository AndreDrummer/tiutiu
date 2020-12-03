import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Messages extends StatelessWidget {
  Messages({this.chatId});

  final String chatId;
  @override
  Widget build(BuildContext context) {
    final myUserId = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream: firestore.collection('Chats').doc(chatId).collection('messages').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> chatDocs = snapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: MessageBubble(
                message: chatDocs[index].get('text'),
                userImage: '', //chatDocs[index].get('userImage'),
                userName: chatDocs[index].get('userName'),
                belongToMe: chatDocs[index].get('userId') == myUserId, //FirebaseAuth.instance.currentUser.uid,
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
