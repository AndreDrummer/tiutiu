import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/badge.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/donate_disappeared_list.dart';
import 'package:tiutiu/utils/routes.dart';

class PetsList extends StatefulWidget {
  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> with SingleTickerProviderStateMixin {  
  TabController _controller;
  int initialIndex = 0;
  PetsProvider petsProvider;
  RefineSearchProvider refineSearchProvider;  

  @override
  void didChangeDependencies() {    
    petsProvider = Provider.of<PetsProvider>(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);        
    petsProvider.loadDisappearedPETS(state: refineSearchProvider.getStateOfResultSearch);
    petsProvider.loadDonatePETS(state: refineSearchProvider.getStateOfResultSearch);
    super.didChangeDependencies();
  }

  @override
  void initState() {
     _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: initialIndex,
    );

    _controller.addListener(onTabChange);

    super.initState();
  }

  void onTabChange(){
    initialIndex = _controller.index;   

    if(_controller.index == 1) {
      petsProvider.changePetKind('Disappeared');
      if(refineSearchProvider.getSearchPetByTypeOnHome && refineSearchProvider.getIsHomeFilteringByDisappeared) {
        refineSearchProvider.changeSearchHomePetTypeInitialValue(refineSearchProvider.getHomePetTypeFilterByDisappeared);        
        petsProvider.changePetType(refineSearchProvider.getHomePetTypeFilterByDisappeared);        
        petsProvider.changeIsFiltering(true);        
      } else {
        refineSearchProvider.changeSearchHomePetTypeInitialValue(refineSearchProvider.getSearchHomePetType.first);
        petsProvider.changeIsFiltering(false);
      }
      
      petsProvider.loadDisappearedPETS(state: refineSearchProvider.getStateOfResultSearch);

    } else {
      petsProvider.changePetKind('Donate');
      if(refineSearchProvider.getSearchPetByTypeOnHome && refineSearchProvider.getIsHomeFilteringByDonate) {
        refineSearchProvider.changeSearchHomePetTypeInitialValue(refineSearchProvider.getHomePetTypeFilterByDonate);        
        petsProvider.changePetType(refineSearchProvider.getHomePetTypeFilterByDonate);        
        petsProvider.changeIsFiltering(true);        
      } else {
        refineSearchProvider.changeSearchHomePetTypeInitialValue(refineSearchProvider.getSearchHomePetType.first);
        petsProvider.changeIsFiltering(false);
      }
      
      petsProvider.loadDonatePETS(state: refineSearchProvider.getStateOfResultSearch);
    }   
  }

  void changeInitialIndex(int index) {
    setState((){
      initialIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final indexTab = ModalRoute.of(context).settings.arguments;    
    void navigateToAuth() {
      Navigator.pushNamed(context, Routes.AUTH, arguments: true);
    }

    if(indexTab != initialIndex) changeInitialIndex(indexTab);

    return DefaultTabController(      
      length: 2,
      initialIndex: indexTab ?? 0,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Row(            
            children: [                            
              Text(
                'Tiu, tiu',
                style: GoogleFonts.miltonianTattoo(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              Spacer(),
              Consumer<UserProvider>(
                builder: (_, userProvider, child) => Consumer<Authentication>(
                  builder: (_, auth, child) => auth.firebaseUser == null
                      ? Container()
                      : Stack(
                          children: [
                            IconButton(
                              onPressed: auth.firebaseUser == null
                                  ? navigateToAuth
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.NOTIFICATIONS,
                                      );
                                    },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: UserController().loadNotificationsCount(userProvider.uid),
                              builder: (context, snapshot) {
                                return Positioned(
                                  right: 10,
                                  child: Badge(
                                    color: Colors.red,
                                    text: snapshot.data?.docs?.length ?? 0,
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                ),
              )
            ],
          ),        
          bottom: TabBar(            
            controller: _controller,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Tiutiu.dog), text: 'ADOTAR'),
              Tab(icon: Icon(Tiutiu.exclamation), text: 'DESAPARECIDOS'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,   
          children: [
            DonateDisappearedList(stream: petsProvider.petsDonate),
            DonateDisappearedList(stream: petsProvider.petsDisappeared),
          ],
        ),
      ),
    );
  }
}
