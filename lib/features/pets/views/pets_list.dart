import 'package:tiutiu/core/migration/controller/migration_controller.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/Widgets/cards/card_ad_list.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonateList extends StatelessWidget {
  const DonateList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PetsList();
  }
}

class DisappearedList extends StatelessWidget {
  const DisappearedList({super.key});

  @override
  Widget build(BuildContext context) {
    return _PetsList(disappeared: true);
  }
}

class _PetsList extends StatelessWidget with TiuTiuPopUp {
  const _PetsList({this.disappeared = false});

  final bool disappeared;

  @override
  Widget build(BuildContext context) {
    final MigrationController _migrationController = Get.find();

    _migrationController.migrate();

    return Obx(
      () => StreamBuilder<List<Pet>>(
        stream: petsController.petsList(
          isFilteringByName: filterController.filterByName.isNotEmpty,
          orderParam: filterController.orderBy,
          disappeared: disappeared,
        ),
        builder: (context, snapshot) {
          return AsyncHandler<List<Pet>>(
            showLoadingScreen: filterController.filterByName.isEmpty,
            loadingMessage: AppStrings.loadingDots,
            snapshot: snapshot,
            buildWidget: ((list) {
              final petsList = list;

              return ListView.builder(
                itemCount: petsList.length + 1,
                padding: EdgeInsets.zero,
                key: UniqueKey(),
                itemBuilder: (_, index) {
                  if (petsList.isEmpty) return EmptyListScreen();

                  return GestureDetector(
                    onTap: () {
                      print(petsList[index < petsList.length
                              ? index
                              : petsList.length - 1]
                          .video);
                      Get.toNamed(Routes.petDetails);
                      petsController.pet = petsList[index < petsList.length
                          ? index
                          : petsList.length - 1];
                    },
                    child: _RenderListItem(
                      showBackToStartButton: index == petsList.length,
                      onNavigateToTop: homeController.onScrollUp,
                      pet: petsList[index < petsList.length
                          ? index
                          : petsList.length - 1],
                    ),
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
