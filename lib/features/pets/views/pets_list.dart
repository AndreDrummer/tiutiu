import 'package:tiutiu/core/migration/controller/migration_controller.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/widgets/stream_handler.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/Widgets/cards/card_ad_list.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetsList extends StatefulWidget {
  const PetsList({
    super.key,
    this.disappeared = false,
  });

  final bool disappeared;

  @override
  _PetsListState createState() => _PetsListState();
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
          isFiltering: filterController.filterByName.isNotEmpty,
          disappeared: widget.disappeared,
        ),
        builder: (context, snapshot) {
          return StreamHandler<List<Pet>>(
            showLoadingScreen: filterController.filterByName.isEmpty,
            loadingMessage: AppStrings.loadingDots,
            snapshot: snapshot,
            buildWidget: ((petsList) {
              return ListView.builder(
                itemCount: petsList.length + 1,
                controller: _scrollController,
                padding: EdgeInsets.zero,
                key: UniqueKey(),
                itemBuilder: (_, index) {
                  if (petsList.isEmpty) return EmptyListScreen();

                  print(petsList.length);

                  return _RenderListItem(
                    showBackToStartButton: index == petsList.length,
                    onNavigateToTop: () {
                      _scrollController.animateTo(
                        duration: new Duration(seconds: 3),
                        curve: Curves.ease,
                        0,
                      );
                    },
                    pet: petsList[
                        index < petsList.length ? index : petsList.length - 1],
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

class _RenderListItem extends StatelessWidget {
  const _RenderListItem({
    this.showBackToStartButton = false,
    required this.onNavigateToTop,
    required this.pet,
  });

  final Function()? onNavigateToTop;
  final bool showBackToStartButton;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    if (showBackToStartButton)
      return BackToStart(
        onPressed: onNavigateToTop,
      );
    return Obx(
      () => homeController.cardVisibilityKind == CardVisibilityKind.banner
          ? CardAdList(pet: pet)
          : CardAd(pet: pet),
    );
  }
}
