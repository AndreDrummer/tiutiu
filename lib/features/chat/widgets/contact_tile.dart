import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  ContactTile({
    required this.hasNewMessage,
    required this.onContactTap,
    required this.messageId,
    required this.myUserId,
    required this.contact,
  });

  final Function()? onContactTap;
  final bool hasNewMessage;
  final String messageId;
  final String myUserId;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    bool itsMe = myUserId == contact.senderUser.uid;
    String profilePic = itsMe ? contact.receiverUser.avatar! : contact.senderUser.avatar!;
    Timestamp stamp = contact.lastMessageTime!;
    DateTime date = stamp.toDate();

    return InkWell(
      onTap: onContactTap,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: ClipOval(child: AssetHandle.getImage(profilePic)),
              backgroundColor: Colors.transparent,
            ),
            title: AutoSizeTexts.autoSizeText14(
              itsMe
                  ? OtherFunctions.firstCharacterUpper(contact.receiverUser.displayName!)
                  : OtherFunctions.firstCharacterUpper(contact.senderUser.displayName!),
              fontWeight: FontWeight.bold,
            ),
            subtitle: AutoSizeTexts.autoSizeText12(
              fontWeight: hasNewMessage ? FontWeight.bold : null,
              contact.lastMessage!,
            ),
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
