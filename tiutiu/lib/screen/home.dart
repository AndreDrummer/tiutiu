import "package:flutter/material.dart";

import './dogAsList.dart';
import './dogAsMap.dart';

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

  @override
  Widget build(BuildContext context) {

    List<Widget> _screens = <Widget>[
      DogMap(),
      DogList()
    ];

    return Scaffold(      
      body: Center(child: _screens.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.map), title: Text('Ver no Mapa')),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), title: Text('Ver na lista')),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
