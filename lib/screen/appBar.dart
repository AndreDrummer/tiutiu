import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/chat/common/functions.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

class TitleAppBar extends StatelessWidget {
  TitleAppBar({
    this.newMessagesStream,
    this.navigateToAuth,
    this.openSocial,
  });

  final Stream<QuerySnapshot>? newMessagesStream;
  final Function()? navigateToAuth;
  final Function()? openSocial;

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
                Navigator.pushNamed(context, Routes.search);
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
                                    Navigator.pushNamed(
                                        context, Routes.chat_list);
                                  },
                            icon: Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: newMessagesStream,
                            builder: (context, snapshot) {
                              int newMessagesQty =
                                  CommonChatFunctions.filterOnlyMyChats(
                                snapshot,
                                userProvider.uid!,
                              );

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
                                      Routes.notifications,
                                    );
                                  },
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: UserController()
                                .loadNotificationsCount(userProvider.uid!),
                            builder: (context, snapshot) {
                              return Positioned(
                                right: 10,
                                child: Badge(
                                  color: Colors.red,
                                  text: snapshot.data?.docs.length ?? 0,
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
