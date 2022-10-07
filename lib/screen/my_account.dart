import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/my_account_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/screen/my_pets.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _formScaffold = GlobalKey<ScaffoldState>();

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _formScaffold,
      backgroundColor: Color(0XFFF9F9F9),
      // appBar: appBar(userProvider, auth),
      body: Stack(
        children: [
          Background(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      MyAccountCard(
                        icon: Icons.pets,
                        text: 'PETs p/ adoção',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPetsScreen(
                                  title: 'PETs p/ adoção',
                                  kind: FirebaseEnvPath.donate,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      MyAccountCard(
                        icon: Tiutiu.twitter_bird,
                        text: 'Adotados',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPetsScreen(
                                  title: 'PETs Adotados',
                                  kind: FirebaseEnvPath.adopted,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyAccountCard(
                        icon: Tiutiu.cat,
                        text: 'Doados',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPetsScreen(
                                  userId: tiutiuUserController.tiutiuUser.uid,
                                  title: 'PETs doados',
                                  kind: null,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      MyAccountCard(
                        icon: Tiutiu.dog,
                        text: 'Desaparecidos',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPetsScreen(
                                  title: 'PETs desaparecidos',
                                  kind: FirebaseEnvPath.disappeared,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      MyAccountCard(
                        isToExpand: false,
                        icon: Icons.chat_bubble_outline,
                        text: 'Chat',
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.chatList);
                        },
                      ),
                      MyAccountCard(
                        isToExpand: false,
                        icon: Icons.info,
                        text: 'Sobre',
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.about);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, Routes.settings);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.settings,
                                      color: Colors.grey, size: 22),
                                  SizedBox(width: 20),
                                  AutoSizeText(
                                    'Configurações',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                          fontSize: 18,
                                          color: Colors.blueGrey[400],
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 1.0,
                          ),
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => PopUpMessage(
                                  confirmAction: () {
                                    authController.signOut();

                                    Navigator.pop(context);
                                  },
                                  confirmText: 'Sim',
                                  denyAction: () {
                                    Navigator.pop(context);
                                  },
                                  denyText: 'Não',
                                  warning: true,
                                  message: 'Tem certeza que deseja deslogar?',
                                  title: 'Deslogar',
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.exit_to_app,
                                      color: Colors.grey, size: 22),
                                  SizedBox(width: 20),
                                  AutoSizeText(
                                    'Sair',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                          fontSize: 18,
                                          color: Colors.blueGrey[400],
                                        ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // adsProvider.getCanShowAds
                  // // ? adsProvider.bannerAdMob(adId: adsProvider.bottomAdId)
                  // : Container(),
                  SizedBox(height: height < 500 ? 220 : 0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
