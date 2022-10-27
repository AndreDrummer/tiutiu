import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/Widgets/cards/card_ad_list.dart';
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
    return Obx(() {
      final posts = postsController.filteredPosts;

      return RefreshIndicator(
        onRefresh: () async => postsController.loadPosts(
          getFromInternet: true,
        ),
        child: ListView.builder(
          itemCount: posts.length + 1,
          padding: EdgeInsets.zero,
          key: UniqueKey(),
          itemBuilder: (_, index) {
            if (posts.isEmpty) return EmptyListScreen();

            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.petDetails);
                postsController.post =
                    posts[index < posts.length ? index : posts.length - 1];
              },
              child: _RenderListItem(
                pet: posts[index < posts.length ? index : posts.length - 1],
                onNavigateToTop: () => homeController.onScrollUp(),
                showBackToStartButton: index == posts.length,
              ),
            );
          },
        ),
      );
    });
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
