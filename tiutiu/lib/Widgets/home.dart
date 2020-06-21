import "package:flutter/material.dart";
import './Mapa.dart';
import './CustomInput.dart';
import './FilterSearch.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool filtering = false;

  @override
  void initState() {
    super.initState();
  }

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
        child: Text("Hello Drawer"),
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
