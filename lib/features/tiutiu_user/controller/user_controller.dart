import 'package:flutter/foundation.dart';
import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TiutiuUserController extends GetxController {
  TiutiuUserController(TiutiuUserService tiutiuUserService)
      : _tiutiuUserService = tiutiuUserService;

  final TiutiuUserService _tiutiuUserService;

  final Rx<TiutiuUser> _tiutiuUser = TiutiuUser().obs;
  final RxBool _isLoading = false.obs;

  TiutiuUserService get service => _tiutiuUserService;
  TiutiuUser get tiutiuUser => _tiutiuUser.value;
  bool get isLoading => _isLoading.value;

  void updateTiutiuUser(
    TiutiuUserEnum property,
    dynamic data, [
    bool replace = false,
  ]) {
    if (replace && data is TiutiuUser) {
      _tiutiuUser(data);
    } else {
      Map<String, dynamic> map = _tiutiuUser.value.toMap();
      map[property.name] = data;

      TiutiuUser newTiutiuUser = TiutiuUser.fromMap(map);

      _tiutiuUser(newTiutiuUser);
    }
  }

  void set isLoading(bool value) => _isLoading(value);

  Future<void> handleNotifications(data) async {}

  Stream<QuerySnapshot> loadNotifications() {
    return _tiutiuUserService.loadNotifications(tiutiuUser.uid!);
  }

  Future<TiutiuUser> getUserById(String id) async {
    final TiutiuUser user = await _tiutiuUserService.getUserByID(id);
    return user;
  }

  Future<void> updateUserDataOnServer() async {
    var avatarPath = tiutiuUser.avatar;

    isLoading = true;
    if (avatarPath != null && !avatarPath.toString().isUrl()) {
      debugPrint('>> Updating Avatar...');
      var urlAvatar = await _tiutiuUserService.uploadAvatar(
        tiutiuUser.uid ?? authController.user!.uid,
        avatarPath,
      );

      updateTiutiuUser(TiutiuUserEnum.avatar, urlAvatar);
    }

    _tiutiuUserService.updateUser(userData: tiutiuUser);
    isLoading = false;
  }

  Future<void> updateLoggedUserData(String userId) async {
    _tiutiuUser(await getUserById(userId));
  }

  void resetUserWithThisUser({TiutiuUser? user}) {
    _tiutiuUser(user ?? TiutiuUser());
  }
}
