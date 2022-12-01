import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/profile/views/more.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final screens = <Widget>[
  DonateList(),
  FinderList(),
  Obx(() => AuthenticatedArea(child: More(user: tiutiuUserController.tiutiuUser))),
];
