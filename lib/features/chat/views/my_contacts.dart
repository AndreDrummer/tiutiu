import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/widgets/contact_tile.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/system/controllers.dart';
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
  void initState() {
    super.initState();
  }

  TiutiuUser pickTheRightReceiverUser(Contact contact) {
    final myUser = tiutiuUserController.tiutiuUser;
    if (contact.senderUser.uid == myUser.uid) return contact.receiverUser;
    if (contact.receiverUser.uid == myUser.uid) return contact.senderUser;
    return contact.receiverUser;
  }

  bool existsNewMessage(Contact contact) {
    return contact.open != null &&
        contact.lastSenderId != tiutiuUserController.tiutiuUser.uid &&
        contact.lastSenderId != null &&
        !contact.open!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: ChatStrings.myContacts),
      body: StreamBuilder<List<Contact>>(
        stream: chatController.contacts(),
        builder: (context, snapshot) {
          return AsyncHandler<List<Contact>>(
            emptyMessage: ChatStrings.noContact,
            snapshot: snapshot,
            buildWidget: (contacts) {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: ((context, index) {
                  final contact = contacts[index];
                  return ContactTile(
                    onContactTap: (() => chatController.startsChatWith(pickTheRightReceiverUser(contact))),
                    myUserId: tiutiuUserController.tiutiuUser.uid!,
                    hasNewMessage: index.isOdd,
                    contact: contact,
                    messageId: '',
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
