import 'package:flutter/material.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 60,
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
            SizedBox(height: 30),
            Divider(),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/pata.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                'Doados',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/dogs.png',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                'Adotados',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/dogCat.png',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                'Divulgados',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Divider(),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: Image.asset(
                  'assets/dogCat2.png',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                'Desaparecidos',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black, size: 37),
              title: Text(
                'Configurações',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.black, size: 35),
              title: Text(
                'Sair',
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
