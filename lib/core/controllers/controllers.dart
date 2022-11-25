import 'package:tiutiu/core/location/controller/current_location_controller.dart';
import 'package:tiutiu/features/favorites/controller/favorites_controller.dart';
import 'package:tiutiu/features/delete_account/controller/delete_account.dart';
import 'package:tiutiu/features/tiutiu_user/controller/user_controller.dart';
import 'package:tiutiu/features/profile/controller/profile_controller.dart';
import 'package:tiutiu/features/talk_with_us/controller/talk_with_us.dart';
import 'package:tiutiu/features/posts/controller/filter_controller.dart';
import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:tiutiu/core/system/controller/system_controller.dart';
import 'package:tiutiu/features/auth/controller/auth_controller.dart';
import 'package:tiutiu/features/chat/controller/chat_controller.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/full_screen/controller/controller.dart';
import 'package:get/get.dart';

final CurrentLocationController currentLocationController = Get.find();
final DeleteAccountController deleteAccountController = Get.find();
final TiutiuUserController tiutiuUserController = Get.find();
final FullscreenController fullscreenController = Get.find();
final TalkWithUsController talkWithUsController = Get.find();
final FavoritesController favoritesController = Get.find();
final ProfileController profileController = Get.find();
final FilterController filterController = Get.find();
final SystemController systemController = Get.find();
final PostsController postsController = Get.find();
final HomeController homeController = Get.find();
final ChatController chatController = Get.find();
final AuthController authController = Get.find();
