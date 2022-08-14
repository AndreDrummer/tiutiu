import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/chat/widgets/messages.dart';
import 'package:tiutiu/chat/widgets/new_message.dart';
import 'package:tiutiu/providers/chat_provider.dart';
import 'package:tiutiu/utils/other_functions.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)!.settings.arguments;
    final chatId = (routeArguments as Map)['chatId'];
    final chatTitle = (routeArguments)['chatTitle'];
    final message = (routeArguments)['message'];
    final receiverNotificationToken =
        (routeArguments)['receiverNotificationToken'];
    final receiverId = (routeArguments)['receiverId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          OtherFunctions.firstCharacterUpper(chatTitle),
          style: Theme.of(context).textTheme.headline1!.copyWith(
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 16.0, top: 8.0),
                    child: Messages(
                      chatId: chatId,
                      chatProvider: Provider.of<ChatProvider>(context),
                    ),
                  ),
                ),
                NewMessage(
                  receiverNotificationToken: receiverNotificationToken,
                  receiverId: receiverId,
                  chatId: chatId,
                  chat: message,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
