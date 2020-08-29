import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/drawer.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/filter_search.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/providers/pets_provider.dart';

class Disapeared extends StatefulWidget {
  @override
  _DisapearedState createState() => _DisapearedState();
}

class _DisapearedState extends State<Disapeared> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetsProvider petsProvider;
  bool filtering = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    petsProvider = Provider.of(context, listen: false);
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
    final marginTop = MediaQuery.of(context).size.height / 1.2;
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'PETs Desaparecidos',
          style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 18,
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
      body: FutureBuilder(
        future: petsProvider.loadDisappearedPETS(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(
              messageLoading: 'PETS desaparecidos perto de você...',
              circle: true,
            );
          } else if (snapshot.hasError) {
            
            return ErrorPage();
          } else {            
            if (petsProvider.listDisappearedPETS.length == 0)
              return Center(
                child: Text(
                  'Nenhum PET encontrado',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            return Stack(
              children: <Widget>[
                Container(
                  height: marginTop,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90.0),
                    child: ListView.builder(
                      itemCount: petsProvider.listDisappearedPETS.length,
                      itemBuilder: (_, index) {                        
                        return CardList(
                          donate: false,
                          petInfo: petsProvider.listDisappearedPETS[index],
                        );
                      },
                    ),
                  ),
                ),
                CustomInput(),
                Positioned(
                  right: 20,
                  top: 80,
                  child: Align(
                    alignment: Alignment(0.7, -0.7),
                    child: Container(
                      height: 190,
                      width: 235,
                      child: FilterSearch(
                        isFiltering: isFiltering,
                        showFilter: showFilter,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
