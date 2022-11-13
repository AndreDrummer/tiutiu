import 'package:tiutiu/features/chat/widgets/message_bubble.dart';
import 'package:tiutiu/features/chat/widgets/new_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

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
        appBar: _appBar(),
        body: StreamBuilder<List<Message>>(
          stream: chatController.messages(loggedUserId),
          builder: (context, snapshot) {
            return AsyncHandler<List<Message>>(
              emptyMessage: ChatStrings.startConversation,
              showLoadingScreen: false,
              snapshot: snapshot,
              buildWidget: (messages) {
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: ((context, index) {
                    final previousIndex = index + 1 >= messages.length ? index : index + 1;
                    final previousMessage = messages[previousIndex];
                    final message = messages[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: _bottomPaddingPlatform(index)),
                      child: MessageBubble(
                        lastMessageBelongsToTheSameUser: previousMessage.sender.uid == message.sender.uid,
                        belongToMe: message.sender.uid == loggedUserId,
                        time: message.createdAt,
                        message: message.text!,
                        key: UniqueKey(),
                      ),
                    );
                  }),
                  reverse: true,
                );
              },
            );
          },
        ),
        bottomSheet: NewMessage(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          GestureDetector(
            onTap: () => OtherFunctions.navigateToAnnouncerDetail(chatController.userChatingWith, popAndPush: true),
            child: CircleAvatar(
              backgroundColor: AppColors.secondary,
              radius: _avatarBorderPlatform(),
              child: CircleAvatar(
                child: ClipOval(
                  child: AssetHandle.getImage(
                    chatController.userChatingWith.avatar,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          AutoSizeTexts.autoSizeText20(
            OtherFunctions.firstCharacterUpper(
              chatController.userChatingWith.displayName!,
            ),
          ),
          SizedBox(width: Get.width / 2.7),
        ],
      ),
    );
  }

  double _avatarBorderPlatform() {
    if (Platform.isIOS) return 16.0.h;
    return 18.0.h;
  }

  double _bottomPaddingPlatform(int index) {
    if (index > 0) return 0.0;
    if (Platform.isIOS) return 32.0.h;
    return 56.0.h;
  }
}
