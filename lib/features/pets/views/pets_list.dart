import 'package:tiutiu/Widgets/home_filter_item.dart';
import 'package:tiutiu/Widgets/top_bar.dart';
import 'package:tiutiu/core/migration/controller/migration_controller.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/widgets/stream_handler.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/filter_card.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetsList extends StatefulWidget {
  @override
  _PetsListState createState() => _PetsListState();
}

class _PetsListState extends State<PetsList> with TiuTiuPopUp {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  late ScrollController _scrollController;
  GlobalKey dataKey = GlobalKey();
  bool filtering = false;

  final MigrationController _migrationController = Get.find();

  @override
  void initState() {
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _migrationController.migrate();

    final marginTop = MediaQuery.of(context).size.height / 1.15;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<List<Pet>>(
        stream: petsController.petsList(),
        builder: (context, snapshot) {
          return StreamHandler<List<Pet>>(
            loadingMessage: AppStrings.loadingDots,
            snapshot: snapshot,
            buildWidget: ((petsList) {
              return ListView(
                children: [
                  Container(
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
                                            padding: const EdgeInsets.all(16.0),
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
                  )
                ],
              );
            }),
          );
        },
      ),
    );
  }
}
