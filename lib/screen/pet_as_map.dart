import 'package:flutter/material.dart';
import '../Widgets/mapa.dart';
import '../Widgets/input_search.dart';
import '../Widgets/filter_search.dart';
import '../Widgets/drawer.dart';

class PetMap extends StatefulWidget {
  @override
  _PetMapState createState() => _PetMapState();
}

class _PetMapState extends State<PetMap> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
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
            margin: const EdgeInsets.fromLTRB(20, 50, 0.0, 0.0),
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
