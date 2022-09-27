import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
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
          child: AutoSizeText(
            'Tiu, tiu',
            style: GoogleFonts.miltonianTattoo(
              textStyle: TextStyle(
                color: AppColors.white,
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
                color: AppColors.white,
              ),
            ),
            Container(
              child: authController.userExists
                  ? Container()
                  : Stack(
                      children: [
                        IconButton(
                          onPressed: authController.userExists
                              ? navigateToAuth
                              : () {
                                  Navigator.pushNamed(context, Routes.chatList);
                                },
                          icon: Icon(
                            Icons.chat,
                            color: AppColors.white,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: newMessagesStream,
                          builder: (context, snapshot) {
                            int newMessagesQty =
                                CommonChatFunctions.filterOnlyMyChats(snapshot,
                                    'tiutiuUserController.tiutiuUser.uid!');

                            return Positioned(
                              right: 10,
                              child: Badge(
                                color: AppColors.danger,
                                text: newMessagesQty,
                              ),
                            );
                          },
                        )
                      ],
                    ),
            ),
            Container(
              child: authController.userExists
                  ? Container()
                  : Stack(
                      children: [
                        IconButton(
                          onPressed: authController.userExists
                              ? navigateToAuth
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.notifications,
                                  );
                                },
                          icon: Icon(
                            Icons.notifications,
                            color: AppColors.white,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: tiutiuUserController.loadNotifications(),
                          builder: (context, snapshot) {
                            return Positioned(
                              right: 10,
                              child: Badge(
                                color: AppColors.danger,
                                text: snapshot.data?.docs.length ?? 0,
                              ),
                            );
                          },
                        )
                      ],
                    ),
            ),
          ],
        )
      ],
    );
  }
}
