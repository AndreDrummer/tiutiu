import 'package:tiutiu/core/widgets/cards/widgets/ad_distance_from_user.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_description.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_city_state.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_posted_at.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_images.dart';
import 'package:tiutiu/features/saveds/widgets/save_button.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_title.dart';
import 'package:tiutiu/core/widgets/cards/widgets/ad_views.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:flutter/material.dart';

class CardBuilder {
  const CardBuilder({
    required this.distanceText,
    this.inReviewMode = false,
    required Post post,
  }) : _post = post;

  final String distanceText;
  final bool inReviewMode;
  final Post _post;

  Widget saveButton({required bool show}) => SaveOrUnsave(post: _post, tiny: true, show: show);

  Widget adCityState() => AdCityState(state: (_post as Pet).state, city: (_post as Pet).city);

  Widget adDescription({required double maxFontSize}) =>
      AdDescription(description: (_post as Pet).breed, maxFontSize: maxFontSize);

  Widget adDistanceFromUser() => AdDistanceFromUser(distanceText: distanceText);

  Widget adPostedAt() => AdPostedAt(createdAt: (_post as Pet).createdAt!);

  Widget adImages() => AdImages(photos: (_post as Pet).photos);

  Widget adTitle() => AdTitle(title: (_post as Pet).name!);

  Widget adViews() => AdViews(post: _post);
}
