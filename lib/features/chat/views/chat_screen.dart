import 'package:tiutiu/features/chat/widgets/message_bubble.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/chat/widgets/new_message.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(
        text: OtherFunctions.firstCharacterUpper(
          'chatController.contactChatingWith.secondUser.displayName!',
        ),
      ),
      body: StreamBuilder<List<Message>>(
        stream: chatController.messages(tiutiuUserController.tiutiuUser.uid!),
        builder: (context, snapshot) {
          return AsyncHandler<List<Message>>(
            showLoadingScreen: false,
            emptyMessage: ChatStrings.noContact,
            forceReturnBuildWidget: true,
            forcedDataReturned: [Message(createdAt: 'createdAt', senderId: 'senderId', text: 'text', id: 'id')],
            snapshot: snapshot,
            buildWidget: (contacts) {
              return ListView.builder(
                itemCount: 6,
                itemBuilder: ((context, index) {
                  return MessageBubble(
                    lastMessageWasMine: index == 3,
                    belongToMe: index < 3,
                    message: index < 3
                        ? 'Olá, tudo bem? Vi que voce esta doando um shitsu, queria saber mais informacaoes'
                        : 'Tudo sim e você? Entao... ja doei ele. Valeu!',
                    time: DateTime.now().toIso8601String(),
                  );
                }),
              );
            },
          );
        },
      ),
      bottomSheet: NewMessage(
        receiverNotificationToken: '',
        contact: Contact.initial(),
        receiverId: '',
      ),
    );
  }
}
