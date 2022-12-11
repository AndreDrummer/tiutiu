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
import 'package:tiutiu/core/utils/formatter.dart';
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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Column(
            children: [
              _appBar(),
              Expanded(
                child: Stack(
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
                            return SizedBox(
                              height: Dimensions.getDimensBasedOnDeviceHeight(
                                greaterDeviceHeightDouble: Get.height - 208,
                                minDeviceHeightDouble: Get.height - 144,
                              ),
                              child: ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: ((context, index) {
                                  final previousIndex = index + 1 >= messages.length ? index : index + 1;
                                  final previousMessage = messages[previousIndex];
                                  final message = messages[index];

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: index > 0 ? 0 : 8.0.h,
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
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomSheet: NewMessage(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      height: 56.0,
      width: double.infinity,
      color: AppColors.primary,
      child: Container(
        width: Get.width / 2,
        child: Row(
          children: [
            BackButton(color: AppColors.white),
            GestureDetector(
              onTap: () => OtherFunctions.navigateToAnnouncerDetail(chatController.userChatingWith, popAndPush: true),
              child: CircleAvatar(
                backgroundColor: AppColors.secondary,
                radius: 11.0.h,
                child: CircleAvatar(
                  radius: 10.0.h,
                  child: ClipOval(
                    child: AssetHandle.getImage(
                      chatController.userChatingWith.avatar,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0.w),
            AutoSizeTexts.autoSizeText16(
              Formatters.cuttedText(chatController.userChatingWith.displayName!, size: 17),
              color: AppColors.white,
            ),
            Spacer(),
            PopupMenuButton<String>(
              icon: Icon(
                Platform.isIOS ? Icons.more_horiz_outlined : Icons.more_vert_outlined,
                color: AppColors.white,
              ),
              onSelected: (String item) {},
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'trocarDepois1',
                  child: Text(ChatStrings.deleteChat),
                ),
                PopupMenuItem<String>(
                  child: Text(ChatStrings.dennounceUser(chatController.userChatingWith.displayName!.split(' ').first)),
                  value: 'trocarDepois2',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
