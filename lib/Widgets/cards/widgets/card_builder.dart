import 'package:tiutiu/Widgets/cards/widgets/ad_distance_from_user.dart';
import 'package:tiutiu/features/favorites/widgets/favorite_button.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_interesteds.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_description.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_city_state.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_posted_at.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_images.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_views.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardBuilder {
  const CardBuilder({
    required this.distanceText,
    this.inReviewMode = false,
    required Post post,
  }) : _post = post;

  final String distanceText;
  final bool inReviewMode;
  final Post _post;

  Widget adImages() => AdImages(cardHeight: Get.height / (inReviewMode ? 3 : 2.2), photos: (_post as Pet).photos);

  Widget adInteresteds() => AdInteresteds(visible: (_post as Pet).disappeared, petKind: (_post as Pet).type);

  Widget favoriteButton() => Visibility(
      replacement: RemoveFavoriteButton(onTap: () => favoritesController.removeFavorite(_post)),
      visible: homeController.bottomBarIndex != BottomBarIndex.FAVORITES.indx,
      child: AddFavoriteButton(onTap: () => favoritesController.addFavorite(_post)));

  Widget adCityState() => AdCityState(state: (_post as Pet).state, city: (_post as Pet).city);

  Widget adDistanceFromUser() => AdDistanceFromUser(distanceText: distanceText);

  Widget adDescription() => AdDescription(description: (_post as Pet).breed);

  Widget adPostedAt() => AdPostedAt(createdAt: (_post as Pet).createdAt!);

  Widget adViews() => AdViews(views: (_post as Pet).views);

  Widget adTitle() => AdTitle(title: (_post as Pet).name!);

  Widget divider() => Divider(height: 8.0.h);
}
