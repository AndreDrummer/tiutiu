import 'package:tiutiu/core/migration/controller/migration_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/widgets/stream_handler.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/Widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetsList extends StatefulWidget {
  const PetsList({
    super.key,
    this.disappeared = false,
  });

  @override
  _PetsListState createState() => _PetsListState();

  final bool disappeared;
}

class _PetsListState extends State<PetsList> with TiuTiuPopUp {
  final MigrationController _migrationController = Get.find();
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _migrationController.migrate();

    return Obx(
      () => StreamBuilder<List<Pet>>(
        stream: petsController.petsList(
          disappeared: widget.disappeared,
        ),
        builder: (context, snapshot) {
          return StreamHandler<List<Pet>>(
            loadingMessage: AppStrings.loadingDots,
            snapshot: snapshot,
            buildWidget: ((petsList) {
              // petsList = petsList.sublist(0, 10);
              return ListView.builder(
                itemCount: petsList.length + 1,
                controller: _scrollController,
                padding: EdgeInsets.zero,
                key: UniqueKey(),
                itemBuilder: (_, index) {
                  if (petsList.isEmpty) return EmptyListScreen();

                  return index == petsList.length
                      ? BackToStart(
                          onPressed: () {
                            _scrollController.animateTo(
                              0,
                              duration: new Duration(seconds: 3),
                              curve: Curves.ease,
                            );
                          },
                        )
                      : CardList(
                          kind: petsList[index].kind,
                          petInfo: petsList[index],
                        );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
