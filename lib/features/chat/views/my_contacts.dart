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

                  return StreamBuilder<TiutiuUser>(
                    stream: chatController.receiverUser(contact),
                    builder: (context, snapshot) {
                      return ContactTile(
                        onContactTap: (() => chatController.startsChatWith(snapshot.data)),
                        userReceiver: snapshot.data,
                        hasNewMessage: contact.open,
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
