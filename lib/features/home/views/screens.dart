import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/favorites/screen/favorites.dart';
import 'package:tiutiu/features/profile/views/edit_profile.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final screens = <Widget>[
  DonateList(),
  FinderList(),
  InitPostFlow(),
  Obx(
    () => AuthenticatedArea(
      child: IndexedStack(
        index: profileController.isSetting ? 1 : 0,
        children: [
          Profile(user: tiutiuUserController.tiutiuUser),
          EditProfile(isEditingProfile: profileController.isSetting),
        ],
      ),
    ),
  ),
  AuthenticatedArea(child: Favorites()),
];
