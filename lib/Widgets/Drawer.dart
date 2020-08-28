import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/listTile_drawer.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/utils/routes.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        height: height * 0.95,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            style: BorderStyle.solid,
          ),
          // color: Colors.greenAccent,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 35),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: auth.firebaseUser.photoUrl != null
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 40,
                              child: ClipOval(
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/profileEmpty.jpg'),
                                  image: NetworkImage(
                                    auth.firebaseUser.photoUrl,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 1000,
                                  height: 100
                                ),
                              ),
                            )
                          : Icon(Icons.account_circle),
                    ),
                    SizedBox(width: 15),
                    Text(
                      '${auth.firebaseUser.displayName}',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 25
                      )
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTileDrawer(
              tileName: 'Doados',
              imageAsset: 'assets/pata.jpg',
              callback: () {
                Navigator.pushNamed(context, Routes.DOADOS);
              },
            ),
            ListTileDrawer(
              tileName: 'Adotados',
              imageAsset: 'assets/dogs.png',
              callback: () {
                Navigator.pushNamed(context, Routes.ADOTADOS);
              },
            ),
            ListTileDrawer(
              tileName: 'Desaparecidos',
              imageAsset: 'assets/dogCat2.png',
              callback: () {
                Navigator.pushNamed(context, Routes.DESAPARECIDOS);
              },
            ),
            ListTileDrawer(
              tileName: 'Configurações',
              icon: Icons.settings,
              callback: () {
                Navigator.pushNamed(context, Routes.CONFIG);
              },
            ),
            SizedBox(height: 140),
            ListTileDrawer(
              tileName: 'Sair',
              icon: Icons.exit_to_app,
              callback: () {
                auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
