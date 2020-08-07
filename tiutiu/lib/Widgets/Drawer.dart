import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/listTile_drawer.dart';
import 'package:tiutiu/providers/auth.dart';
import 'package:tiutiu/utils/routes.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 35),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: ClipOval(
                    child: Image.asset('assets/mariana.jpg', fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Mariana',
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            SizedBox(height: 15),
            Divider(),
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
            ListTileDrawer(
              tileName: 'Sair',
              icon: Icons.exit_to_app,
              callback: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
