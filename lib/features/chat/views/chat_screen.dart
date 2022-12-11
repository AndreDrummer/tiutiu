import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/chat/widgets/message_bubble.dart';
import 'package:tiutiu/features/chat/widgets/new_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
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
        backgroundColor: AppColors.black,
        appBar: _appBar(),
        body: Stack(
          children: [
            ImageCarouselBackground(),
            Container(color: AppColors.black.withOpacity(.7)),
            StreamBuilder<List<Message>>(
              stream: chatController.messages(loggedUserId),
              builder: (context, snapshot) {
                return AsyncHandler<List<Message>>(
                  emptyWidget: AutoSizeTexts.autoSizeText16(
                    ChatStrings.startConversation,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
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
                          padding: EdgeInsets.only(
                            bottom: index > 0
                                ? 0
                                : Dimensions.getDimensBasedOnDeviceHeight(
                                    greaterDeviceHeightDouble: 32.0.h,
                                    minDeviceHeightDouble: 56.0.h,
                                  ),
                          ),
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
          ],
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
              radius: Dimensions.getDimensBasedOnDeviceHeight(
                minDeviceHeightDouble: 18.0.h,
                greaterDeviceHeightDouble: 16.0.h,
              ),
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
              chatController.userChatingWith.displayName!.split(' ').first,
            ),
          ),
          SizedBox(width: Get.width / 2.15),
        ],
      ),
    );
  }
}
