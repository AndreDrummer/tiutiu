import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/backend/Model/message_model.dart';
import 'package:tiutiu/providers/chat_provider.dart';

import 'message_bubble.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Messages extends StatelessWidget {
  Messages({
    this.chatId,
    this.chatProvider,
  });

  final String chatId;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    final myUserId = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream: chatProvider.messagesList(chatId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> chatDocs = snapshot.data.documents;

        return ListView.builder(
          key: UniqueKey(),
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: MessageBubble(
                message: Message.fromSnapshot(chatDocs[index]).text.trim(),
                userImage: Message.fromSnapshot(chatDocs[index]).userImage,
                userName: Message.fromSnapshot(chatDocs[index]).userName,
                belongToMe: Message.fromSnapshot(chatDocs[index]).userId == myUserId,
                time: (Message.fromSnapshot(chatDocs[index]).createdAt)?.toDate()?.toIso8601String() ?? DateTime.now().toIso8601String(),
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
