import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/utils/math_functions.dart';
import 'package:tiutiu/utils/routes.dart';

class DonateDisappearedList extends StatefulWidget {
  DonateDisappearedList({this.stream,});  
  final Stream<QuerySnapshot> Function() stream;

  @override
  _DonateDisappearedListState createState() => _DonateDisappearedListState();
}

class _DonateDisappearedListState extends State<DonateDisappearedList> {
  bool filtering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetsProvider petsProvider;
  RefineSearchProvider refineSearchProvider;
  Location location;
  AdsProvider adsProvider;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  } 

  @override
  void didChangeDependencies() {
    adsProvider = Provider.of(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);
    petsProvider = Provider.of<PetsProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isFiltering() {
    return filtering;
  }

  List<Pet> filterResultsByDistancie(List<Pet> petsListResult) {
    List<Pet> newPetList = [];
    location = Provider.of<Location>(context);
    

    if (petsListResult != null) {
      for (int i = 0; i < petsListResult.length; i++) {
        String distance = MathFunctions.distanceMatrix(
          latX: location.getLocation?.latitude ?? 0.0,
          longX: location.getLocation?.longitude ?? 0.0,
          latY: petsListResult[i]?.latitude ?? 0.0,
          longY: petsListResult[i]?.longitude ?? 0.0,
        );

        String distancieSelected = refineSearchProvider.getDistancieSelected
            ?.split('Km')
            ?.first
            ?.split('Até')
            ?.last;
        double distanceRefineSelected = double.tryParse(distancieSelected) ?? 1000000;

        if (double.parse(distance) < distanceRefineSelected * 1000) {
          newPetList.add(petsListResult[i]);
        }
      }
    }

    return newPetList;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.55;        

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey[50],
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.stream(),            
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingPage(
                messageLoading: 'Carregando PETS perto de você...',                      
                circle: true,
                textColor: Colors.black26
              ),
            );
          }          

          if (snapshot.hasError) {
            return ErrorPage();
          }

          List<Pet> pets = [];
          List<QueryDocumentSnapshot> docs = snapshot.data.docs;          

          for (int i = 0; i < docs.length; i++) {
            pets.add(Pet.fromSnapshot(docs[i]));
          }

          List petsList = filterResultsByDistancie(pets);

          if (snapshot.data == null || petsList.length == 0) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.SEARCH_REFINE);
              },
              child: Column(
                mainAxisAlignment: 
                // adsProvider.getCanShowAds ? MainAxisAlignment.start
                //     : 
                    MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(height: 10),
                  // adsProvider.getCanShowAds
                  //     ? adsProvider.bannerAdMob(
                  //         medium_banner: true, adId: adsProvider.topAdId)
                  //     : Container(),
                  // SizedBox(height: 40),
                  Text(
                    'Nenhum PET encontrado',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Verifique seus filtros de busca.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.blueAccent,
                        ),
                  ),
                ],
              ),
            );
          }

          return Container(
            height: marginTop + 30,
            child: Column(                    
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                adsProvider.getCanShowAds
                    ? Column(
                      children: [
                        _HomeSearch(),
                        Container(                               
                          alignment: Alignment(-0.9, 1),
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('${petsList.length} PETs encontrados', style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black26
                          )),
                        ),
                      ],
                    )//adsProvider.bannerAdMob(adId: adsProvider.homeAdId)
                    : Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Você está utilizando Tiu, tiu em fase de teste. Os dados podem ser fictícios.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                Expanded(
                  child: ListView.builder(
                    itemCount: petsList.length + 1,
                    itemBuilder: (_, index) {
                      if (index == petsList.length && adsProvider.getCanShowAds) {
                        // return SizedBox(height: 50);
                        return Container();
                      }
                      return CardList(
                        kind: petsList[index].kind,
                        petInfo: petsList[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeSearch extends StatefulWidget {
  @override
  __HomeSearchState createState() => __HomeSearchState();
}

class __HomeSearchState extends State<_HomeSearch> {
  PetsProvider petsProvider;  
  RefineSearchProvider refineSearchProvider;

    @override
  void didChangeDependencies() {    
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);
    petsProvider = Provider.of<PetsProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<String>(
      stream: refineSearchProvider.searchHomeTypeInitialValue,
      builder: (context, snapshotSearchHomeInitialValue) {
        return StreamBuilder<List<String>>(
          stream: refineSearchProvider.searchHomeType,
          builder: (context, snapshotsnapshotSearchHomeValues) {
            return StreamBuilder<String>(
              stream: refineSearchProvider.searchHomePetTypeInitialValue,
              builder: (context, snapshotHomePetTypeInitialValue) {
                return StreamBuilder<List<String>>(
                  stream: refineSearchProvider.searchHomePetType,
                  builder: (context, snapshotHomePetTypeValues) {
                    return StreamBuilder<bool>(
                      stream: refineSearchProvider.searchPetByTypeOnHome,
                      builder: (context, snapshotSearchPetByTypeOnHome) {
                        return CustomInput(
                          searchInitialValue: snapshotSearchHomeInitialValue?.data ?? '',
                          searchValues: snapshotsnapshotSearchHomeValues?.data ?? [''],
                          searchPetTypeInitialValue: snapshotHomePetTypeInitialValue?.data ?? '',
                          searchPetTypeValues: snapshotHomePetTypeValues?.data ?? [''],
                          isType: snapshotSearchPetByTypeOnHome?.data ?? false,
                          onDropdownTypeChange: (String text) {
                            if(text == 'Nome do PET') {
                              refineSearchProvider.changeSearchPetByTypeOnHome(false);                  
                              refineSearchProvider.changeSearchHomeTypeInitialValue(text);                   
                            } else if(text == 'Tipo'){
                              refineSearchProvider.changeSearchPetByTypeOnHome(true);                                      
                              refineSearchProvider.changeSearchHomeTypeInitialValue(text);                   
                            } else {
                              refineSearchProvider.changeSearchPetByTypeOnHome(false);
                              refineSearchProvider.changeSearchHomeTypeInitialValue(text);                              
                            }
                          },
                          onDropdownPetTypeChange: (String text) {
                            refineSearchProvider.changeSearchHomePetTypeInitialValue(text);
                            petsProvider.changePetType(text);
                            petsProvider.changeIsFiltering(true);                            
                            print('Search');
                          },
                          onSubmit: (String text){
                            petsProvider.changeIsFiltering(true);
                            if(refineSearchProvider.getSearchHomeTypeInitialValue == 'Nome do PET') {
                              petsProvider.changepetName(text);
                            } else {
                              petsProvider.changeBreedSelected(text);
                            }
                          }
                       );
                     }
                   );
                 }
               );
             }
           );
         }
       );
     }
   );
  }
}