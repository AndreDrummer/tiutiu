import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/profile/views/more.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final screens = <Widget>[
  DonateList(),
  FinderList(),
  AuthenticatedArea(child: InitPostFlow()),
  authController.user?.emailVerified ?? false
      ? AuthenticatedArea(child: MyContacts())
      : Obx(() => AuthenticatedArea(child: More(user: tiutiuUserController.tiutiuUser))),
  Obx(() => AuthenticatedArea(child: More(user: tiutiuUserController.tiutiuUser))),
];
