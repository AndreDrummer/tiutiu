import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/utils/routes.dart';

class PetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final indexTab = ModalRoute.of(context).settings.arguments;

    void navigateToAuth() {
      Navigator.pushNamed(context, Routes.AUTH, arguments: true);
    }

    return DefaultTabController(
      length: 2,
      initialIndex: indexTab ?? 0,
      child: Scaffold(
          appBar: AppBar(
            leading: null,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiu, tiu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (_, userProvider, child) => Consumer<Authentication>(
                    builder: (_, auth, child) => auth.firebaseUser == null ? Container() : Stack(
                      children: [
                        IconButton(
                          onPressed: auth.firebaseUser == null
                              ? navigateToAuth
                              : () {
                                  Navigator.pushNamed(
                                      context, Routes.NOTIFICATIONS);
                                },
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          child: Badge(
                            color: Colors.red,
                            text: userProvider
                                .getNotificationsAboutAdoptions?.length ?? 0                                
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Tiutiu.dog), text: 'ADOTAR'),
                Tab(icon: Icon(Tiutiu.exclamation), text: 'DESAPARECIDOS'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DonateDisappearedList(kind: 'Donate'),
              DonateDisappearedList(kind: 'Disappeared'),
            ],
          )),
    );
  }
}
