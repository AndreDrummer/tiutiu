import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/chat/widgets/contact_tile.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/chat/model/contact.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
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

    return AuthenticatedArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(text: AppLocalizations.of(context).myMessages),
        body: StreamBuilder<List<Contact>>(
          stream: chatController.contacts(),
          builder: (context, contactsSnapshot) {
            return AsyncHandler<List<Contact>>(
              emptyWidget: VerifyAccountWarningInterstitial(
                child: AutoSizeTexts.autoSizeText16(AppLocalizations.of(context).noContact),
              ),
              snapshot: contactsSnapshot,
              buildWidget: (contacts) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: ((context, index) {
                          final contact = contacts[index];

                          return StreamBuilder<TiutiuUser>(
                            stream: chatController.receiverUser(contact),
                            builder: (context, userSnapshot) {
                              return ContactTile(
                                onContactTap: (() {
                                  chatController.markMessageAsRead(contact);
                                  if (userSnapshot.data != null && !userSnapshot.data!.userDeleted) {
                                    chatController.setPostTalkingAbout(contact.postTalkingAbout!);
                                    chatController.startsChatWith(
                                      user: userSnapshot.data,
                                      myUserId: myUserId!,
                                    );
                                  }
                                }),
                                hasNewMessage: !contact.open && contact.userSenderId != myUserId,
                                userReceiver: userSnapshot.data,
                                contact: contact,
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    Spacer(),
                    AdBanner(
                      adId: systemController.getAdMobBlockID(
                        blockName: AdMobBlockName.homeFooterAdBlockId,
                        type: AdMobType.banner,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
