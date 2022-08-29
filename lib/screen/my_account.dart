import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/fullscreen_images.dart';
import 'package:tiutiu/Widgets/my_account_card.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/screen/my_pets.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  // AdsProvider adsProvider;

  @override
  void didChangeDependencies() {
    // adsProvider = Provider.of(context);
    super.didChangeDependencies();
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 3),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: InkWell(
            onTap: tiutiuUserController.tiutiuUser.photoURL == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                          tag: 'myProfile',
                          images: [tiutiuUserController.tiutiuUser..photoURL],
                        ),
                      ),
                    );
                  },
            child: Card(
              elevation: 6.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Opacity(
                    child: FadeInImage(
                      placeholder: AssetImage('assets/fundo.jpg'),
                      image: AssetHandle(
                        tiutiuUserController.tiutiuUser.photoBACK,
                      ).build(),
                      fit: BoxFit.fill,
                      width: 1000,
                      height: 1000,
                    ),
                    opacity: 0.15,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.black38,
                                child: ClipOval(
                                  child: tiutiuUserController
                                              .tiutiuUser.photoURL !=
                                          null
                                      ? FadeInImage(
                                          placeholder: AssetImage(
                                              'assets/profileEmpty.webp'),
                                          image: NetworkImage(
                                            tiutiuUserController
                                                .tiutiuUser.photoURL!,
                                          ),
                                          fit: BoxFit.cover,
                                          width: 1000,
                                          height: 100,
                                        )
                                      : Icon(Icons.person,
                                          color: Colors.white70, size: 50),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                Text(
                                  tiutiuUserController.tiutiuUser.displayName!,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                ),
                                SizedBox(height: 10),
                                Align(
                                  child: Text(
                                    'Usuário desde ${DateFormat('dd/MM/y HH:mm').format(DateTime.parse(tiutiuUserController.tiutiuUser.createdAt!)).split(' ').first}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
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
                                child: CircleChild(
                                  avatarRadius: 25,
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'P/ adoção',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MyPetsScreen(
                                          title: 'PETs doados',
                                          kind: null,
                                          userId:
                                              authController.firebaseUser!.uid,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: CircleChild(
                                  avatarRadius: 25,
                                  child: Text(
                                    toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Doados',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        fontSize: 14, color: Colors.black),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
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
                                child: CircleChild(
                                  avatarRadius: 25,
                                  child: Text(toString(),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                              Text(
                                'Adotados',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
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
                                child: CircleChild(
                                  avatarRadius: 25,
                                  child: Text(
                                    toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Desaparecidos',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                        icone: Icons.pets,
                        text: 'PETs p/ adoção',
                        onTap: () {
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
                        icone: Tiutiu.twitter_bird,
                        text: 'Adotados',
                        onTap: () {
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
                        icone: Tiutiu.cat,
                        text: 'Doados',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MyPetsScreen(
                                  title: 'PETs doados',
                                  kind: null,
                                  userId: authController.firebaseUser!.uid,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      MyAccountCard(
                        icone: Tiutiu.dog,
                        text: 'Desaparecidos',
                        onTap: () {
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
                        icone: Icons.chat_bubble_outline,
                        text: 'Chat',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.chat_list);
                        },
                      ),
                      MyAccountCard(
                        isToExpand: false,
                        icone: Icons.info,
                        text: 'Sobre',
                        onTap: () {
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
                                  Text(
                                    'Configurações',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
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
                                  Text(
                                    'Sair',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
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
