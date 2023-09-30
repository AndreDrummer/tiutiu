import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/custom_badge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  ContactTile({
    required this.hasNewMessage,
    required this.userReceiver,
    required this.onContactTap,
    required this.contact,
  });

  final TiutiuUser? userReceiver;
  final Function()? onContactTap;
  final bool hasNewMessage;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    Timestamp stamp = contact.lastMessageTime ?? Timestamp.now();
    TiutiuUser loggedUser = tiutiuUserController.tiutiuUser;
    bool itsMe = loggedUser.uid == userReceiver?.uid;
    DateTime date = stamp.toDate();

    String? profilePic = itsMe ? loggedUser.avatar : userReceiver?.avatar;

    return InkWell(
      onTap: onContactTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: ClipOval(child: AssetHandle.getImage(profilePic)),
              backgroundColor: Colors.transparent,
            ),
            title: AutoSizeTexts.autoSizeText14(
              itsMe
                  ? OtherFunctions.firstCharacterUpper(loggedUser.displayName ?? '')
                  : OtherFunctions.firstCharacterUpper(userReceiver?.displayName ?? ''),
              fontWeight: FontWeight.bold,
            ),
            subtitle: AutoSizeTexts.autoSizeText12(
                fontWeight: hasNewMessage ? FontWeight.bold : null,
                textOverflow: TextOverflow.fade,
                Formatters.cuttedText(contact.lastMessage ?? '', size: 36)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomBadge(
                        color: AppColors.primary, text: AppLocalizations.of(context)!.news, show: hasNewMessage),
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
