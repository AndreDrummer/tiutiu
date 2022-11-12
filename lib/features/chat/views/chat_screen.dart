import 'package:tiutiu/features/chat/widgets/message_bubble.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/chat/widgets/new_message.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedUserId = tiutiuUserController.tiutiuUser.uid!;

    return WillPopScope(
      onWillPop: () async {
        chatController.resetUserChatingWith();
        return true;
      },
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          text: OtherFunctions.firstCharacterUpper(chatController.userChatingWith.displayName!),
        ),
        body: StreamBuilder<List<Message>>(
          stream: chatController.messages(loggedUserId),
          builder: (context, snapshot) {
            return AsyncHandler<List<Message>>(
              emptyMessage: ChatStrings.startConversation,
              showLoadingScreen: false,
              snapshot: snapshot,
              buildWidget: (messages) {
                return SizedBox(
                  height: Get.height * .82,
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: ((context, index) {
                      final message = messages[index];
                      final previousMessage = index > 1 ? messages[index - 1] : message;

                      print('${previousMessage.sender.uid} == $loggedUserId');

                      return MessageBubble(
                        lastMessageWasMine: previousMessage.sender.uid == loggedUserId,
                        belongToMe: message.sender.uid == loggedUserId,
                        time: message.createdAt,
                        message: message.text!,
                        key: UniqueKey(),
                      );
                    }),
                    reverse: true,
                  ),
                );
              },
            );
          },
        ),
        bottomSheet: NewMessage(),
      ),
    );
  }
}
