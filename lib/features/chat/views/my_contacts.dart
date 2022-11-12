import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/chat/model/chat_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:flutter/material.dart';

class MyContacts extends StatefulWidget {
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  bool existsNewMessage(Chat chat) {
    return chat.open != null &&
        !chat.open! &&
        chat.lastSenderId != null &&
        chat.lastSenderId != tiutiuUserController.tiutiuUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: 'Meus Contatos'),
      body: StreamBuilder(
          stream: chatController.myContacts(tiutiuUserController.tiutiuUser.uid!),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: 25,
              itemBuilder: ((context, index) {
                return _ListTileMessage(
                  chat: Chat(
                    lastSenderId: tiutiuUserController.tiutiuUser.uid,
                    secondUser: tiutiuUserController.tiutiuUser,
                    firstUser: tiutiuUserController.tiutiuUser,
                    lastMessageTime: Timestamp.now(),
                    lastMessage: 'Olá, bom dia!',
                    open: false,
                    id: '',
                  ),
                  myUserId: tiutiuUserController.tiutiuUser.uid!,
                  isNewMessage: index.isOdd,
                  messageId: '',
                );
              }),
            );
          }),
    );
  }
}

class _ListTileMessage extends StatelessWidget {
  _ListTileMessage({
    required this.isNewMessage,
    required this.messageId,
    required this.myUserId,
    required this.chat,
  });

  final bool isNewMessage;
  final String messageId;
  final String myUserId;
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    // Determina se o usuário logado é o primeiro usuário do chat.
    bool itsMe = myUserId == chat.firstUser.uid;
    Timestamp stamp = chat.lastMessageTime!;
    DateTime date = stamp.toDate();

    String profilePic = itsMe ? chat.secondUser.avatar! : chat.firstUser.avatar!;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chat,
          arguments: {
            'chatId': messageId,
            'chatTitle': itsMe
                ? OtherFunctions.firstCharacterUpper(chat.secondUser.displayName!)
                : OtherFunctions.firstCharacterUpper(chat.firstUser.displayName!),
            'secondUserId': itsMe ? chat.secondUser.uid : chat.firstUser.uid,
            'receiverId': itsMe ? chat.secondUser.uid : chat.firstUser.uid,
            'receiverNotificationToken': itsMe ? chat.secondUser.notificationToken : chat.firstUser.notificationToken,
          },
        );
        chatController.markMessageAsRead(messageId);
      },
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () => OtherFunctions.navigateToAnnouncerDetail(itsMe ? chat.secondUser : chat.firstUser),
              child: CircleAvatar(
                child: ClipOval(child: AssetHandle.getImage(profilePic)),
                backgroundColor: Colors.transparent,
              ),
            ),
            title: AutoSizeText(itsMe
                ? OtherFunctions.firstCharacterUpper(chat.secondUser.displayName!)
                : OtherFunctions.firstCharacterUpper(chat.firstUser.displayName!)),
            subtitle:
                AutoSizeTexts.autoSizeText12(chat.lastMessage!, fontWeight: isNewMessage ? FontWeight.bold : null),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Badge(color: AppColors.primary, text: 'Nova', show: isNewMessage),
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
