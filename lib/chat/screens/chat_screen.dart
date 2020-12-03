import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/chat/widgets/messages.dart';
import 'package:tiutiu/chat/widgets/new_message.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context).settings.arguments;
    final chatId = (routeArguments as Map)['chatId'];
    final chatTitle = (routeArguments as Map)['chatTitle'];
    final message = (routeArguments as Map)['message'];
    final receiverNotificationToken = (routeArguments as Map)['receiverNotificationToken'];
    final receiverId = (routeArguments as Map)['receiverId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatTitle,
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: Stack(
        children: [
          Background(
            dark: true,
          ),
          Container(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0, top: 8.0),
                    child: Messages(chatId: chatId),
                  ),
                ),
                NewMessage(chatId: chatId, message: message, receiverNotificationToken: receiverNotificationToken, receiverId: receiverId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
