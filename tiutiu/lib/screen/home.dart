import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/providers/auth.dart';

import '../Widgets/floatingButtonOption.dart';
import '../utils/routes.dart';
import './disapeared.dart';
import './petAsList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> leaveApplication() async {
    var answer = false;
    return showDialog(
      context: context,
      builder: (_) => Consumer<Auth>(
        builder: (context, auth, child) {
          return PopUpMessage(
            title: 'Logout',
            message: 'Deseja realmente sair?',
            action: () {
              setState(() {
                answer = true;
              });
              Navigator.pop(context);
              auth.logout();
            },
          );
        },
      ),
    ).then((value) {
      print('Answer: $answer');
      return answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _screens = <Widget>[/*Mapa(),*/ PetList(), Disapeared()];

    return WillPopScope(
      onWillPop: leaveApplication,
      child: Scaffold(
        body: Center(child: _screens.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            /*BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Ver no Mapa'),
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              title: Text('P/ Adoção'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_late),
              title: Text('Desaparecidos'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
        floatingActionButton: SpeedDial(
          marginRight: 18,
          marginBottom: 20,
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 22.0),
          visible: MediaQuery.of(context).orientation == Orientation.portrait,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayOpacity: 0.5,
          onOpen: () {
            print('OPENING DIAL');
          },
          onClose: () {
            print('DIAL CLOSED');
          },
          tooltip: 'Adicionar PET',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: FloatingButtonOption(image: 'assets/dogCat2.png'),
              label: 'Adicionar Desaparecido',
              labelStyle: TextStyle(fontSize: 14.0),
              onTap: () {
                Navigator.pushNamed(context, Routes.CHOOSE_LOCATION, arguments: {'kind': 'Disappeared'});
              },
            ),
            SpeedDialChild(
              child: FloatingButtonOption(image: 'assets/pata2.jpg'),
              label: 'Doar PET',
              backgroundColor: Color(0XFFFFF176),
              labelStyle: TextStyle(fontSize: 14.0),
              onTap: () {
                Navigator.pushNamed(context, Routes.CHOOSE_LOCATION, arguments: {'kind': 'Donate'});
              },
            ),
          ],
        ),
      ),
    );
  }
}
