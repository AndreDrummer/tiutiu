import 'package:tiutiu/features/refine_search/controller/refine_search_controller.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:tiutiu/Widgets/input_search.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:tiutiu/core/utils/filters.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RefineSearchController _refineSearchController = Get.find();

class DonateDisappearedList extends StatefulWidget {
  DonateDisappearedList({this.petList});
  final List<Pet>? petList;

  @override
  _DonateDisappearedListState createState() => _DonateDisappearedListState();
}

class _DonateDisappearedListState extends State<DonateDisappearedList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  late ScrollController _scrollController;
  GlobalKey dataKey = GlobalKey();
  bool filtering = false;

  @override
  void initState() {
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 1.15;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey[50],
      body: StreamBuilder(
          stream: petsController.updatePetList(),
          builder: (context, snapshot) {
            print('>> Snapshot ${(snapshot.data as List<Pet>).first.name}');

            // Dá uma lida no padrão Triple.

            return ListView(
              children: [
                FilterCard(),
                Builder(
                  builder: (BuildContext context) {
                    petsController.updatePetList();
                    List<Pet> petsList =
                        OtherFunctions.filterResultsByDistancie(
                      context,
                      widget.petList != null
                          ? widget.petList!
                          : petsController.typingSearchResult,
                      'null',
                    );

                    if (petsController.ageSelected.isNotEmpty &&
                        petsController.ageSelected == 'Mais de 10 ageYears') {
                      petsList =
                          Filters.filterResultsByAgeOver10(widget.petList!);
                    }

                    switch (petsController.orderType) {
                      case 'Nome':
                        petsList.sort(Ordenators.orderByName);
                        break;
                      case 'Idade':
                        petsList.sort(Ordenators.orderByAge);
                        break;
                      default:
                        petsList.sort(Ordenators.orderByPostDate);
                    }

                    if (widget.petList == null || petsList.isEmpty) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.search);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: height / 3.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.noPetFound,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AppStrings.verifyFilters,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
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
                                    CustomDropdownButtonSearch(
                                      colorText: Colors.black54,
                                      fontSize: 13,
                                      initialValue: petsController.orderType,
                                      isExpanded: false,
                                      withPipe: false,
                                      itemList: petsController.orderTypeList,
                                      label: '',
                                      onChange: (String text) {
                                        petsController.changeOrderType(
                                          text,
                                          'null',
                                        );
                                      },
                                    )
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
                                            _scrollController.animateTo(
                                                0 * height / 3,
                                                duration:
                                                    new Duration(seconds: 2),
                                                curve: Curves.ease);
                                          },
                                          child: Container(
                                            height: 280,
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 24.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            'Voltar ao topo'
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                        Icon(
                                                            Icons
                                                                .arrow_drop_up_sharp,
                                                            color: Colors.blue)
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
                                  donate: petsList[index].kind ==
                                      FirebaseEnvPath.donate,
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
            );
          }),
    );
  }
}

