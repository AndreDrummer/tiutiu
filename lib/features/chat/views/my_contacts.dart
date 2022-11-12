import 'package:tiutiu/features/chat/widgets/contact_tile.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        stream: chatController.contacts(tiutiuUserController.tiutiuUser.uid!),
        builder: (context, snapshot) {
          return AsyncHandler<List<Contact>>(
            emptyMessage: ChatStrings.noContact,
            snapshot: snapshot,
            buildWidget: (contacts) {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: ((context, index) {
                  return ContactTile(
                    myUserId: tiutiuUserController.tiutiuUser.uid!,
                    hasNewMessage: index.isOdd,
                    contact: Contact(
                      lastSenderId: tiutiuUserController.tiutiuUser.uid,
                      secondUser: tiutiuUserController.tiutiuUser,
                      firstUser: tiutiuUserController.tiutiuUser,
                      lastMessageTime: Timestamp.now(),
                      lastMessage: 'Olá, bom dia!',
                      open: false,
                      id: '',
                    ),
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
