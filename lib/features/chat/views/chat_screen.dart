import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/features/dennounce/views/user_dennounce_screen.dart';
import 'package:tiutiu/features/chat/widgets/message_bubble.dart';
import 'package:tiutiu/features/chat/widgets/new_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/message.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/chat/model/enums.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class ChatScreen extends StatelessWidget with TiuTiuPopUp {
  const ChatScreen({
    required this.loggedUserId,
    super.key,
  });

  final String loggedUserId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        chatController.resetUserChatingWith();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              ImageCarouselBackground(autoPlay: false),
              Container(color: AppColors.black.withOpacity(.7)),
              Positioned.fill(
                bottom: Dimensions.getDimensBasedOnDeviceHeight(
                  smaller: 64.0.h,
                  medium: 48.0.h,
                  bigger: 56.0.h,
                ),
                top: 40.0.h,
                child: StreamBuilder<List<Message>>(
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
                                top: index == (messages.length - 1) ? 8.0.h : 0.0.h,
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
                        );
                      },
                    );
                  },
                ),
              ),
              Positioned(
                child: _appBar(),
                top: 0.0.h,
              ),
            ],
          ),
          bottomSheet: NewMessage(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      child: Container(
        height: 56.0,
        width: Get.width,
        color: AppColors.primary,
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
              onSelected: (String item) {
                if (item == ChatActionsEnum.dennounceUser.name) {
                  userDennounceController.updateUserDennounce(
                    UserDennounceEnum.dennouncedUser,
                    chatController.userChatingWith,
                  );

                  showsDennouncePopup(content: UserDennounceScreen());
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: ChatActionsEnum.deleteChat.name,
                  child: Text(ChatStrings.deleteChat),
                ),
                PopupMenuItem<String>(
                  child: Text(ChatStrings.dennounceUser(chatController.userChatingWith.displayName!.split(' ').first)),
                  value: ChatActionsEnum.dennounceUser.name,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
