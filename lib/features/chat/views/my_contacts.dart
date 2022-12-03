import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/widgets/contact_tile.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class MyContacts extends StatefulWidget {
  @override
  _MyContactsState createState() => _MyContactsState();
}

class _MyContactsState extends State<MyContacts> {
  late Contact contact;

  @override
  Widget build(BuildContext context) {
    final myUserId = tiutiuUserController.tiutiuUser.uid;

    return Scaffold(
      appBar: DefaultBasicAppBar(text: ChatStrings.myContacts),
      body: StreamBuilder<List<Contact>>(
        stream: chatController.contacts(),
        builder: (context, snapshot) {
          return AsyncHandler<List<Contact>>(
            emptyWidget: VerifyAccountWarningInterstitial(
              child: AutoSizeTexts.autoSizeText16(ChatStrings.noContact),
            ),
            snapshot: snapshot,
            buildWidget: (contacts) {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: ((context, index) {
                  final contact = contacts[index];

                  return StreamBuilder<TiutiuUser>(
                    stream: chatController.receiverUser(contact),
                    builder: (context, userSnapshot) {
                      return ContactTile(
                        onContactTap: (() {
                          chatController.markMessageAsRead(contact);
                          chatController.startsChatWith(userSnapshot.data);
                        }),
                        hasNewMessage: !contact.open && contact.userSenderId != myUserId,
                        userReceiver: userSnapshot.data,
                        contact: contact,
                      );
                    },
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }
}
