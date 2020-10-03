import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/circle_child.dart';
import 'package:tiutiu/Widgets/my_account_card.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/routes.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadMyPets();
    super.didChangeDependencies();
  }

  Widget appBar(UserProvider userProvider) {
    return PreferredSize(
      preferredSize: Size.fromHeight(200.0),
      child: Stack(
        children: [
          Opacity(
            child: FadeInImage(
              placeholder: AssetImage('assets/fundo.jpg'),
              image: userProvider.photoBACK != null
                  ? NetworkImage(
                      userProvider.photoBACK,
                    )
                  : AssetImage(
                      'assets/fundo.jpg',
                    ),
              fit: BoxFit.fill,
              width: 1000,
              height: 1000,
            ),
            opacity: 0.25,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent, //Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleChild(
                    avatarRadius: 60,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/profileEmpty.png'),
                      image: NetworkImage(
                        userProvider.photoURL,
                      ),
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 1000,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          userProvider.displayName,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Usuário desde 16 de Setembro de 2020',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleChild(
                                  avatarRadius: 15,
                                  child: Text(
                                    userProvider.getTotalDonated.toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Doados',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                CircleChild(
                                  avatarRadius: 15,
                                  child: Text('0',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                                Text(
                                  'Adotados',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                CircleChild(
                                  avatarRadius: 15,
                                  child: Text(
                                      userProvider.getTotalDisappeared
                                          .toString(),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                                Text(
                                  'Desaparecidos',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    GlobalKey<ScaffoldState> _formScaffold = GlobalKey<ScaffoldState>();

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _formScaffold,
      backgroundColor: Color(0XFFF9F9F9),
      appBar: appBar(userProvider),
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
                        icone: Tiutiu.dog,
                        text: 'Meus PETS',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.MEUS_PETS);
                        },
                      ),
                      MyAccountCard(
                        icone: Icons.favorite_border,
                        text: 'Favoritos',
                        onTap: () {
                          Navigator.pushNamed(context, Routes.FAVORITES);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          MyAccountCard(
                            icone: Icons.chat_bubble_outline,
                            text: 'Chat',
                            onTap: () {
                              // Navigator.pushNamed(context, Routes.MEUS_PETS);
                            },
                          ),
                          Positioned(
                            top: 3.5,
                            left: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              alignment: Alignment.centerRight,
                              height: 98.5,
                              width: 184,
                              child: Text(
                                'Em breve',
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.5, 2.5),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                    Shadow(
                                      offset: Offset(2.5, 2.5),
                                      blurRadius: 8.0,
                                      color: Colors.white70,
                                    ),
                                  ],
                                  color: Colors.purple,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pushNamed(context, Routes.SETTINGS);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.settings,
                                    color: Colors.grey, size: 30),
                                SizedBox(width: 20),
                                Text(
                                  'Configurações',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        fontSize: 22,
                                        color: Colors.blueGrey[400],
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).primaryColor,
                          height: 1.0,
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => PopUpMessage(
                                confirmAction: () {
                                  auth.signOut();
                                  Navigator.pop(context);
                                },
                                confirmText: 'Sim',
                                denyAction: () {
                                  Navigator.pop(context);
                                },
                                denyText: 'Não',
                                warning: true,
                                message: 'Tem certeza que deseja deslogar?',
                                title: 'Signout',
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.exit_to_app,
                                    color: Colors.grey, size: 30),
                                SizedBox(width: 20),
                                Text(
                                  'Sair',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        fontSize: 22,
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
                  Opacity(
                    opacity: 0.7,
                    child: Image.asset('assets/trofeu.jpg'),
                  ),
                  SizedBox(height: height < 500 ? 200 : 50)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