class _StateFilter extends StatefulWidget {
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
              child: StreamBuilder<String>(builder: (context, snapshot) {
                return Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: 'Brasil',
                    onChanged: (value) async {
                      if (value == 'Brasil') {
                        value = null;
                      }

                      petsController.reloadList(state: value);
                    },
                    items: DummyData.statesName
                        .map<DropdownMenuItem<String>>((String e) {
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
  void handleSearchType(String searchType) {
    switch (searchType) {
      case 'Nome do PET':
        petsController.isFilteringByBreed = false;
        _refineSearchController.changeSearchPetByTypeOnHome(false);
        _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
        break;
      case 'Tipo':
        petsController.isFilteringByBreed = false;
        petsController.isFilteringByName = false;
        _refineSearchController.changeSearchPetByTypeOnHome(true);
        _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
        handleSearchOptions(
          _refineSearchController.searchHomeTypeInitialValue,
        );
        break;
      default:
        petsController.isFilteringByName = false;
        _refineSearchController.changeSearchPetByTypeOnHome(false);
        _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
    }
  }

  void handleSearchOptions(String searchOption) {
    petsController.clearOthersFilters();
    _refineSearchController.changeSearchHomePetTypeInitialValue(searchOption);
    petsController.petType = searchOption;

    if (searchOption == 'Todos') {
      _refineSearchController.clearRefineSelections();
      switch (petsController.petKind) {
        case FirebaseEnvPath.donate:
          _refineSearchController.changeIsHomeFilteringByDonate(false);
          _refineSearchController.changeHomePetTypeFilterByDonate(searchOption);
          petsController.isFiltering = false;
          // petsController.loadDonatePETS(
          //   state: _refineSearchController.stateOfResultSearch,
          // );
          break;
        case FirebaseEnvPath.disappeared:
          _refineSearchController.changeIsHomeFilteringByDisappeared(false);
          _refineSearchController
              .changeHomePetTypeFilterByDisappeared(searchOption);
          petsController.isFiltering = false;
          petsController.loadDisappearedPETS(
              state: _refineSearchController.stateOfResultSearch);
          break;
      }
    } else {
      switch (petsController.petKind) {
        case FirebaseEnvPath.donate:
          _refineSearchController.changeIsHomeFilteringByDonate(true);
          _refineSearchController.changeHomePetTypeFilterByDonate(searchOption);
          petsController.isFiltering = true;
          // petsController.loadDonatePETS(
          //     state: _refineSearchController.stateOfResultSearch);
          break;
        case FirebaseEnvPath.disappeared:
          _refineSearchController.changeIsHomeFilteringByDisappeared(true);
          _refineSearchController
              .changeHomePetTypeFilterByDisappeared(searchOption);
          petsController.isFiltering = true;
          petsController.loadDisappearedPETS(
              state: _refineSearchController.stateOfResultSearch);
          break;
      }
    }
  }

  void handleOnTextSearchChange(String textSearch) {
    if (_refineSearchController.searchHomeTypeInitialValue == 'Nome do PET') {
      petsController.isFilteringByName = true;
      petsController.clearOthersFilters();
      petsController.petName = textSearch;
    } else {
      petsController.isFilteringByBreed = true;
      petsController.clearOthersFilters();
      petsController.breedSelected = textSearch;
    }
    petsController.isFiltering = true;
    performTypingSearch(textSearch);
  }

  void performTypingSearch(String text) {
    petsController.typingSearchResult = [];

    List<Pet> oldPetList = petsController.petKind == FirebaseEnvPath.donate
        ? petsController.petsDonate
        : petsController.petsDisappeared;
    if (text.trim().removeAccent().isNotEmpty) {
      List<Pet> newPetList = [];
      for (Pet pet in oldPetList) {
        if (petsController.isFilteringByName &&
            pet.name!.toLowerCase().contains(text.removeAccent().toLowerCase()))
          newPetList.add(pet);
        if (petsController.isFilteringByBreed &&
            pet.breed!
                .toLowerCase()
                .contains(text.removeAccent().toLowerCase()))
          newPetList.add(pet);
      }
      petsController.typingSearchResult = newPetList;
    }
    if (text.trim().removeAccent().isEmpty)
      petsController.typingSearchResult = oldPetList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        builder: (context, snapshotSearchHomeInitialValue) {
      return StreamBuilder<List<String>>(
          builder: (context, snapshotsnapshotSearchHomeValues) {
        return StreamBuilder<String>(
            builder: (context, snapshotHomePetTypeInitialValue) {
          return StreamBuilder<List<String>>(
              builder: (context, snapshotHomePetTypeValues) {
            return StreamBuilder<bool>(
                builder: (context, snapshotSearchPetByTypeOnHome) {
              return CustomInput(
                searchInitialValue: snapshotSearchHomeInitialValue.data ?? '',
                searchValues: snapshotsnapshotSearchHomeValues.data ?? [''],
                searchPetTypeInitialValue:
                    snapshotHomePetTypeInitialValue.data ?? '',
                searchPetTypeValues: snapshotHomePetTypeValues.data ?? [''],
                isType: snapshotSearchPetByTypeOnHome.data ?? false,
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
                    Icon(_isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.expand_more),
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
                    child: _StateFilter(),
                  ),
                  Divider(),
                  _HomeSearch(),
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
