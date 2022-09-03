import 'package:flutter/material.dart';
import 'package:tiutiu/core/data/dummy_data.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({super.key, required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: isExpanded ? 240 : 48,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Filtrar resultado"),
                  Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.expand_more),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: isExpanded ? 170 : 0,
              child: ListView(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: _StateFilter(),
                  ),
                  Divider(),
                  // _HomeSearch(),
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

// class _HomeSearch extends StatelessWidget {
//   void handleSearchType(String searchType) {
//     switch (searchType) {
//       case 'Nome do PET':
//         petsController.isFilteringByBreed = false;
//         _refineSearchController.changeSearchPetByTypeOnHome(false);
//         _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
//         break;
//       case 'Tipo':
//         petsController.isFilteringByBreed = false;
//         petsController.isFilteringByName = false;
//         _refineSearchController.changeSearchPetByTypeOnHome(true);
//         _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
//         handleSearchOptions(
//           _refineSearchController.searchHomeTypeInitialValue,
//         );
//         break;
//       default:
//         petsController.isFilteringByName = false;
//         _refineSearchController.changeSearchPetByTypeOnHome(false);
//         _refineSearchController.changeSearchHomeTypeInitialValue(searchType);
//     }
//   }

//   void handleSearchOptions(String searchOption) {
//     petsController.clearOthersFilters();
//     _refineSearchController.changeSearchHomePetTypeInitialValue(searchOption);
//     petsController.petType = searchOption;

//     if (searchOption == 'Todos') {
//       _refineSearchController.clearRefineSelections();
//       switch (petsController.petKind) {
//         case FirebaseEnvPath.donate:
//           _refineSearchController.changeIsHomeFilteringByDonate(false);
//           _refineSearchController.changeHomePetTypeFilterByDonate(searchOption);
//           petsController.isFiltering = false;
//           // petsController.loadDonatePETS(
//           //   state: _refineSearchController.stateOfResultSearch,
//           // );
//           break;
//         case FirebaseEnvPath.disappeared:
//           _refineSearchController.changeIsHomeFilteringByDisappeared(false);
//           _refineSearchController
//               .changeHomePetTypeFilterByDisappeared(searchOption);
//           petsController.isFiltering = false;
//           petsController.loadDisappearedPETS(
//               state: _refineSearchController.stateOfResultSearch);
//           break;
//       }
//     } else {
//       switch (petsController.petKind) {
//         case FirebaseEnvPath.donate:
//           _refineSearchController.changeIsHomeFilteringByDonate(true);
//           _refineSearchController.changeHomePetTypeFilterByDonate(searchOption);
//           petsController.isFiltering = true;
//           // petsController.loadDonatePETS(
//           //     state: _refineSearchController.stateOfResultSearch);
//           break;
//         case FirebaseEnvPath.disappeared:
//           _refineSearchController.changeIsHomeFilteringByDisappeared(true);
//           _refineSearchController
//               .changeHomePetTypeFilterByDisappeared(searchOption);
//           petsController.isFiltering = true;
//           petsController.loadDisappearedPETS(
//               state: _refineSearchController.stateOfResultSearch);
//           break;
//       }
//     }
//   }

//   void handleOnTextSearchChange(String textSearch) {
//     if (_refineSearchController.searchHomeTypeInitialValue == 'Nome do PET') {
//       petsController.isFilteringByName = true;
//       petsController.clearOthersFilters();
//       petsController.petName = textSearch;
//     } else {
//       petsController.isFilteringByBreed = true;
//       petsController.clearOthersFilters();
//       petsController.breedSelected = textSearch;
//     }
//     petsController.isFiltering = true;
//     performTypingSearch(textSearch);
//   }

//   void performTypingSearch(String text) {
//     petsController.typingSearchResult = [];

//     List<Pet> oldPetList = petsController.petKind == FirebaseEnvPath.donate
//         ? petsController.petsDonate
//         : petsController.petsDisappeared;
//     if (text.trim().removeAccent().isNotEmpty) {
//       List<Pet> newPetList = [];
//       for (Pet pet in oldPetList) {
//         if (petsController.isFilteringByName &&
//             pet.name!.toLowerCase().contains(text.removeAccent().toLowerCase()))
//           newPetList.add(pet);
//         if (petsController.isFilteringByBreed &&
//             pet.breed!
//                 .toLowerCase()
//                 .contains(text.removeAccent().toLowerCase()))
//           newPetList.add(pet);
//       }
//       petsController.typingSearchResult = newPetList;
//     }
//     if (text.trim().removeAccent().isEmpty)
//       petsController.typingSearchResult = oldPetList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<String>(
//         builder: (context, snapshotSearchHomeInitialValue) {
//       return StreamBuilder<List<String>>(
//           builder: (context, snapshotsnapshotSearchHomeValues) {
//         return StreamBuilder<String>(
//             builder: (context, snapshotHomePetTypeInitialValue) {
//           return StreamBuilder<List<String>>(
//               builder: (context, snapshotHomePetTypeValues) {
//             return StreamBuilder<bool>(
//                 builder: (context, snapshotSearchPetByTypeOnHome) {
//               return CustomInput(
//                 searchInitialValue: snapshotSearchHomeInitialValue.data ?? '',
//                 searchValues: snapshotsnapshotSearchHomeValues.data ?? [''],
//                 searchPetTypeInitialValue:
//                     snapshotHomePetTypeInitialValue.data ?? '',
//                 searchPetTypeValues: snapshotHomePetTypeValues.data ?? [''],
//                 isType: snapshotSearchPetByTypeOnHome.data ?? false,
//                 onDropdownTypeChange: handleSearchType,
//                 onDropdownHomeSearchOptionsChange: handleSearchOptions,
//                 onChanged: handleOnTextSearchChange,
//               );
//             });
//           });
//         });
//       });
//     });
//   }
// }
