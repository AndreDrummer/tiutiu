import 'package:flutter/material.dart';
import '../Widgets/Mapa.dart';
import '../Widgets/CustomInput.dart';
import '../Widgets/FilterSearch.dart';
import '../Widgets/Drawer.dart';

class DogMap extends StatefulWidget {
  @override
  _DogMapState createState() => _DogMapState();
}

class _DogMapState extends State<DogMap> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool filtering = false;

  void showFilter() {
    setState(() {
      filtering = !filtering;
    });
  }

  bool isFiltering() {
    return filtering;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: DrawerApp(),
      ),
      body: Stack(
        children: <Widget>[
          Mapa(),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 50, 0.0, 0.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: IconButton(
              onPressed: () {
                _globalKey.currentState.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
          CustomInput(showFilter: showFilter),
          FilterSearch(isFiltering: isFiltering, showFilter: showFilter)
        ],
      ),
    );
  }
}
