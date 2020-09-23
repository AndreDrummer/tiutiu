import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';

class RefineSearch extends StatefulWidget {
  @override
  _RefineSearchState createState() => _RefineSearchState();
}

class _RefineSearchState extends State<RefineSearch> {
  int selectedKind = 0;

  List listOptions = [
    'Raça',
    'Tamanho',
    'Idade',
    'Estado de Saúde',
    'Distância',
  ];

  List selector = [
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
    {'Cachorro': PetDetailIcons.dog},
  ];

  void handleSelectedKind(int index) {
    setState(() {
      selectedKind = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refine sua busca',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selector.length,
                  itemBuilder: (_, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8.0),
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
                                color: index == selectedKind
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(height: 10),
                              Text(
                                selector[index].keys.first,
                                style: TextStyle(
                                  fontWeight: index == selectedKind
                                      ? FontWeight.bold
                                      : null,
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: listOptions
                    .map(
                      (e) => Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      e,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.add),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Selecionado',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  color: Colors.grey[200],
                                  height: 1.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonWide(
                text: 'BUSCAR',
                action: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
