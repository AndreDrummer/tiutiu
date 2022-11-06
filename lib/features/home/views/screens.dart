import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/posts/views/select_post_type.dart';
import 'package:tiutiu/features/profile/views/edit_profile.dart';
import 'package:tiutiu/features/auth/views/validated_area.dart';
import 'package:tiutiu/features/auth/views/verify_phone.dart';
import 'package:tiutiu/features/auth/views/verify_email.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final screens = <Widget>[
  DonateList(),
  DisappearedList(),
  Obx(
    () {
      print(tiutiuUserController.tiutiuUser.emailVerified);
      return AuthenticatedArea(
        child: ValidatedArea(
          isValid:
              true, //tiutiuUserController.tiutiuUser.emailVerified && tiutiuUserController.tiutiuUser.phoneVerified,
          fallbackChild: !tiutiuUserController.tiutiuUser.emailVerified ? VerifyEmail() : VerifyPhone(),
          validChild: SelectPostType(),
        ),
      );
    },
  ),
  AuthenticatedArea(
    child: Obx(
      () => IndexedStack(
        index: profileController.isSetting ? 1 : 0,
        children: [
          Profile(user: tiutiuUserController.tiutiuUser),
          EditProfile(),
        ],
      ),
    ),
  ),
  AuthenticatedArea(child: Favorites()),
];
