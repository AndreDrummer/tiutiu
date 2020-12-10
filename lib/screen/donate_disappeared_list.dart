import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tiutiu/Widgets/card_list.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/Widgets/error_page.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/data/dummy_data.dart';
import 'package:tiutiu/providers/ads_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/utils/other_functions.dart';
import 'package:tiutiu/utils/routes.dart';
import 'package:tiutiu/utils/string_extension.dart';

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
  GlobalKey dataKey = GlobalKey();
  ScrollController _scrollController;

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
    userProvider = Provider.of<UserProvider>(context, listen: false);
    petsProvider = Provider.of<PetsProvider>(context);
    location = Provider.of<Location>(context);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    super.initState();
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
    return DateTime.parse(b.createdAt).millisecondsSinceEpoch - DateTime.parse(a.createdAt).millisecondsSinceEpoch;
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

  List<Pet> showAdminCards(List<Pet> petCards) {
    for (int i = 0; i < petCards.length; i++) {
      if (petCards[i].ownerId == Constantes.ADMIN_ID && DateTime.now().difference(DateTime.parse(petCards[i].createdAt)).inDays > 2) {
        petCards.removeAt(i);
      } else if (petCards[i].ownerId == Constantes.ADMIN_ID) {
        Pet pet = petCards[i];
        petCards.removeAt(i);
        petCards.insert(0, pet);
      }
    }

    return petCards;
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.25;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey[50],
      body: ListView(
        children: [
          FilterCard(
            petsProvider: petsProvider,
            refineSearchProvider: refineSearchProvider,
          ),
          StreamBuilder<List<Pet>>(
            stream: (petsProvider.getIsFilteringByBreed || petsProvider.getIsFilteringByName) ? petsProvider.typingSearchResult : widget.stream,
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

              List<Pet> petsList = OtherFunctions.filterResultsByDistancie(
                context,
                snapshot.data,
                refineSearchProvider.getDistancieSelected,
              );

              if (petsProvider.getAgeSelected != null && petsProvider.getAgeSelected.isNotEmpty && petsProvider.getAgeSelected == 'Mais de 10 anos') {
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

              petsList = showAdminCards(petsList);

              if (snapshot.data == null || petsList.length == 0) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SEARCH_REFINE);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 3.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                  ),
                );
              }

              return Container(
                height: marginTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 20,
                      alignment: Alignment(-0.9, 1),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: const EdgeInsets.only(bottom: 10, top: 5),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${petsList.length} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black26,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'encontrados',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  'ordenar por:  ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              StreamBuilder<Object>(
                                stream: petsProvider.orderType,
                                builder: (context, snapshot) {
                                  return CustomDropdownButtonSearch(
                                    colorText: Colors.black54,
                                    fontSize: 13,
                                    initialValue: petsProvider.getOrderType,
                                    isExpanded: false,
                                    withPipe: false,
                                    itemList: petsProvider.getOrderTypeList,
                                    label: '',
                                    onChange: (String text) {
                                      petsProvider.changeOrderType(text, refineSearchProvider.getStateOfResultSearch);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        key: UniqueKey(),
                        controller: _scrollController,
                        itemCount: petsList.length + 1,
                        itemBuilder: (_, index) {
                          if (index == petsList.length) {
                            return petsList.length > 1
                                ? InkWell(
                                    onTap: () {
                                      _scrollController.animateTo(0 * height / 3, duration: new Duration(seconds: 2), curve: Curves.ease);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            adsProvider.getCanShowAds ? adsProvider.bannerAdMob(adId: adsProvider.topAdId, medium_banner: true) : Container(),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Voltar ao topo'.toUpperCase(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700)),
                                                  Icon(Icons.arrow_drop_up_sharp, color: Colors.blue)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
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
        ],
      ),
    );
  }
}

class _StateFilter extends StatefulWidget {
  _StateFilter({
    this.refineSearchProvider,
    this.petsProvider,
  });

  final RefineSearchProvider refineSearchProvider;
  final PetsProvider petsProvider;

  @override
  _StateFilterState createState() => _StateFilterState();
}

class _StateFilterState extends State<_StateFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7.0, left: 24),
              child: Text(
                'Resultados de ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black26,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: StreamBuilder<String>(
                  stream: widget.refineSearchProvider.stateOfResultSearch,
                  builder: (context, snapshot) {
                    return Container(
                      height: 20,
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        underline: Container(),
                        value: widget.refineSearchProvider.getStateOfResultSearch ?? DummyData.statesName.first,
                        onChanged: (String value) async {
                          if (value == 'Brasil') {
                            value = null;
                          }
                          widget.refineSearchProvider.changeStateOfResultSearch(value);
                          widget.petsProvider.reloadList(state: value);
                        },
                        items: DummyData.statesName.map<DropdownMenuItem<String>>((String e) {
                          return DropdownMenuItem<String>(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                e.trim(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            value: e,
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }
}

class _HomeSearch extends StatelessWidget {
  _HomeSearch({
    this.petsProvider,
    this.refineSearchProvider,
  });

  final PetsProvider petsProvider;
  final RefineSearchProvider refineSearchProvider;

  void handleSearchType(String searchType) {
    switch (searchType) {
      case 'Nome do PET':
        petsProvider.changeIsFilteringByBreed(false);
        refineSearchProvider.changeSearchPetByTypeOnHome(false);
        refineSearchProvider.changeSearchHomeTypeInitialValue(searchType);
        break;
      case 'Tipo':
        petsProvider.changeIsFilteringByBreed(false);
        petsProvider.changeIsFilteringByName(false);
        refineSearchProvider.changeSearchPetByTypeOnHome(true);
        refineSearchProvider.changeSearchHomeTypeInitialValue(searchType);
        handleSearchOptions(refineSearchProvider.getSearchHomePetTypeInitialValue);
        break;
      default:
        petsProvider.changeIsFilteringByName(false);
        refineSearchProvider.changeSearchPetByTypeOnHome(false);
        refineSearchProvider.changeSearchHomeTypeInitialValue(searchType);
    }
  }

  void handleSearchOptions(String searchOption) {
    petsProvider.clearOthersFilters();
    refineSearchProvider.changeSearchHomePetTypeInitialValue(searchOption);
    petsProvider.changePetType(searchOption);

    if (searchOption == 'Todos') {
      refineSearchProvider.clearRefineSelections();
      switch (petsProvider.getPetKind) {
        case 'Donate':
          refineSearchProvider.changeIsHomeFilteringByDonate(false);
          refineSearchProvider.changeHomePetTypeFilterByDonate(searchOption);
          petsProvider.changeIsFiltering(false);
          petsProvider.loadDonatePETS(state: refineSearchProvider.getStateOfResultSearch);
          break;
        case 'Disappeared':
          refineSearchProvider.changeIsHomeFilteringByDisappeared(false);
          refineSearchProvider.changeHomePetTypeFilterByDisappeared(searchOption);
          petsProvider.changeIsFiltering(false);
          petsProvider.loadDisappearedPETS(state: refineSearchProvider.getStateOfResultSearch);
          break;
      }
    } else {
      switch (petsProvider.getPetKind) {
        case 'Donate':
          refineSearchProvider.changeIsHomeFilteringByDonate(true);
          refineSearchProvider.changeHomePetTypeFilterByDonate(searchOption);
          petsProvider.changeIsFiltering(true);
          petsProvider.loadDonatePETS(state: refineSearchProvider.getStateOfResultSearch);
          break;
        case 'Disappeared':
          refineSearchProvider.changeIsHomeFilteringByDisappeared(true);
          refineSearchProvider.changeHomePetTypeFilterByDisappeared(searchOption);
          petsProvider.changeIsFiltering(true);
          petsProvider.loadDisappearedPETS(state: refineSearchProvider.getStateOfResultSearch);
          break;
      }
    }
  }

  void handleOnTextSearchChange(String textSearch) {
    if (refineSearchProvider.getSearchHomeTypeInitialValue == 'Nome do PET') {
      petsProvider.changeIsFilteringByName(true);
      petsProvider.clearOthersFilters();
      petsProvider.changePetName(textSearch);
    } else {
      petsProvider.changeIsFilteringByBreed(true);
      petsProvider.clearOthersFilters();
      petsProvider.changeBreedSelected(textSearch);
    }
    petsProvider.changeIsFiltering(true);
    performTypingSearch(textSearch);
  }

  void performTypingSearch(String text) {
    petsProvider.changeTypingSearchResult([]);
    List<Pet> oldPetList = petsProvider.getPetKind == 'Donate' ? petsProvider.getPetsDonate : petsProvider.getPetsDisappeared;
    if (text.trim().removeAccent().isNotEmpty) {
      List<Pet> newPetList = [];
      for (Pet pet in oldPetList) {
        if (petsProvider.getIsFilteringByName && pet.name.toLowerCase().contains(text.removeAccent().toLowerCase())) newPetList.add(pet);
        if (petsProvider.getIsFilteringByBreed && pet.breed.toLowerCase().contains(text.removeAccent().toLowerCase())) newPetList.add(pet);
      }
      petsProvider.changeTypingSearchResult(newPetList);
    }
    if (text.trim().removeAccent().isEmpty) petsProvider.changeTypingSearchResult(oldPetList);
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
                                stream: refineSearchProvider.searchPetByTypeOnHome,
                                builder: (context, snapshotSearchPetByTypeOnHome) {
                                  return CustomInput(
                                    searchInitialValue: snapshotSearchHomeInitialValue?.data ?? '',
                                    searchValues: snapshotsnapshotSearchHomeValues?.data ?? [''],
                                    searchPetTypeInitialValue: snapshotHomePetTypeInitialValue?.data ?? '',
                                    searchPetTypeValues: snapshotHomePetTypeValues?.data ?? [''],
                                    isType: snapshotSearchPetByTypeOnHome?.data ?? false,
                                    onDropdownTypeChange: handleSearchType,
                                    onDropdownHomeSearchOptionsChange: handleSearchOptions,
                                    onChanged: handleOnTextSearchChange,
                                  );
                                });
                          });
                    });
              });
        });
  }
}

class FilterCard extends StatefulWidget {
  FilterCard({
    this.refineSearchProvider,
    this.petsProvider,
  });

  final RefineSearchProvider refineSearchProvider;
  final PetsProvider petsProvider;

  @override
  _FilterCardState createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _isExpanded ? 240 : 48,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Filtrar resultado"),
                    Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.expand_more),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: _isExpanded ? 170 : 0,
              child: ListView(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: _StateFilter(
                      refineSearchProvider: widget.refineSearchProvider,
                      petsProvider: widget.petsProvider,
                    ),
                  ),
                  Divider(),
                  _HomeSearch(
                    refineSearchProvider: widget.refineSearchProvider,
                    petsProvider: widget.petsProvider,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
