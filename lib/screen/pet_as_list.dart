import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/filter_search.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/drawer.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/show_bottom.dart';

class PetList extends StatefulWidget {

  PetList({this.kind});
  final String kind;

  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  bool filtering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetsProvider petsProvider;

  void showFilter() {
    setState(() {
      filtering = !filtering;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    petsProvider = Provider.of(context, listen: false);
    widget.kind == 'Donate' ? petsProvider.loadDonatedPETS() : petsProvider.loadDisappearedPETS();
  }

  bool isFiltering() {
    return filtering;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.2;
    final showBottom = Provider.of<ShowBottomNavigator>(context);
    
    final kind = widget.kind;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'PETs ${kind == 'Donate' ? 'para adoção' : 'desaparecidos'}',
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            showBottom.changeShowBottom(false);
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.greenAccent,
      drawer: DrawerApp(),
      body: StreamBuilder<List<Pet>>(
        stream: kind == 'Donate' ? petsProvider.listDonatesPETS : petsProvider.listDisappearedPETS,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          List petsList = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(
              messageLoading: 'Carregando ${kind == 'Donate' ? 'doação de PETS' : 'desaparecidos'} perto de você...',
              circle: true,
            );
          } else if (snapshot.hasError) {
            return ErrorPage();
          } else {
            if (petsList.isEmpty)                 
              return Center(
                child: Text(
                  'Nenhum PET ${kind == 'Donate' ? 'para adoção' : 'encontrado'}',
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
                      itemCount: petsList.length,
                      itemBuilder: (_, index) {
                        return CardList(
                          kind: kind,
                          petInfo: petsList[index],
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
