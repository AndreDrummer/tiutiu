import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';

final screens = <Widget>[
  DonateList(),
  DisappearedList(),
  AuthenticatedArea(child: Favorites()),
  AuthenticatedArea(child: Profile(user: tiutiuUserController.tiutiuUser)),
  AuthenticatedArea(child: Favorites()),
];
