import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/auth.dart';
import 'package:tiutiu/utils/routes.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[              
              Row(
                children: <Widget>[
                  SizedBox(width: 15),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: ClipOval(
                      child:
                          Image.asset('assets/mariana.jpg', fit: BoxFit.cover),
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
                title: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.DOADOS);
                  },
                  child: Text(
                    'Doados',
                    style: TextStyle(fontSize: 22),
                  ),
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
              InkWell(
                onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.black, size: 35),
                  title: Text(
                    'Sair',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
