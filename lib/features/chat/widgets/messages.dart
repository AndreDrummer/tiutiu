import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'message_bubble.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Messages extends StatelessWidget {
  Messages({
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    final myUserId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: null,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> chatDocs = snapshot.data!.documents;

        return ListView.builder(
          key: UniqueKey(),
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: MessageBubble(
                message: Message.fromSnapshot(chatDocs[index]).text.trim(),
                user: Message.fromSnapshot(chatDocs[index]).user,
                belongToMe: Message.fromSnapshot(chatDocs[index]).userId == myUserId,
                time: (Message.fromSnapshot(chatDocs[index]).createdAt)?.toDate()?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
