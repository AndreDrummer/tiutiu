import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/badge.dart';
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
  bool isPetDisappeared = false;
  int selectedKind;

  List petsType = ['Cachorro', 'Gato', 'Pássaro', 'Hamster', 'Outro'];

  void changeIsRefineSearchStatus(bool status) {
    setState(() {
      isRefiningSearch = status;
    });
  }

  void changePetKind(bool value) {    
    refineSearchProvider.changeIsDisappeared(value);
  }

  void handleSelectedKind(int index) {
    refineSearchProvider.changeBreedSelected('');
    refineSearchProvider.changeSizeSelected('');
    refineSearchProvider.changeAgeSelected('');
    refineSearchProvider.changeHealthSelected('');
    refineSearchProvider.changeKindSelected(index);
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
        'valueSelected': refineSearchProvider.getBreedSelected,
        'selectionPageTitle': 'Selecione as Raças',
        'selectionPageList': DummyData.breed[selectedKind],
        'onValueSelected': (String value) {
          refineSearchProvider.changeBreedSelected(value);
        },
        'clearFunction': () {
          refineSearchProvider.changeBreedSelected('');
        }
      },
      {
        'title': 'Tamanho',
        'valueSelected': refineSearchProvider.getSizeSelected,
        'selectionPageTitle': 'Tamanhos',
        'selectionPageList': DummyData.size,
        'onValueSelected': (String value) {
          refineSearchProvider.changeSizeSelected(value);
        },
        'clearFunction': () {
          refineSearchProvider.changeSizeSelected('');
        }
      },
      {
        'title': 'Idade',
        'valueSelected': refineSearchProvider.getAgeSelected,
        'selectionPageTitle': 'Idades',
        'selectionPageList': DummyData.ages,
        'onValueSelected': (String value) {
          value = value?.split('')?.first;
          refineSearchProvider.changeAgeSelected(value);
        },
        'clearFunction': () {
          refineSearchProvider.changeAgeSelected('');
        }
      },
      {
        'title': 'Saúde',
        'valueSelected': refineSearchProvider.getHealthSelected,
        'selectionPageTitle': 'Estado de saúde',
        'selectionPageList': DummyData.health,
        'onValueSelected': (String value) {
          refineSearchProvider.changeHealthSelected(value);
        },
        'clearFunction': () {
          refineSearchProvider.changeHealthSelected('');
        }
      },
      {
        'title': 'Distância',
        'valueSelected': refineSearchProvider.getDistancieSelected,
        'selectionPageTitle': 'Distância',
        'selectionPageList': DummyData.distancies,
        'onValueSelected': (String value) {
          refineSearchProvider.changeDistancieSelected(value);
        },
        'clearFunction': () {
          refineSearchProvider.changeDistancieSelected('');
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refine sua busca',
          style: TextStyle(color: Colors.white, fontSize: 20),
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
                Stack(
                  children: [
                    Column(
                      children: listOptions.map((optionTile) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _SelecterTile(
                            titleTile: optionTile['title'],
                            valueSelected: optionTile['valueSelected'],
                            clear: optionTile['clearFunction'],
                            onTap: selectedKind == 0 ? null : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SelectionPage(
                                      title: optionTile['selectionPageTitle'],
                                      list: optionTile['selectionPageList'],
                                      valueSelected: optionTile['valueSelected'],
                                    );
                                  },
                                ),
                              ).then((value) {
                                if (value != null) {
                                  optionTile['onValueSelected'](value);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    selectedKind == 0 ? Container(color: Colors.black12, height: 272) : Container(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Desaparecido ?',
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(                      
                        value: refineSearchProvider.getIsDisappeared,
                        onChanged: (value) {
                          changePetKind(value);
                        },
                      ),
                      Text(
                        'Sim',
                        style: TextStyle(fontSize: 18),
                      ),
                      Checkbox(
                        value: !refineSearchProvider.getIsDisappeared,
                        onChanged: (value) {
                          changePetKind(!value);
                        },
                      ),
                      Text(
                        'Não',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWide(
                    color: isRefiningSearch ? Colors.grey : Colors.purple,
                    text: 'BUSCAR',
                    action: isRefiningSearch ? null : () async {
                      changeIsRefineSearchStatus(true);
                      await petsProvider.bigQueryRefine(
                          refineSearchProvider.getIsDisappeared ? 'Disappeared' : 'Donate',
                          selectedKind == 0 ? 'Todos' : petsType[selectedKind - 1],
                          refineSearchProvider.getBreedSelected,
                          refineSearchProvider.getSizeSelected,
                          refineSearchProvider.getAgeSelected,
                          refineSearchProvider.getHealthSelected,
                          refineSearchProvider.getDistancieSelected);
                      changeIsRefineSearchStatus(false);
                      Navigator.pushNamed(context, Routes.HOME, arguments: refineSearchProvider.getIsDisappeared ? 1 : 0);
                    },
                  ),
                )
              ],
            ),
          ),
          LoadDarkScreen(
              show: isRefiningSearch, message: 'Refinando resultados...')
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
    {'Todos': Icons.all_inclusive},
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
    this.valueSelected,
    this.onTap,
    this.clear,
  });

  final String titleTile;
  final String valueSelected;
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    widget.titleTile,
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  widget.valueSelected != null &&
                          widget.valueSelected.isNotEmpty
                      ? Container(
                          height: 20,
                          child: Badge(text: widget.valueSelected),
                        )
                      : Container(),
                  Spacer(),
                  widget.valueSelected != null &&
                          widget.valueSelected.isNotEmpty
                      ? FlatButton(
                          child: Text('Limpar'),
                          onPressed: () => widget.clear(),
                        )
                      : Icon(Tiutiu.plus_squared_alt),
                ],
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
