import 'package:get/get.dart';
import 'package:tiutiu/features/auth/controller/auth_controller.dart';
import 'package:tiutiu/features/favorites/controller/favorites_controller.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/features/system/controller/system_controller.dart';

final CurrentLocationController currentLocationController = Get.find();
final FavoritesController favoritesController = Get.find();
final AuthController authController = Get.find();
final SystemController system = Get.find();
