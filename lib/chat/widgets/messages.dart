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

        chatDocs.forEach((a) {
          print('Element A ${a.get('createdAt')} ${a.get('text')}');
        });

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: MessageBubble(
                message: chatDocs[index].get('text'),
                userImage: chatDocs[index].get('userImage'),
                userName: chatDocs[index].get('userName'),
                belongToMe: chatDocs[index].get('userId') == myUserId,
                time: (chatDocs[index].get('createdAt'))?.toDate()?.toIso8601String() ?? DateTime.now().toIso8601String(),
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
