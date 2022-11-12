import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ContactTile extends StatelessWidget {
  ContactTile({
    required this.hasNewMessage,
    required this.messageId,
    required this.myUserId,
    required this.contact,
  });

  final bool hasNewMessage;
  final String messageId;
  final String myUserId;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    // Determina se o usuário logado é o primeiro usuário do contact.
    bool itsMe = myUserId == contact.firstUser.uid;
    Timestamp stamp = contact.lastMessageTime!;
    DateTime date = stamp.toDate();

    String profilePic = itsMe ? contact.secondUser.avatar! : contact.firstUser.avatar!;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chat,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe
                ? OtherFunctions.firstCharacterUpper(contact.secondUser.displayName!)
                : OtherFunctions.firstCharacterUpper(contact.firstUser.displayName!),
            'secondUserId': itsMe ? contact.secondUser.uid : contact.firstUser.uid,
            'receiverId': itsMe ? contact.secondUser.uid : contact.firstUser.uid,
            'receiverNotificationToken':
                itsMe ? contact.secondUser.notificationToken : contact.firstUser.notificationToken,
          },
        );
        chatController.markMessageAsRead(messageId);
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () => OtherFunctions.navigateToAnnouncerDetail(itsMe ? contact.secondUser : contact.firstUser),
              child: CircleAvatar(
                child: ClipOval(child: AssetHandle.getImage(profilePic)),
                backgroundColor: Colors.transparent,
              ),
            ),
            title: AutoSizeTexts.autoSizeText14(
                itsMe
                    ? OtherFunctions.firstCharacterUpper(contact.secondUser.displayName!)
                    : OtherFunctions.firstCharacterUpper(contact.firstUser.displayName!),
                fontWeight: FontWeight.bold),
            subtitle:
                AutoSizeTexts.autoSizeText12(contact.lastMessage!, fontWeight: hasNewMessage ? FontWeight.bold : null),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Badge(color: AppColors.primary, text: ChatStrings.news, show: hasNewMessage),
                    Padding(
                      child: AutoSizeTexts.autoSizeText10(Formatters.getFormattedTime(date.toIso8601String())),
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    ),
                    AutoSizeTexts.autoSizeText10(Formatters.getFormattedDate(date.toIso8601String())),
                  ],
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
