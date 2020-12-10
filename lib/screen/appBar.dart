import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/chat/common/functions.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/routes.dart';

class TitleAppBar extends StatelessWidget {
  TitleAppBar({this.openSocial, this.navigateToAuth, this.newMessagesStream});

  final Function() openSocial;
  final Function() navigateToAuth;
  final Stream newMessagesStream;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: openSocial,
          child: Text(
            'Tiu, tiu',
            style: GoogleFonts.miltonianTattoo(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ),
        Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.SEARCH_REFINE);
              },
              icon: Icon(
                Icons.settings_input_component_sharp,
                color: Colors.white,
              ),
            ),
            Consumer<UserProvider>(
              builder: (_, userProvider, child) => Consumer<Authentication>(
                builder: (_, auth, child) => auth.firebaseUser == null
                    ? Container()
                    : Stack(
                        children: [
                          IconButton(
                            onPressed: auth.firebaseUser == null
                                ? navigateToAuth
                                : () {
                                    Navigator.pushNamed(context, Routes.CHATLIST);
                                  },
                            icon: Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: newMessagesStream,
                            builder: (context, snapshot) {
                              int newMessagesQty = CommonChatFunctions.filterOnlyMyChats(snapshot, userProvider.uid) ?? 0;
                              return Positioned(
                                right: 10,
                                child: Badge(
                                  color: Colors.red,
                                  text: newMessagesQty,
                                ),
                              );
                            },
                          )
                        ],
                      ),
              ),
            ),
            Consumer<UserProvider>(
              builder: (_, userProvider, child) => Consumer<Authentication>(
                builder: (_, auth, child) => auth.firebaseUser == null
                    ? Container()
                    : Stack(
                        children: [
                          IconButton(
                            onPressed: auth.firebaseUser == null
                                ? navigateToAuth
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.NOTIFICATIONS,
                                    );
                                  },
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: UserController().loadNotificationsCount(userProvider.uid),
                            builder: (context, snapshot) {
                              return Positioned(
                                right: 10,
                                child: Badge(
                                  color: Colors.red,
                                  text: snapshot.data?.docs?.length ?? 0,
                                ),
                              );
                            },
                          )
                        ],
                      ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
