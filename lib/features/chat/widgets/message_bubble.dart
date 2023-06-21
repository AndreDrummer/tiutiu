import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.lastMessageBelongsToTheSameUser,
    required this.belongToMe,
    required this.message,
    required this.time,
    super.key,
  });

  final bool lastMessageBelongsToTheSameUser;
  final bool belongToMe;
  final String message;
  final dynamic time;

  EdgeInsetsGeometry _messagePadding(String messageText) {
    if (message.length > Get.width / 2) return EdgeInsets.symmetric(vertical: 8.0.h);
    return EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = time == null
        ? Formatters.getFormattedTime(DateTime.now().toIso8601String())
        : Formatters.getFormattedTime(time.toDate().toIso8601String());

    return ChatBubble(
      margin: EdgeInsets.only(top: lastMessageBelongsToTheSameUser ? 4.0.h : 16.0.h, left: 16.0.w, right: 12.0.w),
      backGroundColor: belongToMe ? Colors.lightGreen : Colors.deepPurple,
      shadowColor: belongToMe ? AppColors.secondary : AppColors.primary,
      padding: EdgeInsets.only(right: 12.0.w),
      elevation: 2.0,
      child: SizedBox(
        width: Get.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: AutoSizeTexts.autoSizeText14(
                textAlign: TextAlign.start,
                color: AppColors.white,
                message,
              ),
              padding: _messagePadding(message),
              margin: EdgeInsets.all(8.0.h),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0.h),
              child: AutoSizeTexts.autoSizeText10(
                textAlign: TextAlign.justify,
                color: AppColors.white,
                formattedTime,
              ),
              alignment: Alignment(1, 1),
            )
          ],
        ),
      ),
      clipper: ChatBubbleClipper1(
        type: belongToMe ? BubbleType.sendBubble : BubbleType.receiverBubble,
        nipRadius: lastMessageBelongsToTheSameUser ? 3.0 : 2.0,
        nipHeight: lastMessageBelongsToTheSameUser ? 5 : 10,
        nipWidth: 4.0.w,
        radius: 8.0.h,
      ),
      alignment: belongToMe ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
