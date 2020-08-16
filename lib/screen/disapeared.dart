import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/drawer.dart';

class Disapeared extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'PETs Desaparecidos',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: DrawerApp(),
      body: Center(
        child: Text('Vai ter uma lista de PET aqui', style: Theme.of(context).textTheme.headline1,),
      ),
    );
  }
}
