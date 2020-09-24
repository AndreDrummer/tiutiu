import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/filter_search.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/Drawer.dart';

class PetList extends StatefulWidget {
  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
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
    final marginTop = MediaQuery.of(context).size.height / 1.2;
    return Scaffold(
      appBar: AppBar(
        title: Text('PETs na redondeza'),
        centerTitle: true,
      ),
      backgroundColor: Colors.green,
      drawer: DrawerApp(),
      body: Stack(
        children: <Widget>[
          Container(
            height: marginTop,
            child: Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      // color: Colors.white70,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: CircleAvatar(
                                  radius: 50,
                                  child: Image.asset(
                                    'assets/pelo.jfif',
                                    height: 1000,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Doguinho, 6 meses',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                                Text('ChowChow'),
                                SizedBox(height: 20),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.525,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'joaofelix está doando',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.525,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'detalhes',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),                                                                
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.59,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                                        child: Text('Está a 2.6 Km de você', style: TextStyle(fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                ),                                                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          CustomInput(showFilter: showFilter),          
          Positioned(
            right: 20,
            top: 80,
            child: Align(
              alignment: Alignment(0.7, -0.7),            
              child: Container(
                height: 190,
                width: 235,
                child: FilterSearch(
                    isFiltering: isFiltering, showFilter: showFilter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
