import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';

class DonateDisappearedList extends StatefulWidget {
  DonateDisappearedList({
    this.stream,
  });
  final Stream<List<Pet>> stream;

  @override
  _DonateDisappearedListState createState() => _DonateDisappearedListState();
}

class _DonateDisappearedListState extends State<DonateDisappearedList> {
  bool filtering = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PetsProvider petsProvider;
  UserProvider userProvider;
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
    userProvider = Provider.of<UserProvider>(context);
    petsProvider = Provider.of<PetsProvider>(context);
    location = Provider.of<Location>(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isFiltering() {
    return filtering;
  }

  List<Pet> filterResultsByAgeOver10(List<Pet> petsListResult) {
    List<Pet> newPetList = [];

    if (petsListResult != null) {
      for (int i = 0; i < petsListResult.length; i++) {
        if (petsListResult[i].ano >= 10) {
          newPetList.add(petsListResult[i]);
        }
      }
      return newPetList;
    } else {
      return [];
    }
  }

  int orderByPostDate(Pet a, Pet b) {
    return DateTime.parse(b.createdAt).millisecondsSinceEpoch -
        DateTime.parse(a.createdAt).millisecondsSinceEpoch;
  }

  int orderByName(Pet a, Pet b) {
    List<int> aname = a.name.codeUnits;
    List<int> bname = b.name.codeUnits;

    int i = 0;
    while (i < bname.length) {
      if (bname[i] < aname[i]) {
        return 1;
      } else if (bname[i] == aname[i]) {
        i++;
        if (i >= aname.length) {
          return 1;
        }
      } else {
        return -1;
      }
    }
    return 1;
  }

  int orderByAge(Pet a, Pet b) {
    if (a.ano == b.ano) return a.meses - b.meses;
    return a.ano - b.ano;
  }

  bool ifUserIsNewer() {
    return userProvider.createdAt == null
        ? true
        : DateTime.now()
                .difference(DateTime.parse(userProvider.createdAt))
                .inDays <
            1;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.55;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HomeSearch(),
            StreamBuilder<List<Pet>>(
              stream: widget.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.only(top: height / 4.5),
                    child: LoadingPage(
                      messageLoading: 'Carregando PETS perto de você...',
                      circle: true,
                      textColor: Colors.black26,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return ErrorPage();
                }

                return FutureBuilder<Object>(
                  future: OtherFunctions.filterResultsByState(context, snapshot.data, 'Goiás'),
                  builder: (context, snapshot) {
                    List<Pet> petsList = OtherFunctions.filterResultsByDistancie(context,snapshot.data,refineSearchProvider.getDistancieSelected);

                    if (!ifUserIsNewer()) {
                      petsList.removeWhere(
                          (element) => element.ownerId == Constantes.ADMIN_ID);
                    }

                    if (petsProvider.getAgeSelected != null &&
                        petsProvider.getAgeSelected.isNotEmpty &&
                        petsProvider.getAgeSelected == 'Mais de 10 anos') {
                      petsList = filterResultsByAgeOver10(snapshot.data);
                    }

                    switch (petsProvider.getOrderType) {
                      case 'Nome':
                        petsList.sort(orderByName);
                        break;
                      case 'Idade':
                        petsList.sort(orderByAge);
                        break;
                      default:
                        petsList.sort(orderByPostDate);
                    }

                    if (snapshot.data == null || petsList.length == 0) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.SEARCH_REFINE);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: height / 3.5),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Verifique seus filtros de busca.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      color: Colors.blueAccent,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Container(
                      height: marginTop + 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment(-0.9, 1),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${petsList.length} encontrados',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black26,
                                        )),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text('ordenar por:  ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black26)),
                                        StreamBuilder<Object>(
                                            stream: petsProvider.orderType,
                                            builder: (context, snapshot) {
                                              return CustomDropdownButtonSearch(
                                                colorText: Colors.black54,
                                                fontSize: 13,
                                                initialValue:
                                                    petsProvider.getOrderType,
                                                isExpanded: false,
                                                withPipe: false,
                                                itemList: petsProvider
                                                    .getOrderTypeList,
                                                label: '',
                                                onChange: (String text) {
                                                  petsProvider
                                                      .changeOrderType(text);
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: ListView.builder(
                                itemCount: petsList.length + 1,
                                itemBuilder: (_, index) {
                                  if (index == petsList.length &&
                                      adsProvider.getCanShowAds) {
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
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
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
    return StreamBuilder<String>(
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
                                stream:
                                    refineSearchProvider.searchPetByTypeOnHome,
                                builder:
                                    (context, snapshotSearchPetByTypeOnHome) {
                                  return CustomInput(
                                      searchInitialValue:
                                          snapshotSearchHomeInitialValue
                                                  ?.data ??
                                              '',
                                      searchValues:
                                          snapshotsnapshotSearchHomeValues
                                                  ?.data ??
                                              [''],
                                      searchPetTypeInitialValue:
                                          snapshotHomePetTypeInitialValue
                                                  ?.data ??
                                              '',
                                      searchPetTypeValues:
                                          snapshotHomePetTypeValues?.data ??
                                              [''],
                                      isType:
                                          snapshotSearchPetByTypeOnHome?.data ??
                                              false,
                                      onDropdownTypeChange: (String text) {
                                        if (text == 'Nome do PET') {
                                          petsProvider
                                              .changeIsFilteringByBreed(false);
                                          refineSearchProvider
                                              .changeSearchPetByTypeOnHome(
                                                  false);
                                          refineSearchProvider
                                              .changeSearchHomeTypeInitialValue(
                                                  text);
                                        } else if (text == 'Tipo') {
                                          petsProvider
                                              .changeIsFilteringByBreed(false);
                                          petsProvider
                                              .changeIsFilteringByName(false);
                                          refineSearchProvider
                                              .changeSearchPetByTypeOnHome(
                                                  true);
                                          refineSearchProvider
                                              .changeSearchHomeTypeInitialValue(
                                                  text);
                                        } else {
                                          petsProvider
                                              .changeIsFilteringByName(false);
                                          refineSearchProvider
                                              .changeSearchPetByTypeOnHome(
                                                  false);
                                          refineSearchProvider
                                              .changeSearchHomeTypeInitialValue(
                                                  text);
                                        }
                                      },
                                      onDropdownPetTypeChange: (String text) {
                                        petsProvider.clearOthersFilters();
                                        refineSearchProvider
                                            .changeSearchHomePetTypeInitialValue(
                                                text);
                                        petsProvider.changePetType(text);

                                        if (text == 'Todos') {
                                          refineSearchProvider
                                              .clearRefineSelections();
                                          if (petsProvider.getPetKind ==
                                              'Donate') {
                                            refineSearchProvider
                                                .changeIsHomeFilteringByDonate(
                                                    false);
                                            refineSearchProvider
                                                .changeHomePetTypeFilterByDonate(
                                                    text);
                                            petsProvider
                                                .changeIsFiltering(false);
                                            petsProvider.loadDonatePETS();
                                          } else {
                                            refineSearchProvider
                                                .changeIsHomeFilteringByDisappeared(
                                                    false);
                                            refineSearchProvider
                                                .changeHomePetTypeFilterByDisappeared(
                                                    text);
                                            petsProvider
                                                .changeIsFiltering(false);
                                            petsProvider.loadDisappearedPETS();
                                          }
                                        } else {
                                          if (petsProvider.getPetKind ==
                                              'Donate') {
                                            refineSearchProvider
                                                .changeIsHomeFilteringByDonate(
                                                    true);
                                            refineSearchProvider
                                                .changeHomePetTypeFilterByDonate(
                                                    text);
                                            petsProvider
                                                .changeIsFiltering(true);
                                            petsProvider.loadDonatePETS();
                                          } else {
                                            refineSearchProvider
                                                .changeIsHomeFilteringByDisappeared(
                                                    true);
                                            refineSearchProvider
                                                .changeHomePetTypeFilterByDisappeared(
                                                    text);
                                            petsProvider
                                                .changeIsFiltering(true);
                                            petsProvider.loadDisappearedPETS();
                                          }
                                        }
                                      },
                                      onSubmit: (String text) {
                                        if (refineSearchProvider
                                                .getSearchHomeTypeInitialValue ==
                                            'Nome do PET') {
                                          petsProvider
                                              .changeIsFilteringByName(true);
                                          petsProvider.clearOthersFilters();
                                          petsProvider.changePetName(text);
                                        } else {
                                          petsProvider
                                              .changeIsFilteringByBreed(true);
                                          petsProvider.clearOthersFilters();
                                          petsProvider
                                              .changeBreedSelected(text);
                                        }
                                        petsProvider.changeIsFiltering(true);
                                        petsProvider.reloadList();
                                      });
                                });
                          });
                    });
              });
        });
  }
}
