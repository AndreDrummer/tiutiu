import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/data/dummy_data.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/screen/selection_page.dart';
import 'package:tiutiu/utils/routes.dart';

class RefineSearch extends StatefulWidget {
  @override
  _RefineSearchState createState() => _RefineSearchState();
}

class _RefineSearchState extends State<RefineSearch> {
  PetsProvider petsProvider;  
  RefineSearchProvider refineSearchProvider;  
  bool isRefiningSearch = false;
  int selectedKind;
      

  List petsType = ['Cachorro', 'Gato', 'Pássaro', 'Hamster', 'Outro'];

  void changeIsRefineSearchStatus(bool status) {
    setState(() {
      isRefiningSearch = status;
    });
  }

  void handleSelectedKind(int index) {
    refineSearchProvider.changeBreedsSelected([]);
    refineSearchProvider.changeSizesSelected([]);
    refineSearchProvider.changeAgesSelected([]);
    refineSearchProvider.changeHealthsSelected([]);
    refineSearchProvider.changeKindSelected(index)    ;    
  }

  @override
  void didChangeDependencies() {
    petsProvider = Provider.of<PetsProvider>(context);
    refineSearchProvider = Provider.of<RefineSearchProvider>(context);
    selectedKind = refineSearchProvider.getKindSelected;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List listOptions = [
      {
        'title': 'Raça',
        'listSelected': refineSearchProvider.getBreedsSelected,
        'selectionPageTitle': 'Selecione as Raças',
        'selectionPageList': DummyData.breed[selectedKind],
        'clearFunction': () {
          refineSearchProvider.changeBreedsSelected([]);
        }
      },
      {
        'title': 'Tamanho',
        'listSelected': refineSearchProvider.getSizesSelected,
        'selectionPageTitle': 'Tamanhos',
        'selectionPageList': DummyData.size,
        'clearFunction': () {
          refineSearchProvider.changeBreedsSelected([]);
        }
      },
      {
        'title': 'Idade',
        'listSelected': refineSearchProvider.getAgesSelected,
        'selectionPageTitle': 'Idades',
        'selectionPageList': DummyData.ages,
        'clearFunction': () {
          refineSearchProvider.changeBreedsSelected([]);
        }
      },
      {
        'title': 'Saúde',
        'listSelected': refineSearchProvider.getHealthsSelected,
        'selectionPageTitle': 'Estado de saúde',
        'selectionPageList': DummyData.health,
        'clearFunction': () {
          refineSearchProvider.changeBreedsSelected([]);
        }
      },
      {
        'title': 'Distância',
        'listSelected': refineSearchProvider.getDistanciesSelected,
        'selectionPageTitle': 'Distância',
        'selectionPageList': DummyData.distancies,
        'clearFunction': () {
          refineSearchProvider.changeBreedsSelected([]);
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refine sua busca',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment(-1, 1),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                    child: Text(
                      'Tipo de PET',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
                _PetSelector(
                  handleSelectedKind: handleSelectedKind,
                  selectedKind: selectedKind,
                ),
                Column(
                  children: listOptions.map((optionTile) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _SelecterTile(
                        titleTile: optionTile['title'],
                        selectedValuesList: optionTile['listSelected'],
                        clear: optionTile['clearFunction'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SelectionPage(
                                  title: optionTile['selectionPageTitle'],
                                  list: optionTile['selectionPageList'],
                                  listSelected: optionTile['listSelected'],
                                );
                              },
                            ),
                          ).then((value) {
                            if (value != null) {
                              setState(() {
                                optionTile['listSelected'] = value;
                              });
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWide(
                    color: Colors.purple,
                    text: 'BUSCAR',
                    action: () async {
                      changeIsRefineSearchStatus(true);
                        await petsProvider.bigQueryRefine('Donate', petsType[selectedKind], refineSearchProvider.getBreedsSelected, refineSearchProvider.getSizesSelected, refineSearchProvider.getAgesSelected, refineSearchProvider.getHealthsSelected, refineSearchProvider.getDistanciesSelected);
                        changeIsRefineSearchStatus(false);
                        Navigator.pushNamed(context, Routes.HOME);
                    },
                  ),
                )
              ],
            ),
          ),
          LoadDarkScreen(show: isRefiningSearch, message: 'Refinando resultados...')
        ],
      ),
    );
  }
}

class _PetSelector extends StatelessWidget {
  _PetSelector({this.handleSelectedKind, this.selectedKind});
  final Function(int) handleSelectedKind;
  final int selectedKind;

  final List selector = [
    {'Cachorro': Tiutiu.dog},
    {'Gato': Tiutiu.cat},
    {'Pássaro': Tiutiu.twitter_bird},
    {'Hamster': Tiutiu.hamster},
    {'Outro': Tiutiu.question},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selector.length,
          itemBuilder: (_, index) {
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0)),
              elevation: index == selectedKind ? 6.0 : null,
              child: InkWell(
                onTap: () {
                  handleSelectedKind(index);
                },
                child: Container(
                  color: index == selectedKind
                      ? Theme.of(context).primaryColor
                      : null,
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selector[index].values.first,
                        size: 40,
                        color:
                            index == selectedKind ? Colors.white : Colors.black,
                      ),
                      SizedBox(height: 10),
                      Text(
                        selector[index].keys.first,
                        style: TextStyle(
                          fontWeight:
                              index == selectedKind ? FontWeight.bold : null,
                          color: index == selectedKind
                              ? Colors.white
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SelecterTile extends StatefulWidget {
  _SelecterTile({
    this.titleTile,
    this.selectedValuesList,
    this.onTap,
    this.clear,
  });

  final String titleTile;
  final List selectedValuesList;
  final Function() onTap;
  final Function() clear;

  @override
  __SelecterTileState createState() => __SelecterTileState();
}

class __SelecterTileState extends State<_SelecterTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  widget.titleTile,
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
               widget.selectedValuesList.isNotEmpty ? FlatButton(
                 child: Text('Limpar'),
                 onPressed: () => widget.clear(),
               ) : Icon(Tiutiu.plus_squared_alt),
              ],
            ),
            Container(
              height: 20,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.selectedValuesList.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.selectedValuesList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
