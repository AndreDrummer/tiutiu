import 'package:tiutiu/Widgets/cards/widgets/ad_distance_from_user.dart';
import 'package:tiutiu/Widgets/cards/widgets/favorite_button.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_interesteds.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_description.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_city_state.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_posted_at.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_images.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/cards/widgets/ad_views.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:flutter/material.dart';

class CardBuilder {
  const CardBuilder({
    required this.distanceText,
    required Pet pet,
  }) : _pet = pet;

  final String distanceText;
  final Pet _pet;

  Widget adDistanceFromUser() => AdDistanceFromUser(distanceText: distanceText);

  Widget adDescription() => AdDescription(description: _pet.breed);

  Widget adPostedAt() => AdPostedAt(createdAt: _pet.createdAt!);

  Widget adInteresteds() => AdInteresteds(petKind: _pet.type);

  Widget adImages() => AdImages(photos: _pet.photos!);

  Widget adViews() => AdViews(views: _pet.views!);

  Widget adTitle() => AdTitle(title: _pet.name!);

  Widget divider() => Divider(height: 8.0.h);

  Widget favoriteButton() => FavoriteButton();

  Widget adCityState() => AdCityState(
        state: _pet.state,
        city: _pet.city,
      );
}
